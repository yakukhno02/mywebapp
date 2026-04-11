#!/bin/bash

echo "Setting up users..."

# STUDENT
if ! id "student" &>/dev/null; then
    sudo useradd -m -s /bin/bash student
    echo "student:12345678" | sudo chpasswd
    sudo usermod -aG sudo student
    echo "student created"
else
    echo "student already exists"
fi

# TEACHER
if ! id "teacher" &>/dev/null; then
    sudo useradd -m -s /bin/bash teacher
    echo "teacher:12345678" | sudo chpasswd
    sudo usermod -aG sudo teacher
    sudo chage -d 0 teacher
    echo "teacher created"
else
    echo "teacher already exists"
fi

# OPERATOR
if ! id "operator" &>/dev/null; then
    if ! getent group operator > /dev/null; then
        sudo groupadd operator
    fi

    sudo useradd -m -s /bin/bash -g operator operator
    echo "operator:12345678" | sudo chpasswd
    sudo chage -d 0 operator
    echo "operator created"
else
    echo "operator already exists"
fi

# APP
if ! id "app" &>/dev/null; then
    sudo useradd -r -s /usr/sbin/nologin app
    echo "app created"
else
    echo "app already exists"
fi

echo "Configuring sudo for operator..."

# sudo rules for operator
sudo tee /etc/sudoers.d/operator > /dev/null <<EOF
Defaults:operator !authenticate

operator ALL=(ALL) NOPASSWD: \
/bin/systemctl start mywebapp, \
/bin/systemctl stop mywebapp, \
/bin/systemctl restart mywebapp, \
/bin/systemctl status mywebapp, \
/bin/systemctl reload nginx
EOF

sudo chmod 440 /etc/sudoers.d/operator

echo "Creating gradebook..."

sudo mkdir -p /home/student
echo -n "29" | sudo tee /home/student/gradebook > /dev/null
sudo chown student:student /home/student/gradebook

echo "Disabling default user..."

if id "ubuntu" &>/dev/null; then
    sudo usermod -L -s /usr/sbin/nologin ubuntu
    echo "ubuntu locked"
fi

echo "Users setup completed!"