#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install -y curl nano git ufw

if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sudo sh
fi

sudo usermod -aG docker "$USER"

echo
echo "Docker installed."
echo "Now logout/login or run: newgrp docker"
