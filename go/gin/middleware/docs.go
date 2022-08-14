package middleware

import (
	"github.com/mvrilo/go-redoc"
	ginredoc "github.com/mvrilo/go-redoc/gin"
)

var (
	Docs = ginredoc.New(redoc.Redoc{
		Title:       "Example API",
		Description: "Example API Description",
		SpecFile:    "./swagger.yaml",
		SpecPath:    "/swagger.yaml",
		DocsPath:    "/",
	})
)
