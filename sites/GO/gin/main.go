package main

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	// Charger les templates HTML
	router.LoadHTMLGlob("templates/*")
	router.Static("/static", "./static")

	port := os.Getenv("PORT")
	if port == "" {
		port = "80"
	}

	// Routes de l'API
	router.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", gin.H{
			"Port": port,
		})
	})

	router.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":      "ok",
			"message":     "Go Gin API is running",
			"gin_version": gin.Version,
		})
	})

	router.GET("/api/hello", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Hello from Go + Gin! 🚀",
			"tech":    "Golang Gin Framework",
		})
	})

	router.GET("/api/status", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":    "running",
			"framework": "Gin",
			"language":  "Go",
			"performance": gin.H{
				"goroutines": "high",
				"memory":     "low",
				"speed":      "fast",
			},
		})
	})

	// Démarrer le serveur
	router.Run(":" + port)
}
