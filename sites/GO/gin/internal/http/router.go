package http

import (
	"database/sql"
	"dkdev/httpserver/internal/auth"
	"fmt"
	"net/http"
	"os"

	"dkdev/httpserver/internal/events"
	"dkdev/httpserver/internal/users"

	"github.com/gin-gonic/gin"
)

func NewRouter(db *sql.DB) *gin.Engine {
	r := gin.Default()

	// templates + static
	r.LoadHTMLGlob("templates/*")
	r.Static("/static", "./static")

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	r.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", gin.H{"Port": port})
	})

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})

	// === ROUTES ===
	// add "api" prefix to routes
	r.Group("/api")

	// === USERS / AUTH ===
	userRepo := users.NewRepository(db)
	userSvc := users.NewService(userRepo)
	userHandler := users.NewHandler(userSvc)
	usersGroup := r.Group("/api/auth")
	userHandler.RegisterRoutes(usersGroup)

	// === EVENTS ===
	eventsRepo := events.NewRepository(db)
	eventsSvc := events.NewService(eventsRepo)
	eventsHandler := events.NewHandler(eventsSvc)
	eventsGroup := r.Group("/api/events")
	eventsGroup.Use(auth.AuthMiddleware())
	{
		eventsHandler.RegisterRoutes(eventsGroup)
	}

	for _, route := range r.Routes() {
		fmt.Printf("%s\t%s\t%s\n", route.Method, route.Path, route.Handler)
	}

	return r
}
