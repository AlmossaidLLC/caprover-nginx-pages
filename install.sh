#!/bin/sh

set -e

echo "🚀 CapRover NGINX Custom Pages Installer"

# Detect CapRover NGINX container (nginx:1.27.2)
NGINX_CONTAINER=$(docker ps \
  --filter "ancestor=nginx:1.27.2" \
  --format "{{.ID}}" | head -n 1)

if [ -z "$NGINX_CONTAINER" ]; then
  echo "❌ CapRover NGINX container not found"
  echo "Make sure CapRover is running."
  exit 1
fi

echo "✅ Found NGINX container: $NGINX_CONTAINER"

TARGET_DIR="/usr/share/nginx/default"
REPO_BASE_URL="https://raw.githubusercontent.com/AlmossaidLLC/caprover-nginx-pages/main"
TEMP_DIR=$(mktemp -d)

# Download files from GitHub
echo "📥 Downloading files..."
curl -fsSL "$REPO_BASE_URL/index.html" -o "$TEMP_DIR/index.html"
curl -fsSL "$REPO_BASE_URL/error_generic_catch_all.html" -o "$TEMP_DIR/error_generic_catch_all.html"
curl -fsSL "$REPO_BASE_URL/captain_502_custom_error_page.html" -o "$TEMP_DIR/captain_502_custom_error_page.html"

# Copy files to container
docker cp "$TEMP_DIR/index.html" "$NGINX_CONTAINER:$TARGET_DIR/index.html"
docker cp "$TEMP_DIR/error_generic_catch_all.html" "$NGINX_CONTAINER:$TARGET_DIR/error_generic_catch_all.html"
docker cp "$TEMP_DIR/captain_502_custom_error_page.html" "$NGINX_CONTAINER:$TARGET_DIR/captain_502_custom_error_page.html"

# Cleanup temp directory
rm -rf "$TEMP_DIR"

echo "✅ Files copied successfully"

# Optional reload (safe)
docker exec "$NGINX_CONTAINER" nginx -s reload

echo "🔄 NGINX reloaded"
echo "✨ Installation complete!"
