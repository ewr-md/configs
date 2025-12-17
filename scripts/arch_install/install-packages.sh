#!/bin/bash

set -e

PACKAGE_FILE="$1"

if [[ -z "$PACKAGE_FILE" ]]; then
  echo "Usage: $0 <package-list-file>"
  exit 1
fi

if [[ ! -f "$PACKAGE_FILE" ]]; then
  echo "Error: File '$PACKAGE_FILE' not found."
  exit 1
fi

echo "Updating package database..."
sudo pacman -Sy

echo "Installing packages from $PACKAGE_FILE..."

grep -vE '^\s*#|^\s*$' "$PACKAGE_FILE" | while read -r package; do
  echo "Installing: $package"
  sudo pacman -S --needed --noconfirm "$package"
done

echo "All packages processed."
