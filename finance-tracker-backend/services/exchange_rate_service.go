package services

import (
	"encoding/json"
	"fmt"

	"github.com/go-resty/resty/v2"
)

// ExchangeRateResponse — сыртқы API жауабы
type ExchangeRateResponse struct {
	Result   string             `json:"result"`
	BaseCode string             `json:"base_code"`
	Rates    map[string]float64 `json:"conversion_rates"`
}

// ConvertResult — конвертация нәтижесі
type ConvertResult struct {
	From   string  `json:"from"`
	To     string  `json:"to"`
	Amount float64 `json:"amount"`
	Result float64 `json:"result"`
	Rate   float64 `json:"rate"`
}

var restyClient = resty.New()

// GetRates — берілген валюта бойынша барлық курстарды алу
// API: https://open.er-api.com/v6/latest/{base}
func GetRates(baseCurrency string) (map[string]float64, error) {
	url := fmt.Sprintf("https://open.er-api.com/v6/latest/%s", baseCurrency)

	resp, err := restyClient.R().
		SetHeader("Accept", "application/json").
		Get(url)

	if err != nil {
		return nil, fmt.Errorf("request failed: %w", err)
	}

	if resp.StatusCode() != 200 {
		return nil, fmt.Errorf("API returned status %d", resp.StatusCode())
	}

	var result ExchangeRateResponse
	if err := json.Unmarshal(resp.Body(), &result); err != nil {
		return nil, fmt.Errorf("failed to parse response: %w", err)
	}

	if result.Result != "success" {
		return nil, fmt.Errorf("API error: result is not success")
	}

	return result.Rates, nil
}

// GetRate — екі валюта арасындағы нақты курсты алу
func GetRate(from, to string) (float64, error) {
	rates, err := GetRates(from)
	if err != nil {
		return 0, err
	}

	rate, ok := rates[to]
	if !ok {
		return 0, fmt.Errorf("currency %s not found", to)
	}

	return rate, nil
}

// Convert — соманы бір валютадан екіншіге айырбастау
func Convert(from, to string, amount float64) (*ConvertResult, error) {
	rate, err := GetRate(from, to)
	if err != nil {
		return nil, err
	}

	return &ConvertResult{
		From:   from,
		To:     to,
		Amount: amount,
		Result: amount * rate,
		Rate:   rate,
	}, nil
}
