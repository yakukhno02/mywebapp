## Labs Navigation

- [Lab1 – VM Deployment](#lab1--vm-deployment)

- [Lab2 – Docker Deployment](#-docker-deployment-lab2)

- [Lab3 – CI/CD](#-cicd-lab3)

## Lab1 – VM Deployment

# mywebapp

## 📌 Description

mywebapp is a web application for managing an inventory of items.  
The application allows users to view and retrieve data via a REST API.

---

## 📊 Assignment Variant

Student ID number: 29

Calculation:

```
V2 = (29 % 2) + 1 = 2
V3 = (29 % 3) + 1 = 3
V5 = (29 % 5) + 1 = 5
```

According to the variant:

- V3 = 3 → Simple Inventory (item management service)
- V2 = 2 → configuration via file `/etc/mywebapp/config`
- V5 = 5 → application port 5000
- Database: PostgreSQL

---

## ⚙️ Technologies

- Java 21
- Spring Boot
- PostgreSQL
- Nginx
- systemd
- Bash (automation)

---

## 🚀 API

### Get all items

```
GET /items
```

### Get item by id

```
GET /items/{id}
```

### Health-check

```
GET /health/alive
GET /health/ready
```

---


## 🧩 Deployment

### 📦 Base Image

The official image is used:

```
ubuntu-24.04.4-live-server
```

---

### 💻 VM Requirements

- CPU: 2
- RAM: 2 GB
- Disk: 10+ GB

---

### 🔐 Access to VM

After OS installation:

```
username: ubuntu
password: 12345678
```

---

### 🔑 SSH Access

```bash
ssh ubuntu@<VM_IP>
```

## ⚙️ Deployment Automation

The `setup.sh` script performs:

- installs required packages (Java, PostgreSQL, Nginx)
- creates system users
- configures PostgreSQL database
- builds and runs the application
- sets up systemd service
- configures Nginx reverse proxy

## ⚡ Automated Deployment

```bash
git clone https://github.com/yakukhno02/mywebapp.git
cd mywebapp
chmod +x setup.sh
./setup.sh
```

---

## 👥 Users

| User     | Purpose                     | Permissions                 |
|----------|---------------------------|-----------------------------|
| student  | development work          | sudo                        |
| teacher  | evaluation               | sudo + password change      |
| operator | service management       | limited sudo                |
| app      | runs the application     | no login                    |

---

## 🔐 Operator Restrictions

Only the following commands are allowed:

```bash
sudo systemctl start mywebapp
sudo systemctl stop mywebapp
sudo systemctl restart mywebapp
sudo systemctl status mywebapp
sudo systemctl reload nginx
```

All other commands are forbidden.

---

## 🧪 Testing

### 🔧 Service check

```bash
systemctl status mywebapp
```

Expected:
```
active (running)
```

---

### ❤️ Health-check

```bash
curl http://localhost:5000/health/alive
curl http://localhost:5000/health/ready
```

Expected:
- OK

---

### 📦 Get all items

```bash
curl http://localhost:5000/items
```

Expected:
- JSON array

---

### 🔍 Get item by ID

```bash
curl http://localhost:5000/items/1
```

Expected:
- JSON object if exists
- or empty / error if not

---

### 🌐 HTML response check

```bash
curl -H "Accept: text/html" http://localhost:5000/items
```

---

### 📡 Nginx check (port 80)

```bash
curl http://localhost/items
```  
Checks reverse proxy to port 5000

---

### 🔌 Port check

```bash
ss -tulnp | grep 5000
```

Expected:
- Java process listening on port 5000

---

### 👥 Users check

```bash
su - teacher
su - operator
su - app
su - ubuntu
```

---

### 🔐 Operator permissions test

```bash
su - operator
```

Allowed:

```bash
sudo systemctl status mywebapp
sudo systemctl restart mywebapp
```

Forbidden:

```bash
sudo apt update
```

---

### 📄 Gradebook check

```bash
cat /home/student/gradebook
```

Expected output:

```
29
```

## 🐳 Docker Deployment (Lab2)

Application is containerized using Docker and Docker Compose.

### Services:
- **web** – Spring Boot application (port 5000)
- **nginx** – reverse proxy (port 80 → exposed as 8080)
- **database** – PostgreSQL with persistent storage

### Features:
- Separate Docker network (not default)
- Database data persists using volume (`db_data`)
- Automatic startup of all services via Docker Compose
- DB migration runs on container start

### Run:

```bash
docker compose up --build
```

### Access: 

* Web application (via nginx):
    http://localhost:8080/items
* Health check:
    http://localhost:8080/health/alive

## 🔄 CI/CD (Lab3)

Implemented CI/CD pipeline using GitHub Actions.

### Pipeline stages:
- code quality checks
- automated tests
- Docker image build and publishing to GHCR
- deployment to self-hosted runner
- deployment verification

### Verification:
Deployment verification checks:
- application availability
- nginx reverse proxy accessibility
- successful HTTP response from deployed service

### Deployment:
Deployment is triggered automatically on Git tag push.

Example:

```bash
git tag v1.0.3
git push origin v1.0.3
