DB_HOST     ?= localhost
DB_PORT     ?= 5432
DB_USER     ?= postgres
DB_PASSWORD ?= 1234
DB_NAME     ?= finance_db
DB_SSLMODE  ?= disable

DB_URL = postgres://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=$(DB_SSLMODE)

MIGRATE_DIR = finance-tracker-backend/migrations
MIGRATE_BIN = migrate

.PHONY: help install-migrate migrate-up migrate-down migrate-down-all \
        migrate-to migrate-force migrate-version migrate-create run build

## help: show available commands
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Migration commands:"
	@echo "  install-migrate          Install golang-migrate CLI tool"
	@echo "  migrate-up               Apply all pending migrations"
	@echo "  migrate-down             Roll back the last migration"
	@echo "  migrate-down-all         Roll back ALL migrations"
	@echo "  migrate-version          Show current migration version"
	@echo "  migrate-to N=<n>         Migrate to specific version"
	@echo "  migrate-force N=<n>      Force set version without running SQL"
	@echo "  migrate-create NAME=<n>  Create a new migration file pair"
	@echo ""
	@echo "App commands:"
	@echo "  run                      Run the application"
	@echo "  build                    Build binary to bin/finance-tracker"

## install-migrate: install golang-migrate CLI with postgres support
install-migrate:
	go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

## migrate-up: apply all pending migrations
migrate-up:
	$(MIGRATE_BIN) -path $(MIGRATE_DIR) -database "$(DB_URL)" up

## migrate-down: roll back the last applied migration
migrate-down:
	$(MIGRATE_BIN) -path $(MIGRATE_DIR) -database "$(DB_URL)" down 1

## migrate-down-all: roll back all migrations
migrate-down-all:
	$(MIGRATE_BIN) -path $(MIGRATE_DIR) -database "$(DB_URL)" down -all

## migrate-to: migrate to a specific version (usage: make migrate-to N=3)
migrate-to:
ifndef N
	$(error N is required. Usage: make migrate-to N=<version>)
endif
	$(MIGRATE_BIN) -path $(MIGRATE_DIR) -database "$(DB_URL)" goto $(N)

## migrate-force: force set version without running SQL (usage: make migrate-force N=3)
migrate-force:
ifndef N
	$(error N is required. Usage: make migrate-force N=<version>)
endif
	$(MIGRATE_BIN) -path $(MIGRATE_DIR) -database "$(DB_URL)" force $(N)

## migrate-version: print the current migration version
migrate-version:
	$(MIGRATE_BIN) -path $(MIGRATE_DIR) -database "$(DB_URL)" version

## migrate-create: create new migration pair (usage: make migrate-create NAME=create_accounts)
migrate-create:
ifndef NAME
	$(error NAME is required. Usage: make migrate-create NAME=<migration_name>)
endif
	$(MIGRATE_BIN) create -ext sql -dir $(MIGRATE_DIR) -seq $(NAME)

## run: run the application
run:
	go run finance-tracker-backend/main.go

## build: build the binary
build:
	go build -o bin/finance-tracker finance-tracker-backend/main.go