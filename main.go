package main

import (
	"fmt"
	"net/http"
)

func main() {
	fmt.Println("Server starting on http://localhost:8080")
	
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Welcome to Finance Tracker API!")
	})

	if err := http.ListenAndServe(":8080", nil); err != nil {
		fmt.Println("Error starting server:", err)
	}
}