package com.edumatch.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * AcademicRecord
 *
 * This model class is created from the StudentProfile structure per request.
 * It currently mirrors the StudentProfile fields so you can adapt it later
 * to hold academic-specific fields (grades, semester, GPA, etc.).
 *
 * Created for branch: nawaraj
 */
public class AcademicRecord {
    private int profileId;
    private int userId;
    private String fullName;
    private LocalDate dateOfBirth;
    private String gender;
    private String phone;
    private String address;
    private String district;
    private String province;
    private String citizenshipNo;
    private String profilePhoto;
    private String bio;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // User info joined fields
    private String username;
    private String email;

    public AcademicRecord() {}

    // Getters & Setters
    public int getProfileId()              { return profileId; }
    public void setProfileId(int v)        { this.profileId = v; }
    public int getUserId()                 { return userId; }
    public void setUserId(int v)           { this.userId = v; }
    public String getFullName()            { return fullName; }
    public void setFullName(String v)      { this.fullName = v; }
    public LocalDate getDateOfBirth()      { return dateOfBirth; }
    public void setDateOfBirth(LocalDate v){ this.dateOfBirth = v; }
    public String getGender()              { return gender; }
    public void setGender(String v)        { this.gender = v; }
    public String getPhone()               { return phone; }
    public void setPhone(String v)         { this.phone = v; }
    public String getAddress()             { return address; }
    public void setAddress(String v)       { this.address = v; }
    public String getDistrict()            { return district; }
    public void setDistrict(String v)      { this.district = v; }
    public String getProvince()            { return province; }
    public void setProvince(String v)      { this.province = v; }
    public String getCitizenshipNo()       { return citizenshipNo; }
    public void setCitizenshipNo(String v) { this.citizenshipNo = v; }
    public String getProfilePhoto()        { return profilePhoto; }
    public void setProfilePhoto(String v)  { this.profilePhoto = v; }
    public String getBio()                 { return bio; }
    public void setBio(String v)           { this.bio = v; }
    public LocalDateTime getCreatedAt()    { return createdAt; }
    public void setCreatedAt(LocalDateTime v) { this.createdAt = v; }
    public LocalDateTime getUpdatedAt()    { return updatedAt; }
    public void setUpdatedAt(LocalDateTime v) { this.updatedAt = v; }
    public String getUsername()            { return username; }
    public void setUsername(String v)      { this.username = v; }
    public String getEmail()               { return email; }
    public void setEmail(String v)         { this.email = v; }

    /**
     * Returns the path to display for the profile photo, falling back to a
     * default avatar when no photo is set.
     */
    public String getDisplayPhotoPath() {
        return (profilePhoto != null && !profilePhoto.isEmpty())
               ? profilePhoto : "/images/default-avatar.png";
    }
}
