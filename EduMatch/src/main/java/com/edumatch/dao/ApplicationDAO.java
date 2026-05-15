package com.edumatch.dao;

import com.edumatch.model.Application;
import com.edumatch.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ApplicationDAO – CRUD for student applications.
 */
public class ApplicationDAO {

    public int createApplication(int userId, int programId, String remarks) throws SQLException {
        String sql = "INSERT INTO applications (user_id, program_id, status, remarks) VALUES (?,?,'Submitted',?)";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId); ps.setInt(2, programId); ps.setString(3, remarks);
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } finally { DBConnection.close(conn, ps, rs); }
    }

    public List<Application> getApplicationsByUser(int userId) throws SQLException {
        String sql = "SELECT a.*, u.username, u.email, sp.full_name, " +
                "pr.program_name, pr.degree_level, c.college_id, c.college_name, f.faculty_name " +
                "FROM applications a " +
                "JOIN users u ON a.user_id=u.user_id " +
                "JOIN student_profiles sp ON u.user_id=sp.user_id " +
                "JOIN programs pr ON a.program_id=pr.program_id " +
                "JOIN colleges c ON pr.college_id=c.college_id " +
                "JOIN faculties f ON pr.faculty_id=f.faculty_id " +
                "WHERE a.user_id=? ORDER BY a.applied_date DESC";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Application> list = new ArrayList<>();
        try {
            conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, userId); rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBConnection.close(conn, ps, rs); }
    }

    public List<Application> getAllApplications(String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT a.*, u.username, u.email, sp.full_name, " +
                "pr.program_name, pr.degree_level, c.college_id, c.college_name, f.faculty_name " +
                "FROM applications a " +
                "JOIN users u ON a.user_id=u.user_id " +
                "JOIN student_profiles sp ON u.user_id=sp.user_id " +
                "JOIN programs pr ON a.program_id=pr.program_id " +
                "JOIN colleges c ON pr.college_id=c.college_id " +
                "JOIN faculties f ON pr.faculty_id=f.faculty_id ");
        if (status != null && !status.isEmpty()) sql.append("WHERE a.status=? ");
        sql.append("ORDER BY a.applied_date DESC");
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Application> list = new ArrayList<>();
        try {
            conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql.toString());
            if (status != null && !status.isEmpty()) ps.setString(1, status);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally { DBConnection.close(conn, ps, rs); }
    }

    public Application findById(int applicationId) throws SQLException {
        String sql = "SELECT a.*, u.username, u.email, sp.full_name, " +
                "pr.program_name, pr.degree_level, c.college_id, c.college_name, f.faculty_name " +
                "FROM applications a " +
                "JOIN users u ON a.user_id=u.user_id " +
                "JOIN student_profiles sp ON u.user_id=sp.user_id " +
                "JOIN programs pr ON a.program_id=pr.program_id " +
                "JOIN colleges c ON pr.college_id=c.college_id " +
                "JOIN faculties f ON pr.faculty_id=f.faculty_id " +
                "WHERE a.application_id=?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, applicationId); rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        } finally { DBConnection.close(conn, ps, rs); }
    }

    public boolean updateStatus(int applicationId, String status, String adminNotes) throws SQLException {
        String sql = "UPDATE applications SET status=?, admin_notes=? WHERE application_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
            ps.setString(1, status); ps.setString(2, adminNotes); ps.setInt(3, applicationId);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn, ps); }
    }

    public boolean withdrawApplication(int applicationId, int userId) throws SQLException {
        String sql = "UPDATE applications SET status='Withdrawn' WHERE application_id=? AND user_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, applicationId); ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn, ps); }
    }

    public boolean hasApplied(int userId, int programId) throws SQLException {
        String sql = "SELECT 1 FROM applications WHERE user_id=? AND program_id=? AND status != 'Withdrawn'";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, userId); ps.setInt(2, programId);
            rs = ps.executeQuery(); return rs.next();
        } finally { DBConnection.close(conn, ps, rs); }
    }

    public int countApplications() throws SQLException {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement("SELECT COUNT(*) FROM applications");
            rs = ps.executeQuery(); return rs.next() ? rs.getInt(1) : 0;
        } finally { DBConnection.close(conn, ps, rs); }
    }

    public int countByStatus(String status) throws SQLException {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement("SELECT COUNT(*) FROM applications WHERE status=?");
            ps.setString(1, status); rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally { DBConnection.close(conn, ps, rs); }
    }

    private Application mapRow(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setApplicationId(rs.getInt("application_id"));
        a.setUserId       (rs.getInt("user_id"));
        a.setUsername     (rs.getString("username"));
        a.setEmail        (rs.getString("email"));
        a.setFullName     (rs.getString("full_name"));
        a.setProgramId    (rs.getInt("program_id"));
        a.setProgramName  (rs.getString("program_name"));
        a.setDegreeLevel  (rs.getString("degree_level"));
        a.setCollegeId    (rs.getInt("college_id"));
        a.setCollegeName  (rs.getString("college_name"));
        a.setFacultyName  (rs.getString("faculty_name"));
        a.setStatus       (rs.getString("status"));
        a.setRemarks      (rs.getString("remarks"));
        a.setAdminNotes   (rs.getString("admin_notes"));
        Timestamp ts = rs.getTimestamp("applied_date");
        if (ts != null) a.setAppliedDate(ts.toLocalDateTime());
        Timestamp up = rs.getTimestamp("updated_at");
        if (up != null) a.setUpdatedAt(up.toLocalDateTime());
        return a;
    }
}
