package com.edumatch.util;

import javax.servlet.ServletContext;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DBConnection - Database connection utility using Singleton pattern.
 * Provides centralized JDBC connection management for EduMatch.
 */
public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    // Default connection parameters (overridden by context params in production)
    private static String DB_URL      = "jdbc:mysql://localhost:3306/edumatch_db?useSSL=false&serverTimezone=Asia/Kathmandu&allowPublicKeyRetrieval=true";
    private static String DB_USER     = "root";
    private static String DB_PASSWORD = "root";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            LOGGER.info("MySQL JDBC Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found!", e);
            throw new ExceptionInInitializerError("MySQL Driver missing: " + e.getMessage());
        }
    }

    private DBConnection() { /* Utility class */ }

    /**
     * Initialize DB parameters from ServletContext (called from AppInitListener).
     */
    public static void init(ServletContext ctx) {
        String url  = ctx.getInitParameter("DB_URL");
        String user = ctx.getInitParameter("DB_USER");
        String pass = ctx.getInitParameter("DB_PASSWORD");
        if (url  != null && !url.isEmpty())  DB_URL      = url;
        if (user != null && !user.isEmpty()) DB_USER     = user;
        if (pass != null)                    DB_PASSWORD = pass;
        LOGGER.info("DBConnection initialized with URL: " + DB_URL);
    }

    /**
     * Get a new database connection.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Safely close a Connection.
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing connection", e);
            }
        }
    }

    /**
     * Safely close a PreparedStatement.
     */
    public static void close(PreparedStatement ps) {
        if (ps != null) {
            try { ps.close(); } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing PreparedStatement", e);
            }
        }
    }

    /**
     * Safely close a ResultSet.
     */
    public static void close(ResultSet rs) {
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing ResultSet", e);
            }
        }
    }

    /**
     * Close all JDBC resources safely.
     */
    public static void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        close(rs);
        close(ps);
        close(conn);
    }

    /**
     * Close Connection and PreparedStatement.
     */
    public static void close(Connection conn, PreparedStatement ps) {
        close(ps);
        close(conn);
    }

    /**
     * Test the database connection.
     */
    public static boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "DB connection test failed", e);
            return false;
        } finally {
            close(conn);
        }
    }
}
