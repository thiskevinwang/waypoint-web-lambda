package db

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

// This middleware will make db present
func Connection() *gorm.DB {
	postgresPort := os.Getenv("POSTGRES_PORT")
	postgresDB := os.Getenv("POSTGRES_DB")
	postgresHost := os.Getenv("POSTGRES_HOST")
	postgresUser := os.Getenv("POSTGRES_USER")
	postgresPassword := os.Getenv("POSTGRES_PASSWORD")

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s", postgresHost, postgresUser, postgresPassword, postgresDB, postgresPort)
	db, err := gorm.Open(postgres.New(postgres.Config{DSN: dsn}), &gorm.Config{})

	if err != nil {
		panic(err)
	}

	return db
}

// sets a gorm.DB to the gin.Context
func Middleware(c *gin.Context) {
	db := Connection()

	// https://gorm.io/docs/#Quick-Start
	err := db.AutoMigrate(&Entry{})
	if err != nil {
		panic(err)
	}

	c.Set("db", db)
	c.Next()
}
