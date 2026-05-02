package handlers

import (
	"net/http"
	"strconv"

	"github.com/Aidarkhan-hub/finance-tracker-backend/finance-tracker-backend/services"
	"github.com/gin-gonic/gin"
)

func GetExchangeRates(c *gin.Context) {
	base := c.DefaultQuery("base", "USD")

	rates, err := services.GetRates(base)
	if err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"base":  base,
		"rates": rates,
	})
}

func GetExchangeRate(c *gin.Context) {
	from := c.DefaultQuery("from", "USD")
	to := c.DefaultQuery("to", "KZT")

	rate, err := services.GetRate(from, to)
	if err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"from": from,
		"to":   to,
		"rate": rate,
	})
}
func ConvertCurrency(c *gin.Context) {
	from := c.DefaultQuery("from", "USD")
	to := c.DefaultQuery("to", "KZT")
	amountStr := c.DefaultQuery("amount", "1")

	amount, err := strconv.ParseFloat(amountStr, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid amount"})
		return
	}

	result, err := services.Convert(from, to, amount)
	if err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, result)
}
