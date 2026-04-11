package main

import (
	"fmt"
	"github.com/Aidarkhan-hub/finance-tracker-backend/finance-tracker-backend/database"
	"github.com/Aidarkhan-hub/finance-tracker-backend/finance-tracker-backend/handlers"
	"github.com/Aidarkhan-hub/finance-tracker-backend/finance-tracker-backend/middleware"
	"github.com/gin-gonic/gin"
	"log"
)

func main() {
	database.InitDB()
	r := gin.Default()

	r.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	api := r.Group("/api/v1")
	{
		api.POST("/signup", handlers.SignUp)
		api.POST("/signin", handlers.SignIn)
		api.GET("/health", handlers.HealthCheck)

		protected := api.Group("/")
		protected.Use(middleware.AuthMiddleware())
		{
			protected.POST("/transactions", handlers.CreateTransaction)
			protected.GET("/transactions", handlers.GetTransactions)
			protected.GET("/transactions/:id", handlers.GetTransactionByID)
			protected.PUT("/transactions/:id", handlers.UpdateTransaction)
			protected.DELETE("/transactions/:id", handlers.DeleteTransaction)
			protected.GET("/summary/balance", handlers.GetBalance)
			protected.GET("/transactions/category/:category", handlers.GetByCategory)
			protected.GET("/transactions/search", handlers.SearchTransactions)
			protected.DELETE("/transactions/purge", handlers.PurgeTransactions)
		}
	}

	port := ":8080"
	fmt.Println("Server running on http://localhost" + port)
	if err := r.Run(port); err != nil {
		log.Fatalf("Failed to start: %v", err)
	}
}
