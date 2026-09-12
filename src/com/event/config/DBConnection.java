package com.event.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {
    private static String dbUrl;
    private static String dbUser;
    private static String dbPassword;
    private static String dbDriver;

    private static String sqliteUrl;
    private static boolean useSqliteFallback = true;

    static {
        loadConfig();
    }

    private static void loadConfig() {
        Properties props = new Properties();
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                props.load(input);
            }
        } catch (Exception ignored) {}

        dbDriver = props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
        dbUrl = props.getProperty("db.url", "jdbc:mysql://localhost:3306/event_volunteer_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
        dbUser = props.getProperty("db.user", "root");
        dbPassword = props.getProperty("db.password", "root");

        sqliteUrl = props.getProperty("db.sqlite_url", "jdbc:sqlite:event_volunteer.db");
        useSqliteFallback = Boolean.parseBoolean(props.getProperty("db.use_sqlite_fallback", "true"));

        // Register Driver classes
        try {
            Class.forName(dbDriver);
        } catch (ClassNotFoundException e) {
            try {
                Class.forName("org.sqlite.JDBC");
            } catch (ClassNotFoundException ignored) {}
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            // Attempt MySQL Connection
            return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        } catch (SQLException mysqlEx) {
            if (useSqliteFallback) {
                try {
                    Class.forName("org.sqlite.JDBC");
                    return DriverManager.getConnection(sqliteUrl);
                } catch (Exception sqliteEx) {
                    throw mysqlEx;
                }
            } else {
                throw mysqlEx;
            }
        }
    }
}
