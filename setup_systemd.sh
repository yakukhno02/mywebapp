#!/bin/bash

echo "Setting up systemd socket activation..."

# SOCKET
sudo tee /etc/systemd/system/mywebapp.socket > /dev/null <<EOF
[Unit]
Description=MyWebApp Socket

[Socket]
ListenStream=127.0.0.1:5000

[Install]
WantedBy=sockets.target
EOF

# SERVICE
sudo tee /etc/systemd/system/mywebapp.service > /dev/null <<EOF
[Unit]
Description=MyWebApp Service
Requires=mywebapp.socket
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

echo "Stopping old service..."

sudo systemctl stop mywebapp.service 2>/dev/null
sudo systemctl disable mywebapp.service 2>/dev/null

echo "Starting socket..."

sudo systemctl enable mywebapp.socket
sudo systemctl start mywebapp.socket

echo "Done!"
