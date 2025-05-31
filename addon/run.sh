#!/bin/bash
set -e

REPO_URL=$(jq -r '.repo_url' /data/options.json)
BRANCH=$(jq -r '.branch' /data/options.json)
SYNC_INTERVAL=$(jq -r '.sync_interval' /data/options.json)
MAPPINGS=$(jq -c '.mappings' /data/options.json)

WORKDIR="/tmp/git-sync"

clone_repo() {
  echo "[INFO] Clonando $REPO_URL (branch: $BRANCH)..."
  rm -rf "$WORKDIR"
  git clone --depth 1 -b "$BRANCH" "$REPO_URL" "$WORKDIR"
}

sync_folders() {
  echo "$MAPPINGS" | jq -c '.[]' | while read -r mapping; do
    SRC=$(echo "$mapping" | jq -r '.source')
    DST=$(echo "$mapping" | jq -r '.target')
    echo "[SYNC] Copiando '$SRC' → '$DST'"
    mkdir -p "$DST"
    rsync -av --delete "$WORKDIR/$SRC/" "$DST/"
  done
}

main() {
  while true; do
    clone_repo
    sync_folders
    echo "[SLEEP] Esperando $SYNC_INTERVAL segundos para la próxima sincronización..."
    sleep "$SYNC_INTERVAL"
  done
}

main