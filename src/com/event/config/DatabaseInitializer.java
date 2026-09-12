package com.event.config;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.Statement;

public class DatabaseInitializer {

    public static void initializeDatabase() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            DatabaseMetaData meta = conn.getMetaData();
            String dbProductName = meta.getDatabaseProductName().toLowerCase();

            if (dbProductName.contains("sqlite")) {
                stmt.execute("PRAGMA foreign_keys = ON;");
            }

            // 1. volunteer table
            String createVolunteerTable = "CREATE TABLE IF NOT EXISTS volunteer (" +
                    "volunteer_id INTEGER PRIMARY KEY AUTO_INCREMENT, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100) UNIQUE NOT NULL, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "contact VARCHAR(15), " +
                    "skills TEXT, " +
                    "status VARCHAR(20) DEFAULT 'Active', " +
                    "avatar_url VARCHAR(255) DEFAULT 'images/avatar_default.png'" +
                    ");";
            if (dbProductName.contains("sqlite")) {
                createVolunteerTable = createVolunteerTable.replace("AUTO_INCREMENT", "AUTOINCREMENT");
            }
            stmt.execute(createVolunteerTable);

            // 2. event table
            String createEventTable = "CREATE TABLE IF NOT EXISTS event (" +
                    "event_id INTEGER PRIMARY KEY AUTO_INCREMENT, " +
                    "event_name VARCHAR(150) NOT NULL, " +
                    "event_date DATE NOT NULL, " +
                    "venue VARCHAR(150) NOT NULL, " +
                    "description TEXT, " +
                    "status VARCHAR(20) DEFAULT 'Upcoming', " +
                    "image_url VARCHAR(255) DEFAULT 'images/event_tech_conf.png'" +
                    ");";
            if (dbProductName.contains("sqlite")) {
                createEventTable = createEventTable.replace("AUTO_INCREMENT", "AUTOINCREMENT");
            }
            stmt.execute(createEventTable);

            // Column migration checks for existing databases
            try {
                stmt.execute("ALTER TABLE volunteer ADD COLUMN avatar_url VARCHAR(255) DEFAULT 'images/avatar_default.png';");
            } catch (Exception ignored) {}
            try {
                stmt.execute("ALTER TABLE event ADD COLUMN image_url VARCHAR(255) DEFAULT 'images/event_tech_conf.png';");
            } catch (Exception ignored) {}

            // 3. volunteer_role table
            String createRoleTable = "CREATE TABLE IF NOT EXISTS volunteer_role (" +
                    "role_id INTEGER PRIMARY KEY AUTO_INCREMENT, " +
                    "event_id INTEGER NOT NULL, " +
                    "role_name VARCHAR(100) NOT NULL, " +
                    "required_count INTEGER DEFAULT 1, " +
                    "description TEXT, " +
                    "FOREIGN KEY(event_id) REFERENCES event(event_id) ON DELETE CASCADE" +
                    ");";
            if (dbProductName.contains("sqlite")) {
                createRoleTable = createRoleTable.replace("AUTO_INCREMENT", "AUTOINCREMENT");
            }
            stmt.execute(createRoleTable);

            // 4. event_application table
            String createApplicationTable = "CREATE TABLE IF NOT EXISTS event_application (" +
                    "application_id INTEGER PRIMARY KEY AUTO_INCREMENT, " +
                    "event_id INTEGER NOT NULL, " +
                    "volunteer_id INTEGER NOT NULL, " +
                    "role_id INTEGER NOT NULL, " +
                    "applied_date DATETIME DEFAULT CURRENT_TIMESTAMP, " +
                    "status VARCHAR(30) DEFAULT 'Pending', " +
                    "remark TEXT, " +
                    "FOREIGN KEY(event_id) REFERENCES event(event_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY(volunteer_id) REFERENCES volunteer(volunteer_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY(role_id) REFERENCES volunteer_role(role_id) ON DELETE CASCADE" +
                    ");";
            if (dbProductName.contains("sqlite")) {
                createApplicationTable = createApplicationTable.replace("AUTO_INCREMENT", "AUTOINCREMENT");
            }
            stmt.execute(createApplicationTable);

            // 5. duty_assignment table
            String createDutyTable = "CREATE TABLE IF NOT EXISTS duty_assignment (" +
                    "assignment_id INTEGER PRIMARY KEY AUTO_INCREMENT, " +
                    "application_id INTEGER NOT NULL, " +
                    "volunteer_id INTEGER NOT NULL, " +
                    "event_id INTEGER NOT NULL, " +
                    "duty_title VARCHAR(150) NOT NULL, " +
                    "duty_location VARCHAR(100), " +
                    "start_time VARCHAR(20), " +
                    "end_time VARCHAR(20), " +
                    "status VARCHAR(30) DEFAULT 'Assigned', " +
                    "FOREIGN KEY(application_id) REFERENCES event_application(application_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY(volunteer_id) REFERENCES volunteer(volunteer_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY(event_id) REFERENCES event(event_id) ON DELETE CASCADE" +
                    ");";
            if (dbProductName.contains("sqlite")) {
                createDutyTable = createDutyTable.replace("AUTO_INCREMENT", "AUTOINCREMENT");
            }
            stmt.execute(createDutyTable);

            // 6. attendance table
            String createAttendanceTable = "CREATE TABLE IF NOT EXISTS attendance (" +
                    "attendance_id INTEGER PRIMARY KEY AUTO_INCREMENT, " +
                    "assignment_id INTEGER NOT NULL, " +
                    "check_in DATETIME, " +
                    "check_out DATETIME, " +
                    "status VARCHAR(20) DEFAULT 'Absent', " +
                    "FOREIGN KEY(assignment_id) REFERENCES duty_assignment(assignment_id) ON DELETE CASCADE" +
                    ");";
            if (dbProductName.contains("sqlite")) {
                createAttendanceTable = createAttendanceTable.replace("AUTO_INCREMENT", "AUTOINCREMENT");
            }
            stmt.execute(createAttendanceTable);

            // 7. volunteer_feedback table
            String createFeedbackTable = "CREATE TABLE IF NOT EXISTS volunteer_feedback (" +
                    "feedback_id INTEGER PRIMARY KEY AUTO_INCREMENT, " +
                    "assignment_id INTEGER NOT NULL, " +
                    "rating INTEGER CHECK(rating >= 1 AND rating <= 5), " +
                    "feedback TEXT, " +
                    "created_at DATETIME DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY(assignment_id) REFERENCES duty_assignment(assignment_id) ON DELETE CASCADE" +
                    ");";
            if (dbProductName.contains("sqlite")) {
                createFeedbackTable = createFeedbackTable.replace("AUTO_INCREMENT", "AUTOINCREMENT");
            }
            stmt.execute(createFeedbackTable);

            // Seed default events if table is empty
            try (java.sql.ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM event")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    stmt.execute("INSERT INTO event (event_name, event_date, venue, description, status, image_url) VALUES " +
                            "('Global Tech & Innovation Summit 2026', '2026-09-15', 'Grand Tech Convention Center', 'Annual international summit bringing together technology leaders, AI researchers, and developers.', 'Upcoming', 'images/event_tech_conf.png'), " +
                            "('City Charity Marathon & Wellness Expo', '2026-09-22', 'Metropolitan Central Park', 'Annual community fundraising marathon supporting local children hospitals and youth sports programs.', 'Upcoming', 'images/event_marathon.png'), " +
                            "('Neon Beats Live Music & Cultural Fest', '2026-10-05', 'Riverside Open Amphitheater', 'A vibrant multi-stage music and arts festival featuring indie bands and cultural art exhibitions.', 'Upcoming', 'images/event_music_fest.png'), " +
                            "('Clean Earth & Green Plantation Drive', '2026-10-18', 'Greenbelt Nature Reserve', 'Environmental initiative aimed at planting 5,000 native trees and restoring city park ecosystems.', 'Upcoming', 'images/event_green_clean.png');");

                    stmt.execute("INSERT INTO volunteer_role (event_id, role_name, required_count, description) VALUES " +
                            "(1, 'Stage Tech Support', 5, 'Assist speakers with presentation equipment, microphone management, and stage timing.'), " +
                            "(1, 'VIP Guest Receptionist', 4, 'Welcome keynote speakers and guide VIP delegations to reserved lounges.'), " +
                            "(2, 'Hydration Station Captain', 10, 'Manage water distribution points and encourage runners along the marathon route.'), " +
                            "(2, 'First Aid & Safety Liaison', 6, 'Assist paramedic teams with runner health monitoring and emergency calls.'), " +
                            "(3, 'Crowd & Entrance Usher', 12, 'Guide ticket holders, assist with wristband scanning and security check lines.'), " +
                            "(4, 'Sapling Planting Lead', 15, 'Demonstrate tree planting techniques, distribute shovels and compost kits.');");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            System.out.println("Database schema successfully initialized for: " + dbProductName);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
