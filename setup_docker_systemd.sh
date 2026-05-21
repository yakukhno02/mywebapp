#!/bin/bash

set -e

echo "Setting up systemd..."

sudo tee /etc/systemd/system/mywebapp.service > /dev/null <<EOF
[Unit]
Description=MyWebApp Container Service
After=docker.service
Requires=docker.service

[Service]
User=app
WorkingDirectory=/home/app

ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd..."
sudo systemctl daemon-reload

echo "Enabling service..."
sudo systemctl enable mywebapp

echo "Starting service..."
sudo systemctl start mywebapp

echo "Done!"
