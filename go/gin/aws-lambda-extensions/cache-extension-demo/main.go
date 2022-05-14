// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

package main

import (
	"aws-lambda-extensions/cache-extension-demo/extension"
	"aws-lambda-extensions/cache-extension-demo/ipc"
	"aws-lambda-extensions/cache-extension-demo/plugins"
	"context"
	"os"
	"os/signal"
	"syscall"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/dynamodb"
)

var (
	// AWS_LAMBDA_RUNTIME_API — The host and port of the runtime API.
	// https://docs.aws.amazon.com/lambda/latest/dg/runtimes-custom.html
	extensionClient = extension.NewExtensionsApiClient()
)

func main() {
	ctx, cancel := context.WithCancel(context.Background())

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGTERM, syscall.SIGINT)
	go func() {
		s := <-sigs
		cancel()
		println(plugins.PrintPrefix, "Received", s)
		println(plugins.PrintPrefix, "Exiting")
	}()

	// Register client
	res, err := extensionClient.Register(ctx, plugins.ExtensionName)
	if err != nil {
		panic(err)
	}
	println(plugins.PrintPrefix, "Register response:", plugins.PrettyPrint(res))

	// Initialize all the cache plugins
	extension.InitCacheExtensions()

	// Start HTTP server
	ipc.Start("4000")

	// Will block until shutdown event is received or cancelled via the context.
	processEvents(ctx)

	println("PROCESS ENDED... Can I flush some data here?")

	item:= map[string]*dynamodb.AttributeValue{
		"pk": &dynamodb.AttributeValue{
			S: aws.String("test"),
		},
		"sk": &dynamodb.AttributeValue{
			S: aws.String("test-too"),
		},
		"date": &dynamodb.AttributeValue{
			S: aws.String("test-date"),
		},
	}
	plugins.DynamoDbClient.PutItem(&dynamodb.PutItemInput{
		TableName: aws.String("lambda-cache-table"),
		Item: item
	})
}

// Method to process events
func processEvents(ctx context.Context) {
	for {
		select {
		case <-ctx.Done():
			return
		default:
			println(plugins.PrintPrefix, "Waiting for event...")
			res, err := extensionClient.NextEvent(ctx)
			if err != nil {
				println(plugins.PrintPrefix, "Error:", err)
				println(plugins.PrintPrefix, "Exiting")
				return
			}

			// Exit if we receive a SHUTDOWN event
			if res.EventType == extension.Shutdown {
				println(plugins.PrintPrefix, "Received SHUTDOWN event")
				println(plugins.PrintPrefix, "Exiting")
				return
			}
		}
	}
}
