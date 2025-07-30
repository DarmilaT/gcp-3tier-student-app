docker build -t mysql-image .
docker run --name mysql-container -p 3306:3306 -v mysql-data:/var/lib/mysql -d mysql-image
docker exec -it mysql-container /bin/bash

# Install MYSQL in VM
sudo apt update
sudo apt install mysql-server -y
sudo systemctl start mysql.service
sudo mysql
# change password
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mysql123';

# Database
mysql -u root -p
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
SELECT * FROM students;
