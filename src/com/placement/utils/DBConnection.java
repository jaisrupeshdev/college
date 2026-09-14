package com.placement.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static DBConnection instance;
    private Connection connection;
    private static final String URL = "jdbc:mysql://localhost:3306/placement_db";
    private static final String USERNAME = "root";
    // 🔥 YAHAN APNA MYSQL PASSWORD DAALO
    private static final String PASSWORD = "124421ram";

    private DBConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("✅ Database connected successfully!");
        } catch (ClassNotFoundException e) {
            System.out.println("❌ MySQL JDBC Driver nahi mila! JAR file add kiya?");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("❌ Database connection fail! MySQL running hai? Ya password galat?");
            e.printStackTrace();
        }
    }

    public static DBConnection getInstance() {
        if (instance == null) {
            synchronized (DBConnection.class) {
                if (instance == null) {
                    instance = new DBConnection();
                }
            }
        }
        return instance;
    }

    public Connection getConnection() {
        return connection;
    }

    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("🔒 Database connection closed.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}