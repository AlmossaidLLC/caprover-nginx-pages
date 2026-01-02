#!/bin/sh
set -e

echo "🚀 CapRover NGINX Persistent Pages Installer"

# ---- CONFIG ----
HOST_BASE="/captain/data/nginx-pages/default"
NGINX_TARGET="/usr/share/nginx/default"
REPO_BASE_URL="https://raw.githubusercontent.com/AlmossaidLLC/caprover-nginx-pages/main/theme/default"

# ---- CHECKS ----
if ! command -v docker >/dev/null 2>&1; then
  echo "❌ Docker is not installed"
  exit 1
fi

if ! docker service ls | grep -q captain-nginx; then
  echo "❌ CapRover NGINX service not found"
  exit 1
fi

# ---- PREPARE HOST DIRECTORY ----
echo "📁 Preparing persistent directory..."
mkdir -p "$HOST_BASE"

# ---- DOWNLOAD FILES ----
echo "📥 Downloading NGINX pages..."
curl -fsSL "$REPO_BASE_URL/index.html" -o "$HOST_BASE/index.html"
curl -fsSL "$REPO_BASE_URL/error_generic_catch_all.html" -o "$HOST_BASE/error_generic_catch_all.html"
curl -fsSL "$REPO_BASE_URL/captain_502_custom_error_page.html" -o "$HOST_BASE/captain_502_custom_error_page.html"

# ---- CHECK IF MOUNT EXISTS ----
if docker service inspect captain-nginx \
  --format '{{json .Spec.TaskTemplate.ContainerSpec.Mounts}}' | grep -q "$HOST_BASE"; then
  echo "✅ Volume already mounted"
else
  echo "🔗 Mounting persistent volume to NGINX service..."
  docker service update \
    --mount-add type=bind,src="$HOST_BASE",dst="$NGINX_TARGET" \
    captain-nginx
fi

# ---- FORCE REDEPLOY ----
echo "🔄 Restarting NGINX service..."
docker service update --force captain-nginx

echo "✨ Installation complete!"
echo "✅ Pages are now persistent across reboots"
