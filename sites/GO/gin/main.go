package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

type Book struct {
	Title       string
	Author      string
	Price       float64
	Cover       string
	Description string
	Category    string
}

type PageData struct {
	PageTitle     string
	FeaturedBooks []Book
	Categories    []string
}

func getBooksFromJsonFile() ([]Book, error) {
	var books []Book
	jsonFile, err := os.Open("books.json")
	if err != nil {
		fmt.Println(err)
	}

	byteValue, _ := io.ReadAll(jsonFile)

	err = json.Unmarshal(byteValue, &books)
	if err != nil {
		return nil, err
	}

	return books, nil
}

func main() {
	// Create a Gin router with default middleware (logger and recovery)
	router := gin.Default()
	router.LoadHTMLGlob("templates/*")
	router.Static("/static", "./static")

	featuredBooks, _ := getBooksFromJsonFile()

	router.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", PageData{
			PageTitle:     "Go Gin - Livres & eBooks",
			FeaturedBooks: featuredBooks,
			Categories:    []string{"Roman", "Polar", "Science-Fiction", "Fantasy", "Biographie", "Jeunesse"},
		})
	})

	router.GET("/api/books", func(c *gin.Context) {
		// Return JSON response
		c.JSON(http.StatusOK, gin.H{
			"books": featuredBooks,
		})
	})

	err := router.Run(":3000")
	if err != nil {
		fmt.Printf("Error starting server: %s\n", err)
		return
	}

	fmt.Println("Server running on port 3000")
}
