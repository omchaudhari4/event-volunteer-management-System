package com.event.config;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class CreateMySQLDatabase {

    public static void main(String[] args) {
        String dbUser = "root";
        String dbPassword = (args.length > 0) ? args[0] : "root"; // Pass password as arg or default root

        String baseUrl = "jdbc:mysql://localhost:3306/?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

        System.out.println("Connecting to MySQL server on localhost:3306...");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(baseUrl, dbUser, dbPassword);
                 Statement stmt = conn.createStatement()) {

                System.out.println("Connected to MySQL Server successfully!");
                System.out.println("Creating database 'event_volunteer_db' and tables from schema.sql...");

                StringBuilder sqlBuilder = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new FileReader("schema.sql"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        if (!line.trim().startsWith("--") && !line.trim().isEmpty()) {
                            sqlBuilder.append(line).append("\n");
                        }
                    }
                }

                String[] statements = sqlBuilder.toString().split(";");
                for (String sql : statements) {
                    if (!sql.trim().isEmpty()) {
                        stmt.execute(sql.trim());
                    }
                }

                System.out.println("SUCCESS! Database 'event_volunteer_db' and all 7 tables created in MySQL!");
                System.out.println("Now open MySQL Workbench and click the Refresh button (🔄) on the left SCHEMAS panel.");

            }
        } catch (Exception e) {
            System.err.println("\n[ERROR] Could not connect to MySQL server.");
            System.err.println("Please check: 1) Is MySQL Server running? 2) Is your root password correct? (" + e.getMessage() + ")");
        }
    }
}
