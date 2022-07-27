package main

import (
	"fmt"
	"os"

	"main/db"
	"main/middleware"
	"main/routes"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// make `db` available on gin context
	r.Use(db.Middleware)

	// render docs at GET /
	r.Use(middleware.Docs)

	rg := r.Group("/")
	routes.CreateRoutes(rg)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Println("Will listen on http://localhost:8080")
	fmt.Println("Will listen on http://192.168.1.250:8080")

	panic(r.Run(":" + port))
}
