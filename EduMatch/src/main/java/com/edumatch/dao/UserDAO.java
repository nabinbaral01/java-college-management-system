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
 */
public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    // ──────────────────────────────────────────────
    // CREATE
    // ──────────────────────────────────────────────

    /**
     * Register a new user. Returns generated user_id, or -1 on failure.
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
    // READ
    // ──────────────────────────────────────────────

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
    // UPDATE
    // ──────────────────────────────────────────────

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
    // DELETE
    // ──────────────────────────────────────────────

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
    // STATS
    // ──────────────────────────────────────────────

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
    // MAPPER
    // ──────────────────────────────────────────────

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
