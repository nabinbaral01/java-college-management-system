// ============================================================
// FILE: UserDAO.java
// DESCRIPTION: Data Access Object for user management operations
//              in the EduMatch College Management System
// ============================================================
package com.edumatch.dao;

import com.edumatch.model.User;
import com.edumatch.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * UserDAO - Data Access Object for user authentication and management.
 * Handles all database operations related to user entities including
 * CRUD operations, authentication checks, and user statistics.
 */
public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    // ──────────────────────────────────────────────
    // CREATE OPERATIONS
    // ──────────────────────────────────────────────

    /**
     * Registers a new user in the system.
     * @param username The unique username for the user
     * @param email The email address for the user
     * @param passwordHash The hashed password for security
     * @param roleId The role ID determining user permissions
     * @return The generated user ID, or -1 if registration fails
     * @throws SQLException If database operation fails
     */
    public int createUser(String username, String email, String passwordHash, int roleId)
            throws SQLException {
        String sql = "INSERT INTO users (username, email, password_hash, role_id) VALUES (?,?,?,?)";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, username.trim().toLowerCase());
            ps.setString(2, email.trim().toLowerCase());
            ps.setString(3, passwordHash);
            ps.setInt   (4, roleId);
            int affected = ps.executeUpdate();
            if (affected == 0) return -1;
            rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    // ──────────────────────────────────────────────
    // READ OPERATIONS
    // ──────────────────────────────────────────────

    /**
     * Finds a user by their unique user ID.
     * @param userId The user ID to search for
     * @return User object if found, null otherwise
     * @throws SQLException If database operation fails
     */
    public User findById(int userId) throws SQLException {
        String sql = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id=r.role_id WHERE u.user_id=?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Finds a user by their username.
     * @param username The username to search for
     * @return User object if found, null otherwise
     * @throws SQLException If database operation fails
     */
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id=r.role_id WHERE u.username=?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, username.trim().toLowerCase());
            rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Finds a user by their email address.
     * @param email The email address to search for
     * @return User object if found, null otherwise
     * @throws SQLException If database operation fails
     */
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id=r.role_id WHERE u.email=?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, email.trim().toLowerCase());
            rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Retrieves all users from the database, ordered by creation date.
     * @return List of all User objects
     * @throws SQLException If database operation fails
     */
    public List<User> getAllUsers() throws SQLException {
        String sql = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id=r.role_id ORDER BY u.created_at DESC";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<User> list = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            rs   = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Retrieves all users with a specific role.
     * @param roleName The role name to filter by (e.g., "ADMIN", "STUDENT")
     * @return List of User objects with the specified role
     * @throws SQLException If database operation fails
     */
    public List<User> getUsersByRole(String roleName) throws SQLException {
        String sql = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id=r.role_id WHERE r.role_name=? ORDER BY u.created_at DESC";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<User> list = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, roleName);
            rs   = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Checks if a username already exists in the database.
     * @param username The username to check
     * @return true if username exists, false otherwise
     * @throws SQLException If database operation fails
     */
    public boolean existsByUsername(String username) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE username=?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, username.trim().toLowerCase());
            rs = ps.executeQuery();
            return rs.next();
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Checks if an email address already exists in the database.
     * @param email The email address to check
     * @return true if email exists, false otherwise
     * @throws SQLException If database operation fails
     */
    public boolean existsByEmail(String email) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE email=?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, email.trim().toLowerCase());
            rs = ps.executeQuery();
            return rs.next();
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    // ──────────────────────────────────────────────
    // UPDATE OPERATIONS
    // ──────────────────────────────────────────────

    /**
     * Updates the active status of a user account.
     * @param userId The user ID to update
     * @param isActive The new active status
     * @return true if update was successful, false otherwise
     * @throws SQLException If database operation fails
     */
    public boolean updateActiveStatus(int userId, boolean isActive) throws SQLException {
        String sql = "UPDATE users SET is_active=? WHERE user_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setBoolean(1, isActive);
            ps.setInt    (2, userId);
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.close(conn, ps);
        }
    }

    /**
     * Updates the password hash for a user.
     * @param userId The user ID to update
     * @param newHash The new password hash
     * @return true if update was successful, false otherwise
     * @throws SQLException If database operation fails
     */
    public boolean updatePassword(int userId, String newHash) throws SQLException {
        String sql = "UPDATE users SET password_hash=? WHERE user_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, newHash);
            ps.setInt   (2, userId);
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.close(conn, ps);
        }
    }

    // ──────────────────────────────────────────────
    // DELETE OPERATIONS
    // ──────────────────────────────────────────────

    /**
     * Deletes a user from the database.
     * @param userId The user ID to delete
     * @return true if deletion was successful, false otherwise
     * @throws SQLException If database operation fails
     */
    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.close(conn, ps);
        }
    }

    // ──────────────────────────────────────────────
    // STATISTICS OPERATIONS
    // ──────────────────────────────────────────────

    /**
     * Counts the number of users with a specific role.
     * @param roleName The role name to count
     * @return The count of users with the specified role
     * @throws SQLException If database operation fails
     */
    public int countByRole(String roleName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users u JOIN roles r ON u.role_id=r.role_id WHERE r.role_name=?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, roleName);
            rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    // ──────────────────────────────────────────────
    // UTILITY METHODS
    // ──────────────────────────────────────────────

    /**
     * Maps a ResultSet row to a User object.
     * @param rs The ResultSet containing user data
     * @return A populated User object
     * @throws SQLException If mapping fails
     */
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId      (rs.getInt   ("user_id"));
        u.setUsername    (rs.getString("username"));
        u.setEmail       (rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRoleId      (rs.getInt   ("role_id"));
        u.setRoleName    (rs.getString("role_name"));
        u.setActive      (rs.getBoolean("is_active"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) u.setCreatedAt(ts.toLocalDateTime());
        return u;
    }
}