#!/bin/bash

echo "Installing dependencies..."
sudo apt update
sudo apt install -y openjdk-21-jdk postgresql nginx

echo "Starting PostgreSQL..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

echo "Setting up users..."
sudo chmod +x setup_users.sh
./setup_users.sh

echo "Setting up database..."
sudo chmod +x setup_db.sh
./setup_db.sh

echo "Creating application config..."
sudo chmod +x setup_config.sh
./setup_config.sh

echo "Building project..."
sudo chmod +x mvnw
./mvnw clean package -DskipTests

echo "Preparing permissions..."
sudo mkdir -p /home/app
sudo cp -r /home/ubuntu/mywebapp /home/app/
sudo chown -R app:app /home/app/mywebapp

sudo chmod +x /home/app/mywebapp/migrate_db.sh

echo "Setting up systemd..."

sudo chmod +x setup_systemd.sh
./setup_systemd.sh

sudo chmod +x setup_nginx.sh
./setup_nginx.sh

echo "Setup completed"