### for containers
api:
	docker-compose exec api bash

frontend:
	docker-compose exec frontend bash


### for backend

# Golang parameter(gofmt: code formatter, go vet/golist: lint tools)
GOCMD=go
GOFMT=go fmt
GOVET=$(GOCMD) vet
GOLINT=golint
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
BINARY_NAME=main
BINARY_UNIX=$(BINARY_NAME)_unix

BUILD_PATH=.
APP_PATH=src

all:
	make validate
	make build
	make run

# # delete debug symbols by golang option -dlflags "-s -w"
# build:
# 	$(GOBUILD) -o $(BUILD_PATH)/$(BINARY_NAME) -ldflags "-s -w" $(APP_PATH)/main.go
# go build -o $(BUILD_PATH)/main -ldflags "-s -w" src/main.go

validate:
	docker-compose exec api $(GOFMT) ./...
	docker-compose exec api $(GOVET) ./...
	docker-compose exec api $(GOTEST) -v ./...

check-all:
	make fmt && make lint

fix-all:
	make fmt-fix && make lint-fix

fmt:
	docker-compose exec api bash -c 'golines . -l'

fmt-fix:
	docker-compose exec api bash -c 'golines . -w'

lint:
	docker-compose exec api golangci-lint run

lint-fix:
	docker-compose exec api golangci-lint run --fix

test:
	docker-compose exec api go test ./...

test-cover:
	docker-compose exec api go test -cover ./...


### for frontend