package com.event.server;

import com.event.config.DatabaseInitializer;

public class MainServer {
    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("  EVENT VOLUNTEER MANAGEMENT SYSTEM (ADVANCED JAVA) ");
        System.out.println("=================================================");

        // 1. Initialize SQLite Database Schema
        System.out.println("[DB] Initializing SQLite database tables...");
        DatabaseInitializer.initializeDatabase();
        System.out.println("[DB] Database ready!");

        System.out.println("System initialized successfully.");
    }
}
