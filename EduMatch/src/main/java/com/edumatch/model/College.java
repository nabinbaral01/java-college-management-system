package com.edumatch.model;

import java.time.LocalDateTime;
import java.util.List;

// ============================================================
// College Model
// ============================================================
public class College {
    private int collegeId;
    private String collegeName;
    private String shortName;
    private String collegeType;
    private String affiliation;
    private int establishmentYear;
    private int districtId;
    private String districtName;
    private String provinceName;
    private String address;
    private String phone;
    private String email;
    private String website;
    private String description;
    private String logoPath;
    private String bannerPath;
    private boolean isActive;
    private int totalPrograms;
    private double minFee;
    private double maxFee;
    private LocalDateTime createdAt;
    private List<Program> programs;
    private List<String> facilities;

    public College() {}

    public int getCollegeId()               { return collegeId; }
    public void setCollegeId(int v)         { this.collegeId = v; }
    public String getCollegeName()          { return collegeName; }
    public void setCollegeName(String v)    { this.collegeName = v; }
    public String getShortName()            { return shortName; }
    public void setShortName(String v)      { this.shortName = v; }
    public String getCollegeType()          { return collegeType; }
    public void setCollegeType(String v)    { this.collegeType = v; }
    public String getAffiliation()          { return affiliation; }
    public void setAffiliation(String v)    { this.affiliation = v; }
    public int getEstablishmentYear()       { return establishmentYear; }
    public void setEstablishmentYear(int v) { this.establishmentYear = v; }
    public int getDistrictId()              { return districtId; }
    public void setDistrictId(int v)        { this.districtId = v; }
    public String getDistrictName()         { return districtName; }
    public void setDistrictName(String v)   { this.districtName = v; }
    public String getProvinceName()         { return provinceName; }
    public void setProvinceName(String v)   { this.provinceName = v; }
    public String getAddress()              { return address; }
    public void setAddress(String v)        { this.address = v; }
    public String getPhone()                { return phone; }
    public void setPhone(String v)          { this.phone = v; }
    public String getEmail()                { return email; }
    public void setEmail(String v)          { this.email = v; }
    public String getWebsite()              { return website; }
    public void setWebsite(String v)        { this.website = v; }
    public String getDescription()          { return description; }
    public void setDescription(String v)    { this.description = v; }
    public String getLogoPath()             { return logoPath; }
    public void setLogoPath(String v)       { this.logoPath = v; }
    public String getBannerPath()           { return bannerPath; }
    public void setBannerPath(String v)     { this.bannerPath = v; }
    public boolean isActive()               { return isActive; }
    public void setActive(boolean v)        { this.isActive = v; }
    public int getTotalPrograms()           { return totalPrograms; }
    public void setTotalPrograms(int v)     { this.totalPrograms = v; }
    public double getMinFee()               { return minFee; }
    public void setMinFee(double v)         { this.minFee = v; }
    public double getMaxFee()               { return maxFee; }
    public void setMaxFee(double v)         { this.maxFee = v; }
    public LocalDateTime getCreatedAt()     { return createdAt; }
    public void setCreatedAt(LocalDateTime v){ this.createdAt = v; }
    public List<Program> getPrograms()      { return programs; }
    public void setPrograms(List<Program> v){ this.programs = v; }
    public List<String> getFacilities()     { return facilities; }
    public void setFacilities(List<String> v){ this.facilities = v; }

    public String getLogoOrDefault() {
        return (logoPath != null && !logoPath.isEmpty()) ? logoPath : "/images/default-college.png";
    }
    public String getFormattedFeeRange() {
        if (minFee <= 0) return "N/A";
        if (minFee == maxFee) return String.format("NPR %,.0f", minFee);
        return String.format("NPR %,.0f - %,.0f", minFee, maxFee);
    }
}
