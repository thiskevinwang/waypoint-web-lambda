package routes

import (
	"main/controllers"
	"main/middleware"

	"github.com/gin-gonic/gin"
)

// the routes and handlers are registered on the base path (/)
func CreateRoutes(rg *gin.RouterGroup) {
	rg.GET("/ping", controllers.Ping)
	rg.GET("/health", controllers.HealthCheck)

	weights := rg.Group("/weights")
	weights.Use(middleware.RequireAuth)
	weights.POST("/", controllers.WriteWeights)
	weights.GET("/:batch_id", controllers.ListWeights)
}
