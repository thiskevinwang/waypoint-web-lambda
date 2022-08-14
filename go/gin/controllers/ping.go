package controllers

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func Ping(c *gin.Context) {
	foobar := os.Getenv("FOOBAR")
	c.JSON(http.StatusOK, gin.H{
		"message": "pong",
		"foobar":  foobar,
	})
}
