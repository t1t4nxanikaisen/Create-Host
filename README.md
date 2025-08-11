# Create-Host (Render-ready)

This project provides a Docker-based web shell "VPS" using gotty. It is designed to be deployed to Render.com as a Docker web service.

**Important security note**: exposing an interactive shell over the web is dangerous. Always set strong credentials and avoid public exposure unless you know what you're doing.

## Features
- Runs gotty (web-based terminal) on port 8080
- Non-root user by default
- Neofetch and htop installed for a "VPS-like" feel
- Simple auth modes: `basic`, `password`, or `none` (use `basic` + secure password)

## Deploying to Render
1. Push this repository to GitHub.
2. In Render, create a new **Web Service** and connect the repo.
3. Use **Docker** environment. Render will build with the Dockerfile.
4. Set environment variables in the Render dashboard or via `render.yaml`:
   - `GOTTY_AUTH=basic`
   - `GOTTY_PASSWORD=youruser:strongpassword`
   - `GOTTY_PORT=8080`
5. Deploy. Open the rendered URL and authenticate.

## Local testing
Build and run locally with Docker:

```bash
docker build -t create-host .
docker run -p 8080:8080 -e GOTTY_AUTH=basic -e GOTTY_PASSWORD="admin:changeme" create-host
