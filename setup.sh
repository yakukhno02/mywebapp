#!/bin/bash

echo "Installing dependencies..."
sudo apt update
sudo apt install -y openjdk-21-jdk postgresql nginx

echo "Setting up database..."
chmod +x setup_db.sh
./setup_db.sh

echo "Building project..."
./mvnw clean package -DskipTests

echo "Done!"
