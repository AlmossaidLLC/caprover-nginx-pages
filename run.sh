#!/bin/sh

# Detect CapRover NGINX container (nginx:1.27.2)
NGINX_CONTAINER=$(docker ps --filter "ancestor=nginx:1.27.2" --format "{{.ID}}" | head -n 1)

if [ -z "$NGINX_CONTAINER" ]; then
  echo "❌ CapRover NGINX container not found"
  exit 1
fi

echo "✅ Found NGINX container: $NGINX_CONTAINER"

TARGET_DIR="/usr/share/nginx/default"
SOURCE_DIR="$HOME/caprover-nginx-pages"

# Copy files
docker cp "$SOURCE_DIR/index.html" "$NGINX_CONTAINER:$TARGET_DIR/index.html"
docker cp "$SOURCE_DIR/error_generic_catch_all.html" "$NGINX_CONTAINER:$TARGET_DIR/error_generic_catch_all.html"
docker cp "$SOURCE_DIR/captain_502_custom_error_page.html" "$NGINX_CONTAINER:$TARGET_DIR/captain_502_custom_error_page.html"

echo "🚀 Files copied successfully"

# Optional reload (safe)
docker exec "$NGINX_CONTAINER" nginx -s reload

echo "🔄 NGINX reloaded"
