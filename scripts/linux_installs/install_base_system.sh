#!/bin/bash

# Define the list of packages to install
# Each package name should be on a new line in the 'packages.txt' file
PACKAGE_LIST_FILE="packages.txt"

# Check if the package list file exists
if [[ ! -f "$PACKAGE_LIST_FILE" ]]; then
    echo "Error: Package list file '$PACKAGE_LIST_FILE' not found."
    echo "Please create a file named 'packages.txt' in the same directory as this script"
    echo "and list the desired packages, one per line."
    exit 1
fi

# Update system before installing new packages
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install packages from the list
echo "Installing packages from '$PACKAGE_LIST_FILE'..."
while IFS= read -r package; do
    # Skip empty lines and lines starting with '#' (comments)
    if [[ -z "$package" || "$package" =~ ^# ]]; then
        continue
    fi
    echo "Attempting to install: $package"
    sudo pacman -S "$package" --noconfirm
    if [[ $? -eq 0 ]]; then
        echo "$package installed successfully."
    else
        echo "Warning: Failed to install $package."
    fi
done < "$PACKAGE_LIST_FILE"

echo "Installation process completed."
