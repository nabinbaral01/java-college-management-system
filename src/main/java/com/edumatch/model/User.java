// ============================================================
// FILE: User.java
// DESCRIPTION: User model class representing a user in the 
//              EduMatch College Management System
// ============================================================
package com.edumatch.model;

import java.time.LocalDateTime;

/**
 * User class represents a user entity in the system.
 * Each user has credentials, role information, and metadata.
 * Supports different user roles: ADMIN, STUDENT, etc.
 */
public class User {
    // User identification fields
    private int userId;
    private String username;
    private String email;
    
    // Security field
    private String passwordHash;
    
    // Role and status fields
    private int roleId;
    private String roleName;
    private boolean isActive;
    
    // Timestamp field for audit trail
    private LocalDateTime createdAt;

    // Default constructor
    public User() {}

    // Constructor with main user details
    public User(int userId, String username, String email, int roleId, String roleName, boolean isActive) {
        this.userId   = userId;
        this.username = username;
        this.email    = email;
        this.roleId   = roleId;
        this.roleName = roleName;
        this.isActive = isActive;
    }

    // Getters & Setters
    public int getUserId()             { return userId; }
    public void setUserId(int v)       { this.userId = v; }
    
    public String getUsername()        { return username; }
    public void setUsername(String v)  { this.username = v; }
    
    public String getEmail()           { return email; }
    public void setEmail(String v)     { this.email = v; }
    
    public String getPasswordHash()    { return passwordHash; }
    public void setPasswordHash(String v) { this.passwordHash = v; }
    
    public int getRoleId()             { return roleId; }
    public void setRoleId(int v)       { this.roleId = v; }
    
    public String getRoleName()        { return roleName; }
    public void setRoleName(String v)  { this.roleName = v; }
    
    public boolean isActive()          { return isActive; }
    public void setActive(boolean v)   { this.isActive = v; }
    
    public LocalDateTime getCreatedAt()       { return createdAt; }
    public void setCreatedAt(LocalDateTime v) { this.createdAt = v; }

    // Utility method to get formatted creation date
    public String getCreatedAtFormatted() {
        if (createdAt == null) return "—";
        return createdAt.toLocalDate().toString();
    }

    // Role verification methods
    public boolean isAdmin()   { return "ADMIN".equalsIgnoreCase(roleName); }
    public boolean isStudent() { return "STUDENT".equalsIgnoreCase(roleName); }

    // String representation of User object
    @Override public String toString() {
        return "User{userId=" + userId + ", username='" + username + "', role='" + roleName + "'}";
    }
}
