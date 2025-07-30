# 🚀 3-Tier Web App Deployment on GCP

This project demonstrates how to deploy a simple full-stack web application using a 3-tier architecture on Google Cloud Platform (GCP).

## 📚 Tech Stack

- **Frontend**: React
- **Backend**: Node.js
- **Database**: MySQL (hosted on GCP Compute Engine)

## ✅ Application Overview

The application provides basic student management functionality:

- View student list (`/list`)
- Add a new student (`/form`)

## 🏗️ Architecture Diagram

![Architecture Diagram](<images\3-tier-web-app-gcp (3).jpg>)

## 📦 Backend Setup

### 1. MySQL Configuration on GCP VM

Provision a Linux VM in GCP and install MySQL:

```bash
sudo apt update
sudo apt install mysql-server -y
sudo systemctl start mysql.service
```

Login to MySQL and set password:

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mysql123';
```

Create and seed the database:

```sql
CREATE DATABASE student_db;
USE student_db;

CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    roll_number INT NOT NULL,
    class_name VARCHAR(10) NOT NULL
);

INSERT INTO students (name, roll_number, class_name) VALUES
('John Doe', 101, '10A'),
('Jane Smith', 102, '10B'),
('Alice Johnson', 103, '10A'),
('Bob Brown', 104, '10C');
```

### 2. Firewall Rules

Create the following firewall rules for the **`my-web-vpc`** network:

| Name                   | Source IP Range | Protocol/Port | Description                   |
| ---------------------- | --------------- | ------------- | ----------------------------- |
| `allow-mysql-internal` | `10.0.0.0/16`   | `tcp:3306`    | Allow MySQL access within VPC |
| `my-web-vpc-allow-ssh` | `0.0.0.0/0`     | `tcp:22`      | Allow SSH access              |
| `allow-icmp`           | `0.0.0.0/0`     | `icmp`        | Allow ping/ICMP               |

### 3. Backend Docker Image

1. **Configure Artifact Registry & GCP CLI:**

```bash
gcloud auth login
gcloud config set project three-tier-web-467315
gcloud auth configure-docker asia-south1-docker.pkg.dev
```

2. **Tag & Push Docker Image:**

```bash
docker tag backend-app:latest asia-south1-docker.pkg.dev/three-tier-web-467315/web-repo/backend-app:v1
docker push asia-south1-docker.pkg.dev/three-tier-web-467315/web-repo/backend-app:v1
```

### 4. VPC Connector & Firewall for Cloud Run

- Create a **Serverless VPC Access Connector** in the same region as your VM.
- Use `/28` subnet range.
- If quota issues occur, try different instance types or reduce max scaling instances to `4`.

**Additional Firewall Rule** to allow backend Cloud Run to connect MySQL:

| Name                        | Source IP Range | Protocol/Port | Description                                   |
| --------------------------- | --------------- | ------------- | --------------------------------------------- |
| `allow-mysql-from-cloudrun` | `10.0.3.0/28`   | `tcp:3306`    | Allow VPC connector subnet access to MySQL VM |

### 5. Backend Service Account

Create a service account `backend-sa` and assign the following roles:

- `Cloud SQL Client`
- `Logs Writer`
- `Secret Manager Secret Accessor`
- `Storage Object Viewer`

### 6. Deploy Backend to Cloud Run

While deploying the backend:

- Select image: `backend-app:v1`
- **Authentication**: Allow unauthenticated
- **Ingress**: Allow all traffic
- **Port**: `3500`
- **Environment Variables**: Add `.env` keys
- **Networking**: Enable VPC access with the created connector
- **Security**: Use `backend-sa`

> After deployment, check logs to ensure:
>
> - App is running on port `3500`
> - DB connection is successful
>   ![Logs-backend](images\image.png)

### 7. MySQL Connectivity Notes (Optional Fixes)

If backend fails to connect to MySQL:

#### a. Enable External MySQL Binding

```bash
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
# Change:
bind-address = 0.0.0.0
sudo systemctl restart mysql
```

#### b. Create MySQL User for External Hosts

```sql
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'mysql123';
GRANT ALL PRIVILEGES ON student_db.* TO 'root'@'%';
FLUSH PRIVILEGES;
```

#### c. Check Listening IP

```bash
sudo ss -tulnp | grep 3306
```

## 💻 Frontend Deployment

### 1. Push Frontend Image

```bash
docker tag frontend-app:latest asia-south1-docker.pkg.dev/three-tier-web-467315/web-repo/frontend-app:v1
docker push asia-south1-docker.pkg.dev/three-tier-web-467315/web-repo/frontend-app:v1
```

### 2. Frontend Service Account

Create a service account `frontend-caller` with role:

- `Cloud Run Invoker`

### 3. Deploy Frontend to Cloud Run

While deploying:

- Select image: `frontend-app:v1`
- **Authentication**: Allow unauthenticated
- **Ingress**: Allow all traffic
- **Environment Variables**: Not needed
- **Networking**: Not required
- **Security**: Use `frontend-caller`

## ✅ Final Verification

- Visit your **frontend Cloud Run URL**.
- Use `/form` to add students and `/list` to view them.
- Confirm successful DB interaction via backend logs.

## Screenshots of Application

![/form](images\image-1.png)
![/list](images\image-2.png)

## 🧾 Summary

- ✅ MySQL configured on GCP VM
- ✅ Backend deployed with secure DB access
- ✅ Frontend served via Cloud Run
- ✅ Secure networking and access management configured
