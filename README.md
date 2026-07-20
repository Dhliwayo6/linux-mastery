# Linux Mastery

An interactive, full-stack learning platform designed to take software engineers from Linux beginners to Kubernetes-ready.

## Architecture Overview

- **Frontend**: React 18, Vite, Zustand, Vanilla CSS, React Query, and Xterm.js for interactive shell sessions.
- **Backend**: Spring Boot 3, Java 21, Spring Security, Hibernate/JPA, MySQL 8, Redis, and Flyway database migrations.
- **Sandboxes**: Isolated Docker containers running Alpine 3.19 for safe student shell command execution.

---

## Automation Console (Makefile)

A `Makefile` is provided in the project root to simplify starting and managing all local development processes.

| Command | Description |
| :--- | :--- |
| `make docker-up` | Builds the isolated sandbox image and starts the MySQL and Redis containers. |
| `make docker-down` | Stops the MySQL, Redis, and sandbox Docker containers. |
| `make clean-port` | Releases port `8080` if it is currently occupied. |
| `make backend-run` | Starts the Spring Boot backend server, automatically sourcing environment variables from `.env`. |
| `make frontend-run` | Starts the Vite frontend dev server. |
| `make run-all` | Synthesizes and prints local setup actions in sequential order. |

---

## Getting Started

### 1. Prerequisites
- Java 21 (JDK)
- Node.js 18+ & npm
- Docker & Docker Compose

### 2. Configure Environment Variables
Copy `.env.example` to `.env` in the root directory and update credentials where necessary.

### 3. Spin Up Infrastructure
Run the following in your terminal to start the database and Redis services (this automatically builds the sandbox container image):
```bash
make docker-up
```

### 4. Run the Servers
In separate terminal sessions, execute:
```bash
# Tab 1: Start the backend server
make backend-run

# Tab 2: Start the frontend dev server
make frontend-run
```

The application is now accessible at:
- **Frontend**: `http://localhost:5173`
- **Backend API**: `http://localhost:8080/api/v1/`

---

## Key Core Features

### 1. Interactive Terminal Sandbox
An offline, hardened Linux container is spun up for each user terminal session. Students can interact directly with the console to practice exercises in real time.
- **WebSocket Endpoint**: `ws://localhost:8080/ws/terminal` (secured by JWT token query param).

### 2. User Profile Settings
An authenticated settings dashboard where students can customize their profile details.
- **Get Profile**: `GET /api/v1/users/me`
- **Update Profile**: `PUT /api/v1/users/me` (supports validating input parameters and enforcing email uniqueness).