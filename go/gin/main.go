package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	// "github.com/mvrilo/go-redoc"
	// ginredoc "github.com/mvrilo/go-redoc/gin"
)

// func BasicMiddleware() gin.HandlerFunc {
// 	return func(c *gin.Context) {
// 		fmt.Println(" ==> Middleware 🐰 🎩 🪄")
// 		c.Next()
// 	}
// }

func main() {
	r := gin.Default()
	// r.Use(BasicMiddleware())

	// r.Use(ginredoc.New(redoc.Redoc{
	// 	Title:       "Example API",
	// 	Description: "Example API Description",
	// 	SpecFile:    "./swagger.yaml",
	// 	SpecPath:    "/swagger.yaml",
	// 	DocsPath:    "/docs",
	// }))

	r.GET("/", func(c *gin.Context) {
		c.Header("Content-Type", "text/html; charset=utf-8")
		c.String(http.StatusOK, `<html>
        <head>
            <title>Hello from Go + Gin 🥃!</title>
            <meta name="color-scheme" content="light dark">
        </head>
        <body>
            <h3>Hello from Go + Gin 🥃!</h3>
            <p>Visit <a href="/ping">/ping</a></p>
        </body>
    </html>
		`)
	})

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Println("Will listen on http://localhost:8080")
	panic(r.Run(":" + port))
}
