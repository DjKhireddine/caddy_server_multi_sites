package main

import (
	"database/sql"
	"log"
	"os"

	"dkdev/httpserver/internal/db"
	httphandler "dkdev/httpserver/internal/http"
)

func main() {
	database, err := db.Init()
	if err != nil {
		log.Fatal(err)
	}
	defer func(database *sql.DB) {
		err := database.Close()
		if err != nil {

		}
	}(database)

	router := httphandler.NewRouter(database)

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	if err := router.Run(":" + port); err != nil {
		log.Fatal(err)
	}
}
