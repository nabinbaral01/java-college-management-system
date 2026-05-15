package com.edumatch.model;

import java.time.LocalDateTime;

/** Program - POJO representing an academic program offered by a college (degree, fee, eligibility, seats). */
public class Program {
    private int programId;
    private int collegeId;
    private String collegeName;
    private String collegeType;
    private String districtName;
    private String provinceName;
    private int facultyId;
    private String facultyName;
    private String programName;
    private String degreeLevel;
    private double durationYears;
    private int totalSeats;
    private double annualFee;
    private double minGpa;
    private double minPercentage;
    private String requiredGrade;
    private boolean entranceRequired;
    private String entranceName;
    private String description;
    private boolean isActive;
    private LocalDateTime createdAt;

    // For eligibility matching
    private String eligibilityStatus;

    public Program() {}

    public int getProgramId()                { return programId; }
    public void setProgramId(int v)          { this.programId = v; }
    public int getCollegeId()                { return collegeId; }
    public void setCollegeId(int v)          { this.collegeId = v; }
    public String getCollegeName()           { return collegeName; }
    public void setCollegeName(String v)     { this.collegeName = v; }
    public String getCollegeType()           { return collegeType; }
    public void setCollegeType(String v)     { this.collegeType = v; }
    public String getDistrictName()          { return districtName; }
    public void setDistrictName(String v)    { this.districtName = v; }
    public String getProvinceName()          { return provinceName; }
    public void setProvinceName(String v)    { this.provinceName = v; }
    public int getFacultyId()                { return facultyId; }
    public void setFacultyId(int v)          { this.facultyId = v; }
    public String getFacultyName()           { return facultyName; }
    public void setFacultyName(String v)     { this.facultyName = v; }
    public String getProgramName()           { return programName; }
    public void setProgramName(String v)     { this.programName = v; }
    public String getDegreeLevel()           { return degreeLevel; }
    public void setDegreeLevel(String v)     { this.degreeLevel = v; }
    public double getDurationYears()         { return durationYears; }
    public void setDurationYears(double v)   { this.durationYears = v; }
    public int getTotalSeats()               { return totalSeats; }
    public void setTotalSeats(int v)         { this.totalSeats = v; }
    public double getAnnualFee()             { return annualFee; }
    public void setAnnualFee(double v)       { this.annualFee = v; }
    public double getMinGpa()                { return minGpa; }
    public void setMinGpa(double v)          { this.minGpa = v; }
    public double getMinPercentage()         { return minPercentage; }
    public void setMinPercentage(double v)   { this.minPercentage = v; }
    public String getRequiredGrade()         { return requiredGrade; }
    public void setRequiredGrade(String v)   { this.requiredGrade = v; }
    public boolean isEntranceRequired()      { return entranceRequired; }
    public void setEntranceRequired(boolean v){ this.entranceRequired = v; }
    public String getEntranceName()          { return entranceName; }
    public void setEntranceName(String v)    { this.entranceName = v; }
    public String getDescription()           { return description; }
    public void setDescription(String v)     { this.description = v; }
    public boolean isActive()                { return isActive; }
    public void setActive(boolean v)         { this.isActive = v; }
    public LocalDateTime getCreatedAt()      { return createdAt; }
    public void setCreatedAt(LocalDateTime v){ this.createdAt = v; }
    public String getEligibilityStatus()     { return eligibilityStatus; }
    public void setEligibilityStatus(String v){ this.eligibilityStatus = v; }

    public String getFormattedFee() {
        return annualFee > 0 ? String.format("NPR %,.0f/yr", annualFee) : "N/A";
    }
    public boolean isEligible() {
        return "Eligible".equalsIgnoreCase(eligibilityStatus);
    }
}
