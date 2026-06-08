#!/usr/bin/env bash
set -e

mkdir -p ./backup

if [ -f ./db/x-ui.db ]; then
  cp ./db/x-ui.db "./backup/x-ui-$(date +%F-%H%M%S).db"
  echo "Backup saved in ./backup/"
else
  echo "x-ui.db not found"
fi
