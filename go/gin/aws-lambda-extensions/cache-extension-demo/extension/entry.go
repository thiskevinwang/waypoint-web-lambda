// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

package extension

import (
	"aws-lambda-extensions/cache-extension-demo/plugins"
	"io/ioutil"
	"log"
	"os"
	"strconv"

	"gopkg.in/yaml.v2"
)

// Constants definition
const (
	Parameters               = "parameters"
	Dynamodb                 = "dynamodb"
	FileName                 = "/var/task/config.yaml"
	InitializeCacheOnStartup = "CACHE_EXTENSION_INIT_STARTUP"
)

// Struct for storing CacheConfiguration
type CacheConfig struct {
	Parameters []plugins.ParameterConfiguration
	Dynamodb   []plugins.DynamodbConfiguration
}

var cacheConfig = CacheConfig{}

// Initialize cache and start the background process to refresh cache
func InitCacheExtensions() {
	println(plugins.PrintPrefix, "Initializing cache extensions...")
	// Read the cache config.yaml file
	data := LoadConfigFile()

	// Unmarshal the configuration to struct
	if err := yaml.Unmarshal([]byte(data), &cacheConfig); err != nil {
		log.Fatalf(plugins.PrintPrefix, "error: %v", err)
	}
	// log.Println(plugins.PrintPrefix, "Cache configuration: %+v", cacheConfig)

	// Initialize Cache
	InitCache()
}

// Initialize individual cache
func InitCache() {
	println(plugins.PrintPrefix, "Initializing cache...")

	// Read Lambda env variable
	initCache := os.Getenv(InitializeCacheOnStartup)
	initCacheInBool := false

	if initCache != "" {
		cacheInBool, err := strconv.ParseBool(initCache)
		if err != nil {
			panic(plugins.PrintPrefix + "Error while converting CACHE_EXTENSION_INIT_STARTUP env variable " +
				initCache)
		} else {
			initCacheInBool = cacheInBool
		}
	}

	println(plugins.PrintPrefix, "initCacheInBool: ", initCacheInBool)

	// Initialize map and load data from individual services if "CACHE_EXTENSION_INIT_STARTUP" = true
	// plugins.InitParameters(cacheConfig.Parameters, initCacheInBool)

	plugins.InitDynamodb(cacheConfig.Dynamodb, initCacheInBool)
}

// Route request to corresponding cache handlers
// func RouteCache(cacheType string, name string) string {
// 	switch cacheType {
// 	case Parameters:
// 		return plugins.GetParameterCache(name)
// 	case Dynamodb:
// 		return plugins.GetDynamodbCache(name)
// 	default:
// 		return "Invalid cacheType: " + cacheType
// 	}
// }

// Load the config file
func LoadConfigFile() string {
	data, err := ioutil.ReadFile(FileName)
	if err != nil {
		panic(err)
	}

	return string(data)
}
