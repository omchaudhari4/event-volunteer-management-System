-- =========================================================
-- EVENT VOLUNTEER MANAGEMENT SYSTEM DATABASE SCHEMA (MySQL)
-- Run this script in MySQL Workbench or MySQL Command Line
-- =========================================================

CREATE DATABASE IF NOT EXISTS event_volunteer_db;
USE event_volunteer_db;

-- 1. volunteer table
CREATE TABLE IF NOT EXISTS volunteer (
    volunteer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    contact VARCHAR(15),
    skills TEXT,
    status VARCHAR(20) DEFAULT 'Active',
    avatar_url VARCHAR(255) DEFAULT 'images/avatar_default.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. event table
CREATE TABLE IF NOT EXISTS event (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(150) NOT NULL,
    event_date DATE NOT NULL,
    venue VARCHAR(150) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'Upcoming',
    image_url VARCHAR(255) DEFAULT 'images/event_tech_conf.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. volunteer_role table
CREATE TABLE IF NOT EXISTS volunteer_role (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    role_name VARCHAR(100) NOT NULL,
    required_count INT DEFAULT 1,
    description TEXT,
    FOREIGN KEY (event_id) REFERENCES event(event_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. event_application table
CREATE TABLE IF NOT EXISTS event_application (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    volunteer_id INT NOT NULL,
    role_id INT NOT NULL,
    applied_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) DEFAULT 'Pending',
    remark TEXT,
    FOREIGN KEY (event_id) REFERENCES event(event_id) ON DELETE CASCADE,
    FOREIGN KEY (volunteer_id) REFERENCES volunteer(volunteer_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES volunteer_role(role_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. duty_assignment table
CREATE TABLE IF NOT EXISTS duty_assignment (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT NOT NULL,
    volunteer_id INT NOT NULL,
    event_id INT NOT NULL,
    duty_title VARCHAR(150) NOT NULL,
    duty_location VARCHAR(100),
    start_time VARCHAR(20),
    end_time VARCHAR(20),
    status VARCHAR(30) DEFAULT 'Assigned',
    FOREIGN KEY (application_id) REFERENCES event_application(application_id) ON DELETE CASCADE,
    FOREIGN KEY (volunteer_id) REFERENCES volunteer(volunteer_id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES event(event_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. attendance table
CREATE TABLE IF NOT EXISTS attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    assignment_id INT NOT NULL,
    check_in DATETIME,
    check_out DATETIME,
    status VARCHAR(20) DEFAULT 'Absent',
    FOREIGN KEY (assignment_id) REFERENCES duty_assignment(assignment_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. volunteer_feedback table
CREATE TABLE IF NOT EXISTS volunteer_feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    assignment_id INT NOT NULL,
    rating INT CHECK(rating >= 1 AND rating <= 5),
    feedback TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assignment_id) REFERENCES duty_assignment(assignment_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
