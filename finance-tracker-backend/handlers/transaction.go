package handlers

import (
	"net/http"

	"github.com/Aidarkhan-hub/finance-tracker-backend/finance-tracker-backend/database"
	"github.com/Aidarkhan-hub/finance-tracker-backend/finance-tracker-backend/models"
	"github.com/gin-gonic/gin"
)

func getUserID(c *gin.Context) uint {
	id, _ := c.Get("userID")
	return id.(uint)
}

func CreateTransaction(c *gin.Context) {
	userID := getUserID(c)
	var t models.Transaction
	if err := c.ShouldBindJSON(&t); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}
	t.UserID = userID
	database.DB.Create(&t)
	c.JSON(http.StatusCreated, t)
}

func GetTransactions(c *gin.Context) {
	userID := getUserID(c)
	var ts []models.Transaction
	database.DB.Where("user_id = ?", userID).Find(&ts)
	c.JSON(http.StatusOK, ts)
}

func GetTransactionByID(c *gin.Context) {
	userID := getUserID(c)
	var t models.Transaction
	id := c.Param("id")
	if err := database.DB.Where("id = ? AND user_id = ?", id, userID).First(&t).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Transaction not found"})
		return
	}
	c.JSON(http.StatusOK, t)
}

func UpdateTransaction(c *gin.Context) {
	userID := getUserID(c)
	var t models.Transaction
	id := c.Param("id")
	if err := database.DB.Where("id = ? AND user_id = ?", id, userID).First(&t).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Transaction not found"})
		return
	}
	c.ShouldBindJSON(&t)
	database.DB.Save(&t)
	c.JSON(http.StatusOK, t)
}

func DeleteTransaction(c *gin.Context) {
	userID := getUserID(c)
	id := c.Param("id")
	result := database.DB.Where("id = ? AND user_id = ?", id, userID).Delete(&models.Transaction{})
	if result.RowsAffected == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "Not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Deleted"})
}

func GetBalance(c *gin.Context) {
	userID := getUserID(c)
	var income, expense float64
	database.DB.Model(&models.Transaction{}).Where("user_id = ? AND type = ?", userID, "income").Select("COALESCE(sum(amount), 0)").Row().Scan(&income)
	database.DB.Model(&models.Transaction{}).Where("user_id = ? AND type = ?", userID, "expense").Select("COALESCE(sum(amount), 0)").Row().Scan(&expense)
	c.JSON(http.StatusOK, gin.H{"total_balance": income - expense, "total_income": income, "total_expense": expense})
}

func GetByCategory(c *gin.Context) {
	userID := getUserID(c)
	var ts []models.Transaction
	category := c.Param("category")
	database.DB.Where("user_id = ? AND category = ?", userID, category).Find(&ts)
	c.JSON(http.StatusOK, ts)
}

func SearchTransactions(c *gin.Context) {
	userID := getUserID(c)
	query := c.Query("q")
	var ts []models.Transaction
	database.DB.Where("user_id = ? AND category ILIKE ?", userID, "%"+query+"%").Find(&ts)
	c.JSON(http.StatusOK, ts)
}

func PurgeTransactions(c *gin.Context) {
	userID := getUserID(c)
	database.DB.Where("user_id = ?", userID).Delete(&models.Transaction{})
	c.JSON(http.StatusOK, gin.H{"message": "Cleared"})
}
