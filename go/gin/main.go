package main

import (
	"encoding/json"
	"io/ioutil"
	"net"
	"net/http"
	"net/url"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/mvrilo/go-redoc"
	ginredoc "github.com/mvrilo/go-redoc/gin"
)

func BasicMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Next()
	}
}

func main() {
	doc := redoc.Redoc{
		Title:       "Example API",
		Description: "Example API Description",
		SpecFile:    "./swagger.yaml", //
		SpecPath:    "/swagger.yaml",
		DocsPath:    "/docs",
	}

	// Set mode to "release"
	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()
	r.Use(BasicMiddleware())
	r.Use(ginredoc.New(doc))

	r.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Hello from Gin 🟦🐹🥃!")
	})
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})
	r.GET("/cache/:name", handleGetCacheItem)

	r.GET("/_healthz", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "OK",
		})
	})

	// log.Info("Will listen on http://localhost:8080")
	// http.ListenAndServe(":8080", r)
	// println("Documentation served at http://127.0.0.1:8080/docs")

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	panic(r.Run(":" + port))
}

// This handler will read cache values from the cache "sidecar" server, running on port 4000
func handleGetCacheItem(c *gin.Context) {
	name := c.Param("name")

	// sidecar url
	u := url.URL{
		Scheme: "http",
		Host:   "localhost:4000",
		Path:   "/dynamodb",
	}
	query := u.Query()
	query.Set("name", name)
	ip := getClientIP(c)
	query.Set("ip", ip)

	u.RawQuery = query.Encode()

	resp, err := http.Get(u.String())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Error getting data from sidecar",
		})
		return
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Error reading data from sidecar",
		})
		return
	}

	var mymap map[string]interface{}
	if err := json.Unmarshal(body, &mymap); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Error unmarshalling data from sidecar",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": mymap,
		"status":  resp.StatusCode,
	})
	return
}

// https://github.com/gin-gonic/gin/issues/2697#issuecomment-910248687
func getClientIP(c *gin.Context) string {
	forwardHeader := c.Request.Header.Get("x-forwarded-for")
	firstAddress := strings.Split(forwardHeader, ",")[0]
	if net.ParseIP(strings.TrimSpace(firstAddress)) != nil {
		return firstAddress
	}
	return c.ClientIP()
}
