package com.edumatch.dao;

import com.edumatch.model.AcademicRecord;
import com.edumatch.model.StudentProfile;
import com.edumatch.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * StudentProfileDAO - CRUD for student profiles, academic records, and saved colleges.
 */
public class StudentProfileDAO {

	// -- Profile ------------------------------------------------

	public StudentProfile findByUserId(int userId) throws SQLException {
		String sql = "SELECT sp.*, u.username, u.email FROM student_profiles sp " +
				"JOIN users u ON sp.user_id=u.user_id WHERE sp.user_id=?";
		Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
		try {
			conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
			ps.setInt(1, userId); rs = ps.executeQuery();
			return rs.next() ? mapProfileRow(rs) : null;
		} finally { DBConnection.close(conn, ps, rs); }
	}

	public boolean createProfile(StudentProfile sp) throws SQLException {
		String sql = "INSERT INTO student_profiles " +
				"(user_id,full_name,date_of_birth,gender,phone,address,district,province,citizenship_no,bio) " +
				"VALUES (?,?,?,?,?,?,?,?,?,?)";
		Connection conn = null; PreparedStatement ps = null;
		try {
			conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
			ps.setInt(1, sp.getUserId());
			ps.setString(2, sp.getFullName());
			if (sp.getDateOfBirth() != null) ps.setDate(3, Date.valueOf(sp.getDateOfBirth()));
			else ps.setNull(3, Types.DATE);
			ps.setString(4, sp.getGender());
			ps.setString(5, sp.getPhone());
			ps.setString(6, sp.getAddress());
			ps.setString(7, sp.getDistrict());
			ps.setString(8, sp.getProvince());
			ps.setString(9, sp.getCitizenshipNo());
			ps.setString(10, sp.getBio());
			return ps.executeUpdate() > 0;
		} finally { DBConnection.close(conn, ps); }
	}

	public boolean updateProfile(StudentProfile sp) throws SQLException {
		String sql = "UPDATE student_profiles SET full_name=?,date_of_birth=?,gender=?,phone=?," +
				"address=?,district=?,province=?,citizenship_no=?,bio=?,profile_photo=? " +
				"WHERE user_id=?";
		Connection conn = null; PreparedStatement ps = null;
		try {
			conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
			ps.setString(1, sp.getFullName());
			if (sp.getDateOfBirth() != null) ps.setDate(2, Date.valueOf(sp.getDateOfBirth()));
			else ps.setNull(2, Types.DATE);
			ps.setString(3, sp.getGender());
			ps.setString(4, sp.getPhone());
			ps.setString(5, sp.getAddress());
			ps.setString(6, sp.getDistrict());
			ps.setString(7, sp.getProvince());
			ps.setString(8, sp.getCitizenshipNo());
			ps.setString(9, sp.getBio());
			ps.setString(10, sp.getProfilePhoto());
			ps.setInt(11, sp.getUserId());
			return ps.executeUpdate() > 0;
		} finally { DBConnection.close(conn, ps); }
	}

	public boolean profileExists(int userId) throws SQLException {
		Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
		try {
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement("SELECT 1 FROM student_profiles WHERE user_id=?");
			ps.setInt(1, userId); rs = ps.executeQuery(); return rs.next();
		} finally { DBConnection.close(conn, ps, rs); }
	}

	// -- Academic Records --------------------------------------

	public List<AcademicRecord> getRecordsByUser(int userId) throws SQLException {
		String sql = "SELECT * FROM academic_records WHERE user_id=? " +
				"ORDER BY FIELD(level,'SEE','+2','Bachelor')";
		Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
		List<AcademicRecord> list = new ArrayList<>();
		try {
			conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
			ps.setInt(1, userId); rs = ps.executeQuery();
			while (rs.next()) list.add(mapRecordRow(rs));
			return list;
		} finally { DBConnection.close(conn, ps, rs); }
	}

	public boolean saveAcademicRecord(AcademicRecord r) throws SQLException {
		String sql = "INSERT INTO academic_records " +
				"(user_id,level,board,institution,passed_year,gpa,percentage,grade) " +
				"VALUES (?,?,?,?,?,?,?,?) " +
				"ON DUPLICATE KEY UPDATE board=VALUES(board),institution=VALUES(institution)," +
				"passed_year=VALUES(passed_year),gpa=VALUES(gpa)," +
				"percentage=VALUES(percentage),grade=VALUES(grade)";
		Connection conn = null; PreparedStatement ps = null;
		try {
			conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
			ps.setInt(1, r.getUserId());
			ps.setString(2, r.getLevel());
			ps.setString(3, r.getBoard());
			ps.setString(4, r.getInstitution());
			if (r.getPassedYear() > 0) ps.setInt(5, r.getPassedYear());
			else ps.setNull(5, Types.INTEGER);
			ps.setDouble(6, r.getGpa());
			ps.setDouble(7, r.getPercentage());
			ps.setString(8, r.getGrade());
			return ps.executeUpdate() > 0;
		} finally { DBConnection.close(conn, ps); }
	}

	// -- Saved Colleges ----------------------------------------

	public boolean saveCollege(int userId, int collegeId) throws SQLException {
		String sql = "INSERT IGNORE INTO saved_colleges (user_id, college_id) VALUES (?,?)";
		Connection conn = null; PreparedStatement ps = null;
		try {
			conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
			ps.setInt(1, userId); ps.setInt(2, collegeId);
			return ps.executeUpdate() > 0;
		} finally { DBConnection.close(conn, ps); }
	}

	public boolean unsaveCollege(int userId, int collegeId) throws SQLException {
		String sql = "DELETE FROM saved_colleges WHERE user_id=? AND college_id=?";
		Connection conn = null; PreparedStatement ps = null;
		try {
			conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
			ps.setInt(1, userId); ps.setInt(2, collegeId);
			return ps.executeUpdate() > 0;
		} finally { DBConnection.close(conn, ps); }
	}

	public List<Integer> getSavedCollegeIds(int userId) throws SQLException {
		String sql = "SELECT college_id FROM saved_colleges WHERE user_id=?";
		Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
		List<Integer> ids = new ArrayList<>();
		try {
			conn = DBConnection.getConnection(); ps = conn.prepareStatement(sql);
			ps.setInt(1, userId); rs = ps.executeQuery();
			while (rs.next()) ids.add(rs.getInt("college_id"));
			return ids;
		} finally { DBConnection.close(conn, ps, rs); }
	}

	// -- Mappers -----------------------------------------------

	private StudentProfile mapProfileRow(ResultSet rs) throws SQLException {
		StudentProfile sp = new StudentProfile();
		sp.setProfileId   (rs.getInt("profile_id"));
		sp.setUserId      (rs.getInt("user_id"));
		sp.setFullName    (rs.getString("full_name"));
		Date dob = rs.getDate("date_of_birth");
		if (dob != null) sp.setDateOfBirth(dob.toLocalDate());
		sp.setGender      (rs.getString("gender"));
		sp.setPhone       (rs.getString("phone"));
		sp.setAddress     (rs.getString("address"));
		sp.setDistrict    (rs.getString("district"));
		sp.setProvince    (rs.getString("province"));
		sp.setCitizenshipNo(rs.getString("citizenship_no"));
		sp.setProfilePhoto(rs.getString("profile_photo"));
		sp.setBio         (rs.getString("bio"));
		try { sp.setUsername(rs.getString("username")); } catch (Exception ignored) {}
		try { sp.setEmail(rs.getString("email")); }       catch (Exception ignored) {}
		return sp;
	}

	private AcademicRecord mapRecordRow(ResultSet rs) throws SQLException {
		AcademicRecord r = new AcademicRecord();
		r.setRecordId   (rs.getInt("record_id"));
		r.setUserId     (rs.getInt("user_id"));
		r.setLevel      (rs.getString("level"));
		r.setBoard      (rs.getString("board"));
		r.setInstitution(rs.getString("institution"));
		r.setPassedYear (rs.getInt("passed_year"));
		r.setGpa        (rs.getDouble("gpa"));
		r.setPercentage (rs.getDouble("percentage"));
		r.setGrade      (rs.getString("grade"));
		r.setDocumentPath(rs.getString("document_path"));
		return r;
	}
}
