#!/bin/bash

echo "Setting up systemd..."

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
sudo systemctl daemon-reload

echo "Enabling service..."
sudo systemctl enable mywebapp

echo "Starting service..."
sudo systemctl start mywebapp

echo "Done!"