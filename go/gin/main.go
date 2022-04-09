package main

import (
	"net/http"

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
	r.GET("/_healthz", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "OK",
		})
	})

	// log.Info("Will listen on http://localhost:8080")
	// http.ListenAndServe(":8080", r)
	println("Documentation served at http://127.0.0.1:8080/docs")
	panic(r.Run(":8080"))
}
