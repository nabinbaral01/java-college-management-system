package com.edumatch.dao;

import com.edumatch.model.College;
import com.edumatch.model.Program;
import com.edumatch.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CollegeDAO - Data Access Object for colleges and programs.
 */
public class CollegeDAO {

    // ═══════════════════════════════════════════════════════
    // COLLEGE CRUD
    // ═══════════════════════════════════════════════════════

    public List<College> getAllColleges(String search, String type, String province, int facultyId) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT c.*, d.district_name, p.province_name, " +
            "COUNT(DISTINCT pr.program_id) AS total_programs, " +
            "MIN(pr.annual_fee) AS min_fee, MAX(pr.annual_fee) AS max_fee " +
            "FROM colleges c " +
            "LEFT JOIN districts d ON c.district_id=d.district_id " +
            "LEFT JOIN provinces p ON d.province_id=p.province_id " +
            "LEFT JOIN programs pr ON c.college_id=pr.college_id AND pr.is_active=1 " +
            "WHERE c.is_active=1 "
        );
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (c.college_name LIKE ? OR c.short_name LIKE ? OR c.affiliation LIKE ?) ");
            String q = "%" + search.trim() + "%";
            params.add(q); params.add(q); params.add(q);
        }
        if (type != null && !type.isEmpty()) {
            sql.append("AND c.college_type=? ");
            params.add(type);
        }
        if (province != null && !province.isEmpty()) {
            sql.append("AND p.province_name=? ");
            params.add(province);
        }
        if (facultyId > 0) {
            sql.append("AND pr.faculty_id=? ");
            params.add(facultyId);
        }
        sql.append("GROUP BY c.college_id ORDER BY c.college_name");

        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<College> list = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapCollegeRow(rs));
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    public College findById(int collegeId) throws SQLException {
        String sql = "SELECT c.*, d.district_name, p.province_name, " +
            "COUNT(DISTINCT pr.program_id) AS total_programs, " +
            "MIN(pr.annual_fee) AS min_fee, MAX(pr.annual_fee) AS max_fee " +
            "FROM colleges c " +
            "LEFT JOIN districts d ON c.district_id=d.district_id " +
            "LEFT JOIN provinces p ON d.province_id=p.province_id " +
            "LEFT JOIN programs pr ON c.college_id=pr.college_id AND pr.is_active=1 " +
            "WHERE c.college_id=? GROUP BY c.college_id";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();
            if (rs.next()) {
                College c = mapCollegeRow(rs);
                c.setFacilities(getFacilitiesForCollege(conn, collegeId));
                c.setPrograms(getProgramsByCollege(collegeId));
                return c;
            }
            return null;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    public int createCollege(College c) throws SQLException {
        String sql = "INSERT INTO colleges (college_name,short_name,college_type,affiliation,establishment_year," +
                     "district_id,address,phone,email,website,description,logo_path,banner_path) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, c.getCollegeName());
            ps.setString(2, c.getShortName());
            ps.setString(3, c.getCollegeType());
            ps.setString(4, c.getAffiliation());
            if (c.getEstablishmentYear() > 0) ps.setInt(5, c.getEstablishmentYear()); else ps.setNull(5, Types.INTEGER);
            if (c.getDistrictId()         > 0) ps.setInt(6, c.getDistrictId());        else ps.setNull(6, Types.INTEGER);
            ps.setString(7, c.getAddress());
            ps.setString(8, c.getPhone());
            ps.setString(9, c.getEmail());
            ps.setString(10, c.getWebsite());
            ps.setString(11, c.getDescription());
            ps.setString(12, c.getLogoPath());
            ps.setString(13, c.getBannerPath());
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    public boolean updateCollege(College c) throws SQLException {
        String sql = "UPDATE colleges SET college_name=?,short_name=?,college_type=?,affiliation=?," +
                     "establishment_year=?,district_id=?,address=?,phone=?,email=?,website=?,description=?," +
                     "logo_path=?,banner_path=?,is_active=? WHERE college_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString (1, c.getCollegeName());
            ps.setString (2, c.getShortName());
            ps.setString (3, c.getCollegeType());
            ps.setString (4, c.getAffiliation());
            if (c.getEstablishmentYear() > 0) ps.setInt(5, c.getEstablishmentYear()); else ps.setNull(5, Types.INTEGER);
            if (c.getDistrictId()         > 0) ps.setInt(6, c.getDistrictId());        else ps.setNull(6, Types.INTEGER);
            ps.setString (7, c.getAddress());
            ps.setString (8, c.getPhone());
            ps.setString (9, c.getEmail());
            ps.setString (10, c.getWebsite());
            ps.setString (11, c.getDescription());
            ps.setString (12, c.getLogoPath());
            ps.setString (13, c.getBannerPath());
            ps.setBoolean(14, c.isActive());
            ps.setInt    (15, c.getCollegeId());
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.close(conn, ps);
        }
    }

    public boolean deleteCollege(int collegeId) throws SQLException {
        String sql = "DELETE FROM colleges WHERE college_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setInt(1, collegeId);
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.close(conn, ps);
        }
    }

    public int countColleges() throws SQLException {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement("SELECT COUNT(*) FROM colleges WHERE is_active=1");
            rs   = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    // ═══════════════════════════════════════════════════════
    // PROGRAM CRUD
    // ═══════════════════════════════════════════════════════

    public List<Program> getProgramsByCollege(int collegeId) throws SQLException {
        String sql = "SELECT pr.*, c.college_name, c.college_type, d.district_name, pv.province_name, f.faculty_name " +
                     "FROM programs pr " +
                     "JOIN colleges  c  ON pr.college_id=c.college_id " +
                     "LEFT JOIN districts d ON c.district_id=d.district_id " +
                     "LEFT JOIN provinces pv ON d.province_id=pv.province_id " +
                     "JOIN faculties f  ON pr.faculty_id=f.faculty_id " +
                     "WHERE pr.college_id=? AND pr.is_active=1 ORDER BY f.faculty_name, pr.program_name";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Program> list = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapProgramRow(rs));
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    public List<Program> getAllPrograms() throws SQLException {
        String sql = "SELECT pr.*, c.college_name, c.college_type, d.district_name, pv.province_name, f.faculty_name " +
                     "FROM programs pr " +
                     "JOIN colleges  c  ON pr.college_id=c.college_id " +
                     "LEFT JOIN districts d ON c.district_id=d.district_id " +
                     "LEFT JOIN provinces pv ON d.province_id=pv.province_id " +
                     "JOIN faculties f  ON pr.faculty_id=f.faculty_id " +
                     "ORDER BY c.college_name, pr.program_name";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Program> list = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            rs   = ps.executeQuery();
            while (rs.next()) list.add(mapProgramRow(rs));
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    public Program findProgramById(int programId) throws SQLException {
        String sql = "SELECT pr.*, c.college_name, c.college_type, d.district_name, pv.province_name, f.faculty_name " +
                     "FROM programs pr " +
                     "JOIN colleges  c  ON pr.college_id=c.college_id " +
                     "LEFT JOIN districts d ON c.district_id=d.district_id " +
                     "LEFT JOIN provinces pv ON d.province_id=pv.province_id " +
                     "JOIN faculties f  ON pr.faculty_id=f.faculty_id " +
                     "WHERE pr.program_id=?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setInt(1, programId);
            rs = ps.executeQuery();
            return rs.next() ? mapProgramRow(rs) : null;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    public int createProgram(Program p) throws SQLException {
        String sql = "INSERT INTO programs (college_id,faculty_id,program_name,degree_level,duration_years," +
                     "total_seats,annual_fee,min_gpa,min_percentage,required_grade,entrance_required,entrance_name,description) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt    (1, p.getCollegeId());
            ps.setInt    (2, p.getFacultyId());
            ps.setString (3, p.getProgramName());
            ps.setString (4, p.getDegreeLevel());
            ps.setDouble (5, p.getDurationYears());
            ps.setInt    (6, p.getTotalSeats());
            ps.setDouble (7, p.getAnnualFee());
            ps.setDouble (8, p.getMinGpa());
            ps.setDouble (9, p.getMinPercentage());
            ps.setString (10, p.getRequiredGrade());
            ps.setBoolean(11, p.isEntranceRequired());
            ps.setString (12, p.getEntranceName());
            ps.setString (13, p.getDescription());
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    public boolean updateProgram(Program p) throws SQLException {
        String sql = "UPDATE programs SET college_id=?,faculty_id=?,program_name=?,degree_level=?," +
                     "duration_years=?,total_seats=?,annual_fee=?,min_gpa=?,min_percentage=?," +
                     "required_grade=?,entrance_required=?,entrance_name=?,description=?,is_active=? " +
                     "WHERE program_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setInt    (1, p.getCollegeId());
            ps.setInt    (2, p.getFacultyId());
            ps.setString (3, p.getProgramName());
            ps.setString (4, p.getDegreeLevel());
            ps.setDouble (5, p.getDurationYears());
            ps.setInt    (6, p.getTotalSeats());
            ps.setDouble (7, p.getAnnualFee());
            ps.setDouble (8, p.getMinGpa());
            ps.setDouble (9, p.getMinPercentage());
            ps.setString (10, p.getRequiredGrade());
            ps.setBoolean(11, p.isEntranceRequired());
            ps.setString (12, p.getEntranceName());
            ps.setString (13, p.getDescription());
            ps.setBoolean(14, p.isActive());
            ps.setInt    (15, p.getProgramId());
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.close(conn, ps);
        }
    }

    public boolean deleteProgram(int programId) throws SQLException {
        String sql = "DELETE FROM programs WHERE program_id=?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setInt(1, programId);
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.close(conn, ps);
        }
    }

    public int countPrograms() throws SQLException {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement("SELECT COUNT(*) FROM programs WHERE is_active=1");
            rs   = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    // ═══════════════════════════════════════════════════════
    // ELIGIBILITY MATCHING
    // ═══════════════════════════════════════════════════════

    public List<Program> matchPrograms(int userId, int facultyId, String province) throws SQLException {
        String sql = "SELECT pr.*, c.college_name, c.college_type, d.district_name, pv.province_name, f.faculty_name, " +
                     "CASE WHEN ar.percentage >= pr.min_percentage THEN 'Eligible' ELSE 'Not Eligible' END AS eligibility_status " +
                     "FROM programs pr " +
                     "JOIN colleges  c  ON pr.college_id=c.college_id AND c.is_active=1 " +
                     "LEFT JOIN districts d ON c.district_id=d.district_id " +
                     "LEFT JOIN provinces pv ON d.province_id=pv.province_id " +
                     "JOIN faculties f  ON pr.faculty_id=f.faculty_id " +
                     "LEFT JOIN academic_records ar ON ar.user_id=? AND ar.level='+2' " +
                     "WHERE pr.is_active=1 " +
                     (facultyId > 0 ? "AND pr.faculty_id=? " : "") +
                     (province != null && !province.isEmpty() ? "AND pv.province_name=? " : "") +
                     "ORDER BY eligibility_status ASC, pr.annual_fee ASC";

        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        List<Program> list = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            int idx = 1;
            ps.setInt(idx++, userId);
            if (facultyId > 0) ps.setInt(idx++, facultyId);
            if (province != null && !province.isEmpty()) ps.setString(idx, province);
            rs = ps.executeQuery();
            while (rs.next()) {
                Program p = mapProgramRow(rs);
                p.setEligibilityStatus(rs.getString("eligibility_status"));
                list.add(p);
            }
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    // ═══════════════════════════════════════════════════════
    // FACILITIES
    // ═══════════════════════════════════════════════════════

    private List<String> getFacilitiesForCollege(Connection conn, int collegeId) throws SQLException {
        String sql = "SELECT f.facility_name FROM facilities f " +
                     "JOIN college_facilities cf ON f.facility_id=cf.facility_id " +
                     "WHERE cf.college_id=? ORDER BY f.facility_name";
        PreparedStatement ps = null; ResultSet rs = null;
        List<String> list = new ArrayList<>();
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, collegeId);
            rs = ps.executeQuery();
            while (rs.next()) list.add(rs.getString("facility_name"));
            return list;
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        }
    }

    public void updateFacilities(int collegeId, int[] facilityIds) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            try (PreparedStatement del = conn.prepareStatement("DELETE FROM college_facilities WHERE college_id=?")) {
                del.setInt(1, collegeId);
                del.executeUpdate();
            }
            if (facilityIds != null && facilityIds.length > 0) {
                try (PreparedStatement ins = conn.prepareStatement("INSERT INTO college_facilities VALUES (?,?)")) {
                    for (int fid : facilityIds) {
                        ins.setInt(1, collegeId);
                        ins.setInt(2, fid);
                        ins.addBatch();
                    }
                    ins.executeBatch();
                }
            }
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    // ═══════════════════════════════════════════════════════
    // MAPPERS
    // ═══════════════════════════════════════════════════════

    private College mapCollegeRow(ResultSet rs) throws SQLException {
        College c = new College();
        c.setCollegeId        (rs.getInt   ("college_id"));
        c.setCollegeName      (rs.getString("college_name"));
        c.setShortName        (rs.getString("short_name"));
        c.setCollegeType      (rs.getString("college_type"));
        c.setAffiliation      (rs.getString("affiliation"));
        c.setEstablishmentYear(rs.getInt   ("establishment_year"));
        c.setDistrictId       (rs.getInt   ("district_id"));
        c.setDistrictName     (rs.getString("district_name"));
        c.setProvinceName     (rs.getString("province_name"));
        c.setAddress          (rs.getString("address"));
        c.setPhone            (rs.getString("phone"));
        c.setEmail            (rs.getString("email"));
        c.setWebsite          (rs.getString("website"));
        c.setDescription      (rs.getString("description"));
        c.setLogoPath         (rs.getString("logo_path"));
        c.setBannerPath       (rs.getString("banner_path"));
        c.setActive           (rs.getBoolean("is_active"));
        try { c.setTotalPrograms(rs.getInt("total_programs")); } catch (Exception ignored) {}
        try { c.setMinFee(rs.getDouble("min_fee")); } catch (Exception ignored) {}
        try { c.setMaxFee(rs.getDouble("max_fee")); } catch (Exception ignored) {}
        return c;
    }

    private Program mapProgramRow(ResultSet rs) throws SQLException {
        Program p = new Program();
        p.setProgramId       (rs.getInt   ("program_id"));
        p.setCollegeId       (rs.getInt   ("college_id"));
        p.setFacultyId       (rs.getInt   ("faculty_id"));
        p.setProgramName     (rs.getString("program_name"));
        p.setDegreeLevel     (rs.getString("degree_level"));
        p.setDurationYears   (rs.getDouble("duration_years"));
        p.setTotalSeats      (rs.getInt   ("total_seats"));
        p.setAnnualFee       (rs.getDouble("annual_fee"));
        p.setMinGpa          (rs.getDouble("min_gpa"));
        p.setMinPercentage   (rs.getDouble("min_percentage"));
        p.setRequiredGrade   (rs.getString("required_grade"));
        p.setEntranceRequired(rs.getBoolean("entrance_required"));
        p.setEntranceName    (rs.getString("entrance_name"));
        p.setDescription     (rs.getString("description"));
        p.setActive          (rs.getBoolean("is_active"));
        try { p.setCollegeName (rs.getString("college_name")); }  catch (Exception ignored) {}
        try { p.setCollegeType (rs.getString("college_type")); }  catch (Exception ignored) {}
        try { p.setDistrictName(rs.getString("district_name")); } catch (Exception ignored) {}
        try { p.setProvinceName(rs.getString("province_name")); } catch (Exception ignored) {}
        try { p.setFacultyName (rs.getString("faculty_name")); }  catch (Exception ignored) {}
        return p;
    }
}
