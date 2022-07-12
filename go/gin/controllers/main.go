package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type HealthCheckResponse struct {
	Now string `json:"now"`
}

// GET /health
func HealthCheck(c *gin.Context) {
	var db *gorm.DB
	if val, ok := c.Get("db"); ok {
		db = val.(*gorm.DB)
	} else {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "borked"})
		return
	}

	var response HealthCheckResponse
	// convert db query to go struct
	res := db.Raw("SELECT NOW()").Scan(&response)

	if res.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "database error",
		})
		return
	}

	// OK
	c.JSON(http.StatusOK, response)
}
