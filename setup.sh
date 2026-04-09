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

echo "Preparing permissions..."
chmod +x migrate_db.sh
sudo chown -R app:app /home/app/mywebapp

echo "Creating systemd service..."

sudo tee /etc/systemd/system/mywebapp.service > /dev/null <<EOF
[Unit]
Description=MyWebApp Service
After=network.target postgresql.service

[Service]
User=app
WorkingDirectory=/home/app/mywebapp

ExecStartPre=/home/app/mywebapp/migrate_db.sh
ExecStart=/usr/bin/java -jar /home/app/mywebapp/target/mywebapp-0.0.1-SNAPSHOT.jar

Restart=always
RestartSec=5

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd..."

sudo systemctl daemon-reexec
sudo systemctl daemon-reload

sudo systemctl enable mywebapp
sudo systemctl start mywebapp

echo "Setup completed"