// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

package ipc

import (
	"aws-lambda-extensions/cache-extension-demo/plugins"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

// Start begins running the sidecar
func Start(port string) {
	go startHTTPServer(port)
}

// Method that responds back with the cached values
func startHTTPServer(port string) {
	router := mux.NewRouter()
	router.Path("/{cacheType}").Queries("name", "{name}").HandlerFunc(
		func(w http.ResponseWriter, r *http.Request) {
			vars := mux.Vars(r)
			println("[sidecar]", fmt.Sprintf("name: %q", vars["name"]))
			println("[sidecar]", fmt.Sprintf("cacheType: %q", vars["cacheType"]))

			// ignore cacheType for now and go straight to DynamoDB
			// value := extension.RouteCache(vars["cacheType"], vars["name"])
			db := plugins.GetDynamodbCache(vars["name"])

			jsonData, err := json.Marshal(db)
			if err != nil {
				w.Write([]byte(fmt.Sprintf("Error: %s", err)))
			}

			// return json
			w.Header().Set("Content-Type", "application/json")

			w.Write(jsonData)
			// if len(value) != 0 {
			// 	w.Write([]byte(value))
			// } else {
			// 	w.Write([]byte("No data found"))
			// }
		})

	println("[sidecar]", "Starting Httpserver on port ", port)
	err := http.ListenAndServe(":"+port, router)
	if err != nil {
		panic(err)
	}
}
