#!/bin/bash

echo "Installing dependencies..."
sudo apt update
sudo apt install -y openjdk-21-jdk postgresql nginx

echo "Starting PostgreSQL..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

echo "Setting up database..."
chmod +x setup_db.sh
./setup_db.sh

echo "Creating application config..."
chmod +x setup_config.sh
./setup_config.sh

echo "Building project..."
chmod +x mvnw
./mvnw clean package -DskipTests

echo "Setup completed!"
echo "Run the application with:"
echo "  java -jar target/mywebapp-0.0.1-SNAPSHOT.jar"