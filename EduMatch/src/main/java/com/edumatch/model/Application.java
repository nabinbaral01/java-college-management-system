package com.edumatch.model;

import java.time.LocalDateTime;

public class Application {
    private int applicationId;
    private int userId;
    private String username;
    private String email;
    private String fullName;
    private int programId;
    private String programName;
    private String degreeLevel;
    private int collegeId;
    private String collegeName;
    private String facultyName;
    private String status;
    private LocalDateTime appliedDate;
    private String remarks;
    private String adminNotes;
    private LocalDateTime updatedAt;

    public Application() {}

    public int getApplicationId()           { return applicationId; }
    public void setApplicationId(int v)     { this.applicationId = v; }
    public int getUserId()                  { return userId; }
    public void setUserId(int v)            { this.userId = v; }
    public String getUsername()             { return username; }
    public void setUsername(String v)       { this.username = v; }
    public String getEmail()                { return email; }
    public void setEmail(String v)          { this.email = v; }
    public String getFullName()             { return fullName; }
    public void setFullName(String v)       { this.fullName = v; }
    public int getProgramId()               { return programId; }
    public void setProgramId(int v)         { this.programId = v; }
    public String getProgramName()          { return programName; }
    public void setProgramName(String v)    { this.programName = v; }
    public String getDegreeLevel()          { return degreeLevel; }
    public void setDegreeLevel(String v)    { this.degreeLevel = v; }
    public int getCollegeId()               { return collegeId; }
    public void setCollegeId(int v)         { this.collegeId = v; }
    public String getCollegeName()          { return collegeName; }
    public void setCollegeName(String v)    { this.collegeName = v; }
    public String getFacultyName()          { return facultyName; }
    public void setFacultyName(String v)    { this.facultyName = v; }
    public String getStatus()               { return status; }
    public void setStatus(String v)         { this.status = v; }
    public LocalDateTime getAppliedDate()   { return appliedDate; }
    public void setAppliedDate(LocalDateTime v){ this.appliedDate = v; }

    public String getAppliedDateFormatted() {
        if (appliedDate == null) return "—";
        return appliedDate.toLocalDate().toString(); // yyyy-MM-dd
    }
    public String getRemarks()              { return remarks; }
    public void setRemarks(String v)        { this.remarks = v; }
    public String getAdminNotes()           { return adminNotes; }
    public void setAdminNotes(String v)     { this.adminNotes = v; }
    public LocalDateTime getUpdatedAt()     { return updatedAt; }
    public void setUpdatedAt(LocalDateTime v){ this.updatedAt = v; }

    public String getStatusBadgeClass() {
        if (status == null) return "secondary";
        return switch (status) {
            case "Submitted"     -> "primary";
            case "Under Review"  -> "warning";
            case "Shortlisted"   -> "info";
            case "Accepted"      -> "success";
            case "Rejected"      -> "danger";
            case "Withdrawn"     -> "secondary";
            default              -> "light";
        };
    }
}
