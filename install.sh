#!/bin/sh

set -e

echo "🚀 CapRover NGINX Custom Pages Installer"

# Detect CapRover NGINX container by name pattern (works with any nginx version)
NGINX_CONTAINER=$(docker ps \
  --filter "name=captain-nginx" \
  --format "{{.ID}}" | head -n 1)

if [ -z "$NGINX_CONTAINER" ]; then
  echo "❌ CapRover NGINX container not found"
  echo "Make sure CapRover is running."
  exit 1
fi

NGINX_IMAGE=$(docker inspect --format='{{.Config.Image}}' "$NGINX_CONTAINER")
echo "✅ Found NGINX container: $NGINX_CONTAINER ($NGINX_IMAGE)"

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

# Reload NGINX
docker exec "$NGINX_CONTAINER" nginx -s reload

echo "🔄 NGINX reloaded"
echo "✨ Installation complete!"
