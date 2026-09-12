# Event Volunteer Management System 🚀

An Advanced Java Web Application for organizing events, managing volunteer applications, duty assignments, attendance check-ins, and performance feedback.

---

## 📌 Features

### 👨‍💼 Admin Portal
- **Dashboard Overview**: Metrics for total events, active volunteers, pending applications, and duty assignments.
- **Event Management**: Create, update, and publish events with venues, dates, and descriptions.
- **Volunteer Roles**: Define custom roles per event with required volunteer counts.
- **Application Review**: Approve or reject volunteer applications with custom remarks.
- **Duty Assignment**: Assign specific duties, locations, and time slots to approved volunteers.
- **Attendance & Feedback Monitoring**: Track volunteer check-ins/check-outs and review ratings/feedback.
- **Reports & Analytics**: Generate event summary reports and export data.

### 🙋‍♀️ Volunteer Portal
- **Volunteer Registration & Login**: Secure authentication for volunteers.
- **Browse & Apply**: Search upcoming events and apply for specific roles.
- **Application Tracking**: Real-time status updates on submitted applications.
- **Duty Roster**: View assigned duties, locations, and schedules.
- **Check-In / Check-Out**: Mark attendance for assigned shifts.
- **Submit Feedback**: Provide ratings and comments post-event.

---

## 🛠️ Technology Stack

- **Backend**: Java 8 (Servlets, JSP, DAO Pattern, JDBC)
- **Frontend**: HTML5, Vanilla CSS3, JavaScript
- **Database**: SQLite (Built-in zero-config fallback) / MySQL Server
- **Server**: Embedded Jetty Server (`jetty-runner.jar`)

---

## 📁 Project Structure

```
Final Project/
├── src/
│   ├── com/event/
│   │   ├── config/       # DB Connection & Database Initializer
│   │   ├── dao/          # Data Access Objects (SQL Queries)
│   │   ├── model/        # Java Beans / Data Models
│   │   ├── server/       # MainServer Entry Point
│   │   └── servlet/      # HTTP Servlets (Controllers)
│   └── db.properties     # Database Configuration
├── webapp/
│   ├── admin/            # Admin JSP Views & Dashboard
│   ├── volunteer/        # Volunteer JSP Views & Portal
│   ├── css/              # Stylesheets
│   ├── js/               # JavaScript Scripts
│   ├── WEB-INF/          # Web configuration & compiled classes
│   └── index.jsp         # Portal Home Landing Page
├── lib/                  # Jetty Runner & JDBC Drivers
├── schema.sql            # Database Schema Creation Script
└── event_volunteer.db    # SQLite Local Database File
```

---

## 🚀 Quick Start Guide

### Prerequisites
- **Java SE Development Kit (JDK 8 or higher)**
- **Git**

### 1️⃣ Compile Java Files
Run from the root directory of the project:

**Command Prompt (CMD):**
```cmd
javac -cp "lib/*;webapp/WEB-INF/lib/*" -d webapp/WEB-INF/classes src/com/event/server/*.java src/com/event/config/*.java src/com/event/dao/*.java src/com/event/model/*.java src/com/event/servlet/*.java
copy src\db.properties webapp\WEB-INF\classes\db.properties
```

**PowerShell:**
```powershell
$files = Get-ChildItem -Path src -Recurse -Filter *.java | Resolve-Path -Relative
$files | Out-File -Encoding ascii sources.txt
javac -cp "lib/*;webapp/WEB-INF/lib/*" -d webapp/WEB-INF/classes @sources.txt
Copy-Item src/db.properties webapp/WEB-INF/classes/db.properties
```

---

### 2️⃣ Initialize Database (First Time Only)
Creates all necessary database tables and seeds initial sample events and roles:
```cmd
java -cp "webapp/WEB-INF/classes;lib/*;webapp/WEB-INF/lib/*" com.event.server.MainServer
```

---

### 3️⃣ Start Web Server
Launch the embedded Jetty web server:
```cmd
java -jar lib/jetty-runner.jar --port 8080 webapp
```

---

### 4️⃣ Open in Browser
Navigate to:
👉 **[http://localhost:8080/](http://localhost:8080/)**

---

## 🗄️ Database Configuration
Database options can be configured in `src/db.properties`:
- By default, **SQLite fallback is enabled** (`db.use_sqlite_fallback=true`), creating a zero-configuration local database file `event_volunteer.db`.
- To connect to a live **MySQL** server, edit `db.url`, `db.user`, and `db.password` in `src/db.properties`.