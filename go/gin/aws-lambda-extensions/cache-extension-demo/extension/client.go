// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

package extension

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
)

// RegisterResponse is the body of the response for /register
type RegisterResponse struct {
	FunctionName    string `json:"functionName"`
	FunctionVersion string `json:"functionVersion"`
	Handler         string `json:"handler"`
}

// NextEventResponse is the response for /event/next
type NextEventResponse struct {
	EventType          EventType `json:"eventType"`
	DeadlineMs         int64     `json:"deadlineMs"`
	RequestID          string    `json:"requestId"`
	InvokedFunctionArn string    `json:"invokedFunctionArn"`
	Tracing            Tracing   `json:"tracing"`
}

// Tracing is part of the response for /event/next
type Tracing struct {
	Type  string `json:"type"`
	Value string `json:"value"`
}

// EventType represents the type of events received from /event/next
type EventType string

const (
	// Invoke is a lambda invoke
	Invoke EventType = "INVOKE"

	// Shutdown is a shutdown event for the environment
	Shutdown EventType = "SHUTDOWN"

	// Headers...
	// The full file name of the extension. Required: yes. Type: string.
	extensionNameHeader = "Lambda-Extension-Name"

	// Response headers...
	// Generated unique agent identifier (UUID string) that is required for all subsequent requests.
	extensionIdentiferHeader = "Lambda-Extension-Identifier"
)

// ExtensionsApiClient is a simple client for the Lambda Extensions API
// - https://docs.aws.amazon.com/lambda/latest/dg/runtimes-extensions-api.html
type ExtensionsApiClient struct {
	// http://${AWS_LAMBDA_RUNTIME_API}/2020-01-01/extension
	baseURL     string
	httpClient  *http.Client
	extensionID string
}

// NewExtensionsApiClient returns a Lambda Extensions API client
func NewExtensionsApiClient() *ExtensionsApiClient {
	u := url.URL{
		Scheme: "http",
		Host:   os.Getenv("AWS_LAMBDA_RUNTIME_API"),
		Path:   "/2020-01-01/extension",
	}
	// baseURL := fmt.Sprintf("http://%s/2020-01-01/extension", os.Getenv("AWS_LAMBDA_RUNTIME_API"))
	return &ExtensionsApiClient{
		baseURL:    u.String(),
		httpClient: &http.Client{},
	}
}

// Register will register the extension with the Extensions API
// - POST http://${AWS_LAMBDA_RUNTIME_API}/2020-01-01/extension/register
func (e *ExtensionsApiClient) Register(ctx context.Context, filename string) (*RegisterResponse, error) {
	const action = "/register"
	url := e.baseURL + action

	// {
	// 	'events': [ 'INVOKE', 'SHUTDOWN']
	// }
	reqBody, err := json.Marshal(map[string]interface{}{
		"events": []EventType{Invoke, Shutdown},
	})
	if err != nil {
		return nil, err
	}
	httpReq, err := http.NewRequestWithContext(ctx, "POST", url, bytes.NewBuffer(reqBody))
	if err != nil {
		return nil, err
	}
	httpReq.Header.Set(extensionNameHeader, filename)
	httpRes, err := e.httpClient.Do(httpReq)
	if err != nil {
		return nil, err
	}
	if httpRes.StatusCode != 200 {
		return nil, fmt.Errorf("request failed with status %s", httpRes.Status)
	}
	defer httpRes.Body.Close()
	// {
	// 	"functionName": "helloWorld",
	// 	"functionVersion": "$LATEST",
	// 	"handler": "lambda_function.lambda_handler"
	// }
	body, err := ioutil.ReadAll(httpRes.Body)
	if err != nil {
		return nil, err
	}
	res := RegisterResponse{}
	err = json.Unmarshal(body, &res)
	if err != nil {
		return nil, err
	}
	e.extensionID = httpRes.Header.Get(extensionIdentiferHeader)
	return &res, nil
}

// NextEvent blocks while long polling for the next lambda invoke or shutdown
// - GET http://${AWS_LAMBDA_RUNTIME_API}/2020-01-01/extension/event/next
func (e *ExtensionsApiClient) NextEvent(ctx context.Context) (*NextEventResponse, error) {
	const action = "/event/next"
	url := e.baseURL + action

	httpReq, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return nil, err
	}
	httpReq.Header.Set(extensionIdentiferHeader, e.extensionID)
	httpRes, err := e.httpClient.Do(httpReq)
	if err != nil {
		return nil, err
	}
	if httpRes.StatusCode != 200 {
		return nil, fmt.Errorf("request failed with status %s", httpRes.Status)
	}
	defer httpRes.Body.Close()
	body, err := ioutil.ReadAll(httpRes.Body)
	if err != nil {
		return nil, err
	}
	res := NextEventResponse{}
	err = json.Unmarshal(body, &res)
	if err != nil {
		return nil, err
	}
	return &res, nil
}
