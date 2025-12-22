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
INSTALL_DIR="/opt/caprover-nginx-pages"

# Create persistent directory and download files
echo "📥 Downloading files..."
sudo mkdir -p "$INSTALL_DIR"
sudo curl -fsSL "$REPO_BASE_URL/index.html" -o "$INSTALL_DIR/index.html"
sudo curl -fsSL "$REPO_BASE_URL/error_generic_catch_all.html" -o "$INSTALL_DIR/error_generic_catch_all.html"
sudo curl -fsSL "$REPO_BASE_URL/captain_502_custom_error_page.html" -o "$INSTALL_DIR/captain_502_custom_error_page.html"

# Copy files to container
docker cp "$INSTALL_DIR/index.html" "$NGINX_CONTAINER:$TARGET_DIR/index.html"
docker cp "$INSTALL_DIR/error_generic_catch_all.html" "$NGINX_CONTAINER:$TARGET_DIR/error_generic_catch_all.html"
docker cp "$INSTALL_DIR/captain_502_custom_error_page.html" "$NGINX_CONTAINER:$TARGET_DIR/captain_502_custom_error_page.html"

echo "✅ Files copied successfully"

# Reload NGINX
docker exec "$NGINX_CONTAINER" nginx -s reload
echo "🔄 NGINX reloaded"

# Create the apply script
echo "📦 Setting up persistence..."
sudo tee /opt/caprover-nginx-pages/apply.sh > /dev/null << 'APPLYSCRIPT'
#!/bin/sh
sleep 30
NGINX_CONTAINER=$(docker ps --filter "name=captain-nginx" --format "{{.ID}}" | head -n 1)
if [ -n "$NGINX_CONTAINER" ]; then
  TARGET_DIR="/usr/share/nginx/default"
  INSTALL_DIR="/opt/caprover-nginx-pages"
  docker cp "$INSTALL_DIR/index.html" "$NGINX_CONTAINER:$TARGET_DIR/index.html"
  docker cp "$INSTALL_DIR/error_generic_catch_all.html" "$NGINX_CONTAINER:$TARGET_DIR/error_generic_catch_all.html"
  docker cp "$INSTALL_DIR/captain_502_custom_error_page.html" "$NGINX_CONTAINER:$TARGET_DIR/captain_502_custom_error_page.html"
  docker exec "$NGINX_CONTAINER" nginx -s reload
fi
APPLYSCRIPT
sudo chmod +x /opt/caprover-nginx-pages/apply.sh

# Create systemd service
sudo tee /etc/systemd/system/caprover-nginx-pages.service > /dev/null << 'SYSTEMD'
[Unit]
Description=Apply custom NGINX pages to CapRover
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/opt/caprover-nginx-pages/apply.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SYSTEMD

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable caprover-nginx-pages.service

echo "✨ Installation complete!"
echo "📌 Custom pages will persist across reboots"
