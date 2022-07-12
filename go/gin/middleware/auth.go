package middleware

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

// basic authentication middleware
func RequireAuth(c *gin.Context) {
	token := os.Getenv("AUTH_TOKEN")
	if token == "" {
		c.AbortWithStatus(http.StatusInternalServerError)
	}

	val := c.GetHeader("Authorization")
	if val != "Bearer "+token {
		c.AbortWithStatus(http.StatusUnauthorized)
		return
	}
	c.Next()
}
