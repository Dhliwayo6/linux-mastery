.PHONY: help docker-up docker-down clean-port backend-run frontend-run run-all

help:
	@echo "Linux Mastery Automation Console"
	@echo "Usage:"
	@echo "  make docker-up      - Start MySQL & Redis Docker containers"
	@echo "  make docker-down    - Stop Docker containers"
	@echo "  make clean-port     - Kill any process occupying port 8080"
	@echo "  make backend-run    - Run Spring Boot backend (sources .env automatically)"
	@echo "  make frontend-run   - Run Vite frontend dev server"
	@echo "  make run-all        - Start Docker services and print next steps"

docker-up: docker-build-sandbox
	@echo "[+] Launching Docker containers..."
	@cd docker && docker compose --env-file ../.env up -d

docker-build-sandbox:
	@echo "[+] Building sandbox Docker image..."
	@docker build -t linux-mastery-sandbox:latest docker/sandbox

docker-down:
	@echo "[-] Stopping Docker containers..."
	@cd docker && docker compose --env-file ../.env down

clean-port:
	@echo "[*] Checking if port 8080 is occupied..."
	@lsof -t -i :8080 | xargs kill -9 2>/dev/null || true

backend-run: clean-port
	@echo "[+] Starting Spring Boot backend server..."
	@cd backend && export $$(grep -v '^#' ../.env | xargs) && ./mvnw spring-boot:run

frontend-run:
	@echo "[+] Starting Vite frontend dev server..."
	@cd frontend && npm run dev

run-all: docker-up
	@echo "Services initialized. To start the servers, run in separate tabs:"
	@echo "  Tab 1: make backend-run"
	@echo "  Tab 2: make frontend-run"
