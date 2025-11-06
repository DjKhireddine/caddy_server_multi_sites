package main

import (
	"encoding/json"
	"fmt"
	"html/template"
	"io"
	"net/http"
	"os"

	"github.com/gorilla/mux"
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
	r := mux.NewRouter()

	tmpl := template.Must(template.ParseFiles("layout.html"))

	featuredBooks, _ := getBooksFromJsonFile()

	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {

		data := PageData{
			PageTitle:     "Librairie en Ligne - Livres & eBooks",
			FeaturedBooks: featuredBooks,
			Categories:    []string{"Roman", "Polar", "Science-Fiction", "Fantasy", "Biographie", "Jeunesse"},
		}

		tmpl.Execute(w, data)
	})

	// Servir les fichiers statiques avec gorilla/mux
	r.PathPrefix("/static/").Handler(http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))

	r.HandleFunc("/books/{title}", ReadBook).Methods("GET")
	r.HandleFunc("/books/{title}/page/{page}", func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		title := vars["title"]
		page := vars["page"]

		_, err := fmt.Fprintf(w, "You've requested the book: %s on page %s\n", title, page)
		if err != nil {
			return
		}
	})

	fmt.Println("Server running on port 80")
	err := http.ListenAndServe(":80", r)
	if err != nil {
		fmt.Printf("Error starting server: %s\n", err)
		return
	}
}

func ReadBook(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	title := vars["title"]

	_, err := fmt.Fprintf(w, "Read the book: %s\n", title)
	if err != nil {
		return
	}
}
