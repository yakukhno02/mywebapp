#!/bin/bash

echo "Creating config..."

sudo mkdir -p /etc/mywebapp

DB_USER=${DB_USER:-app}
DB_PASS=${DB_PASS:-12345678}

sudo tee /etc/mywebapp/config.properties > /dev/null <<EOF
spring.datasource.url=jdbc:postgresql://localhost:5432/mywebapp
spring.datasource.username=$DB_USER
spring.datasource.password=$DB_PASS

server.port=5000
EOF

echo "Config created!"
