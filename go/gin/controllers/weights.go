package controllers

import (
	"main/db"
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type WriteWeightsRequestBody struct {
	BatchId string     `json:"batch_id"`
	Batch   []db.Entry `json:"batch"`
}

// POST /weights
func WriteWeights(c *gin.Context) {
	val, ok := c.Get("db")
	if ok != true {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "borked"})
		return
	}
	db := val.(*gorm.DB)

	// serialize the request body to struct
	var payload WriteWeightsRequestBody
	// https://stackoverflow.com/a/70077055/9823455
	if err := c.BindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	for i := range payload.Batch {
		payload.Batch[i].BatchID = &payload.BatchId
	}

	db.CreateInBatches(payload.Batch, 100)

	c.JSON(http.StatusCreated, gin.H{
		"message": "ok",
	})
}

type ListWeightsResponseBody struct {
	BatchId string     `json:"batch_id"`
	Batch   []db.Entry `json:"batch"`
}

// GET /weights/:batch_id
func ListWeights(c *gin.Context) {
	val, ok := c.Get("db")
	if ok != true {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "borked"})
		return
	}
	batchId := c.Param("batch_id")

	var entries []db.Entry

	db := val.(*gorm.DB)
	db.Omit("id", "batch_id").Find(&entries, "batch_id = ?", batchId)

	response := ListWeightsResponseBody{
		BatchId: batchId,
		Batch:   entries,
	}
	c.JSON(http.StatusOK, response)
}
