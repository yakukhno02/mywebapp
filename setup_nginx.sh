#!/bin/bash

echo "Creating nginx config..."

sudo tee /etc/nginx/sites-available/mywebapp > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    location /items {
        proxy_pass http://127.0.0.1:5000;
    }

    location /health/ {
        proxy_pass http://127.0.0.1:5000;
    }

    location = / {
        proxy_pass http://127.0.0.1:5000;
    }

    location / {
        return 403;
    }
}
EOF

echo "Enabling config..."

sudo ln -sf /etc/nginx/sites-available/mywebapp /etc/nginx/sites-enabled/mywebapp
sudo rm -f /etc/nginx/sites-enabled/default

echo "Testing nginx config..."

sudo nginx -t || exit 1

echo "Restarting nginx..."

sudo systemctl restart nginx
sudo systemctl enable nginx

echo "Nginx setup completed!"

