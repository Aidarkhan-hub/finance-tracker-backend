package models

import "gorm.io/gorm"

type User struct {
	gorm.Model
	Name         string        `json:"name"`
	Email        string        `json:"email" gorm:"unique;not null"`
	Password     string        `json:"-"`
	Transactions []Transaction `json:"transactions"`
}

type Transaction struct {
	gorm.Model
	Amount   float64 `json:"amount"`
	Category string  `json:"category"`
	Type     string  `json:"type"`
	UserID   uint    `json:"user_id"`
}
