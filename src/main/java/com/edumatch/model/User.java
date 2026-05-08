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
    // ========== FIELD DECLARATIONS ==========
    /** Unique identifier for each user */
    private int userId;
    
    /** Username for login authentication */
    private String username;
    
    /** Email address for communication and verification */
    private String email;
    
    /** Hashed password for secure authentication */
    private String passwordHash;
    
    /** Role ID linking to the role/permission level */
    private int roleId;
    
    /** Role name (e.g., ADMIN, STUDENT, INSTRUCTOR) */
    private String roleName;
    
    /** Flag indicating if the user account is active */
    private boolean isActive;
    
    /** Timestamp when the user account was created */
    private LocalDateTime createdAt;

    // ========== CONSTRUCTORS ==========
    /**
     * Default constructor - creates an empty User object
     */
    public User() {}

    /**
     * Constructor with user details (excluding password and timestamps)
     * @param userId      - Unique user identifier
     * @param username    - Username for login
     * @param email       - User email address
     * @param roleId      - Role ID for permission level
     * @param roleName    - Role name string
     * @param isActive    - Account active status
     */
    public User(int userId, String username, String email, int roleId, String roleName, boolean isActive) {
        this.userId   = userId;
        this.username = username;
        this.email    = email;
        this.roleId   = roleId;
        this.roleName = roleName;
        this.isActive = isActive;
    }

    // ========== GETTERS & SETTERS ==========
    
    /**
     * Gets the user ID
     * @return the unique user identifier
     */
    public int getUserId() { 
        return userId; 
    }
    
    /**
     * Sets the user ID
     * @param v - the user ID to set
     */
    public void setUserId(int v) { 
        this.userId = v; 
    }
    
    /**
     * Gets the username
     * @return the username string
     */
    public String getUsername() { 
        return username; 
    }
    
    /**
     * Sets the username
     * @param v - the username to set
     */
    public void setUsername(String v) { 
        this.username = v; 
    }
    
    /**
     * Gets the email address
     * @return the email string
     */
    public String getEmail() { 
        return email; 
    }
    
    /**
     * Sets the email address
     * @param v - the email to set
     */
    public void setEmail(String v) { 
        this.email = v; 
    }
    
    /**
     * Gets the password hash
     * @return the hashed password string
     */
    public String getPasswordHash() { 
        return passwordHash; 
    }
    
    /**
     * Sets the password hash
     * @param v - the password hash to set
     */
    public void setPasswordHash(String v) { 
        this.passwordHash = v; 
    }
    
    /**
     * Gets the role ID
     * @return the role identifier
     */
    public int getRoleId() { 
        return roleId; 
    }
    
    /**
     * Sets the role ID
     * @param v - the role ID to set
     */
    public void setRoleId(int v) { 
        this.roleId = v; 
    }
    
    /**
     * Gets the role name
     * @return the role name string (e.g., "ADMIN", "STUDENT")
     */
    public String getRoleName() { 
        return roleName; 
    }
    
    /**
     * Sets the role name
     * @param v - the role name to set
     */
    public void setRoleName(String v) { 
        this.roleName = v; 
    }
    
    /**
     * Checks if the user account is active
     * @return true if account is active, false otherwise
     */
    public boolean isActive() { 
        return isActive; 
    }
    
    /**
     * Sets the active status of the user account
     * @param v - the active status to set
     */
    public void setActive(boolean v) { 
        this.isActive = v; 
    }
    
    /**
     * Gets the account creation timestamp
     * @return the LocalDateTime when account was created
     */
    public LocalDateTime getCreatedAt() { 
        return createdAt; 
    }
    
    /**
     * Sets the account creation timestamp
     * @param v - the creation timestamp to set
     */
    public void setCreatedAt(LocalDateTime v) { 
        this.createdAt = v; 
    }

    // ========== UTILITY METHODS ==========
    
    /**
     * Returns the creation date in formatted string
     * @return formatted date string (yyyy-MM-dd) or "—" if null
     */
    public String getCreatedAtFormatted() {
        if (createdAt == null) return "—";
        return createdAt.toLocalDate().toString();
    }

    /**
     * Checks if the user has ADMIN role
     * @return true if user role is ADMIN, false otherwise
     */
    public boolean isAdmin() { 
        return "ADMIN".equalsIgnoreCase(roleName); 
    }
    
    /**
     * Checks if the user has STUDENT role
     * @return true if user role is STUDENT, false otherwise
     */
    public boolean isStudent() { 
        return "STUDENT".equalsIgnoreCase(roleName); 
    }

    // ========== OBJECT METHODS ==========
    
    /**
     * Returns a string representation of the User object
     * @return formatted string with userId, username, and role
     */
    @Override 
    public String toString() {
        return "User{userId=" + userId + ", username='" + username + "', role='" + roleName + "'}";
    }
}
