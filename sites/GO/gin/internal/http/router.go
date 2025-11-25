package http

import (
	"database/sql"
	"net/http"
	"os"

	"dkdev/httpserver/internal/events"

	"github.com/gin-gonic/gin"
)

func NewRouter(db *sql.DB) *gin.Engine {
	r := gin.Default()

	// static + templates
	r.LoadHTMLGlob("templates/*")
	r.Static("static", "./static")

	// page d'accueil
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}
	r.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", gin.H{"Port": port})
	})

	// health endpoints
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})

	// events module
	repo := events.NewRepository(db)
	svc := events.NewService(repo)
	h := events.NewHandler(svc)
	h.RegisterRoutes(r)

	return r
}
