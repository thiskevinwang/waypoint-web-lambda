// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

package plugins

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
)

// Struct to store Dynamodb cache confirmation
type DynamodbConfiguration struct {
	Table        string
	HashKey      string
	HashKeyType  string
	HashKeyValue string
	SortKey      string
	SortKeyType  string
	SortKeyValue string
}

// Struct for caching the information
type Dynamodb struct {
	CacheData             CacheData
	DynamodbConfiguration DynamodbConfiguration
}

var DynamoDbCache = make(map[string]Dynamodb)
var DynamoDbClient = GetDynamoDbClient()

// Initialize map and cache data (only if requested)
func InitDynamodb(dynamodbConfiguration []DynamodbConfiguration, initializeCache bool) {
	// aws-lambda-extensions/cache-extension-demo/plugins.InitDynamodb
	println(PrintPrefix, fmt.Sprintf("InitDynamodb - initializeCache: %t", initializeCache))

	for _, dynamodbConfig := range dynamodbConfiguration {
		if initializeCache {
			// Read data from Dynamodb
			GetDataAndPopulateCache(dynamodbConfig)
		} else {
			DynamoDbCache[GetKey(dynamodbConfig)] = Dynamodb{
				CacheData:             CacheData{},
				DynamodbConfiguration: dynamodbConfig,
			}
		}
	}
}

// Read data from Dynamodb and return it as json string
func GetDataAndPopulateCache(dynamodbConfig DynamodbConfiguration) Dynamodb {
	println(PrintPrefix, fmt.Sprintf("GetDataAndPopulateCache - table: %q, hashKey: %q, hashKeyValue: %q, sortKey: %q, sortKeyValue: %q", dynamodbConfig.Table, dynamodbConfig.HashKey, dynamodbConfig.HashKeyValue, dynamodbConfig.SortKey, dynamodbConfig.SortKeyValue))
	if dynamodbConfig.HashKey != "" {
		// Create attributeValue map based on hash and sort key
		var attributeMap = map[string]*dynamodb.AttributeValue{}
		// this will mutate `attributeMap`
		UpdateAttributeMap(attributeMap, dynamodbConfig)

		result, err := DynamoDbClient.GetItem(&dynamodb.GetItemInput{
			TableName: aws.String(dynamodbConfig.Table),
			Key:       attributeMap,
		})
		// handle errors
		if err != nil {
			if aerr, ok := err.(awserr.Error); ok {
				switch aerr.Code() {
				case dynamodb.ErrCodeProvisionedThroughputExceededException:
					println(dynamodb.ErrCodeProvisionedThroughputExceededException, aerr.Error())
				case dynamodb.ErrCodeResourceNotFoundException:
					println(dynamodb.ErrCodeResourceNotFoundException, aerr.Error())
				case dynamodb.ErrCodeRequestLimitExceeded:
					println(dynamodb.ErrCodeRequestLimitExceeded, aerr.Error())
				case dynamodb.ErrCodeInternalServerError:
					println(dynamodb.ErrCodeInternalServerError, aerr.Error())
				default:
					println(PrintPrefix, "GetData", PrettyPrint(aerr.Error()))
				}
			} else {
				println(PrintPrefix, "GetData", PrettyPrint(err.Error()))
			}
			panic(err.Error())
		}

		if result.Item == nil {
			println(PrintPrefix, fmt.Sprintf("GetDataAndPopulateCache - Could not find item: HashKey: %q, SortKey: %q", dynamodbConfig.HashKeyValue, dynamodbConfig.SortKeyValue))
			panic(fmt.Sprintf("GetDataAndPopulateCache - Could not find item: HashKey: %q, SortKey: %q", dynamodbConfig.HashKeyValue, dynamodbConfig.SortKeyValue))
		}
		println(PrintPrefix, fmt.Sprintf("GetDataAndPopulateCache - Found item: HashKey: %q, SortKey: %q", dynamodbConfig.HashKeyValue, dynamodbConfig.SortKeyValue))

		// marshall dynamo result into a go data structure
		var data = make(map[string]string)
		if err = dynamodbattribute.UnmarshalMap(result.Item, &data); err != nil {
			msg := fmt.Sprintf("GetDataAndPopulateCache - Failed to unmarshall dynamo item to JSON: %q", err.Error())
			println(PrintPrefix, msg)
			panic(msg)
		}

		// Add it to the cache
		db := Dynamodb{
			CacheData: CacheData{
				Data:        data,
				CacheExpiry: GetCacheExpiry(),
				HitCount:    1,
			},
			DynamodbConfiguration: dynamodbConfig,
		}

		// update the cache,
		DynamoDbCache[GetKey(dynamodbConfig)] = db

		// println(PrintPrefix, fmt.Sprintf("GetDataAndPopulateCache - value: %q", value))
		return db
	} else {
		println(PrintPrefix, fmt.Sprintf("GetDataAndPopulateCache - HashKey not available so caching will not be enabled for %s", dynamodbConfig.HashKey))
		panic(fmt.Sprintf("GetDataAndPopulateCache - HashKey not available so caching will not be enabled for %s", dynamodbConfig.HashKey))
	}
}

// Generate key to store in map based with a format "tableName+"-"+hashKeyValue+"-"+sortKeyValue"
func GetKey(dynamodbConfig DynamodbConfiguration) string {
	var key = dynamodbConfig.Table + "-" + dynamodbConfig.HashKeyValue
	if dynamodbConfig.SortKey != "" {
		key += "-" + dynamodbConfig.SortKeyValue
	}
	return key
}

// Get Dynamodb to read data
func GetDynamoDbClient() *dynamodb.DynamoDB {
	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	// Create Dynamodb client
	return dynamodb.New(sess)
}

// Create attributeValue based on key type and presence of sortKey definition
// Mutates `attributeMap`
func UpdateAttributeMap(attributeMap map[string]*dynamodb.AttributeValue, dynamodbConfig DynamodbConfiguration) {
	GetAttributeValue(attributeMap, dynamodbConfig.HashKey, dynamodbConfig.HashKeyValue, dynamodbConfig.HashKeyType)
	if dynamodbConfig.SortKey != "" {
		GetAttributeValue(attributeMap, dynamodbConfig.SortKey, dynamodbConfig.SortKeyValue, dynamodbConfig.SortKeyType)
	}
}

// Supports attributeValue with data types "S" and "N"
func GetAttributeValue(attributeMap map[string]*dynamodb.AttributeValue, key string, value string, keyType string) {
	switch keyType {
	case "S":
		attributeMap[key] = &dynamodb.AttributeValue{S: aws.String(value)}
	case "N":
		attributeMap[key] = &dynamodb.AttributeValue{N: aws.String(value)}
	}
}

// Fetch Dynamodb cache
func GetDynamodbCache(name string) Dynamodb {
	println(PrintPrefix, fmt.Sprintf("GetDynamodbCache - name: %q", name))
	var dbCache = DynamoDbCache[name]

	// If expired or not available in cache then read it from Dynamodb, else return from cache
	if len(dbCache.CacheData.Data) == 0 {
		println(PrintPrefix, "GetDynamodbCache - cache not available, reading from dynamodb")
		cd := GetDataAndPopulateCache(DynamoDbCache[name].DynamodbConfiguration)
		return cd
	} else if IsExpired(dbCache.CacheData.CacheExpiry) {
		println(PrintPrefix, "GetDynamodbCache - cache expired, reading from dynamodb")
		cd := GetDataAndPopulateCache(DynamoDbCache[name].DynamodbConfiguration)
		return cd
	} else {
		println(PrintPrefix, "GetDynamodbCache - cache available, returning from cache")

		// Increment hit count
		cd := DynamoDbCache[name]
		cd.CacheData.HitCount++
		DynamoDbCache[name] = cd

		return cd
	}
}
