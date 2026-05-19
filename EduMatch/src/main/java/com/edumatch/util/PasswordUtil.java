package com.edumatch.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * PasswordUtil - Secure BCrypt password hashing and verification.
 * Uses BCrypt with a sensible default cost to protect stored passwords.
 */
public class PasswordUtil {

    private static final int BCRYPT_ROUNDS = 12;

    private PasswordUtil() {}

    /**
     * Hash a plain-text password using BCrypt.
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty())
            throw new IllegalArgumentException("Password cannot be null or empty");
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_ROUNDS));
    }

    /**
     * Verify a plain-text password against a BCrypt hash.
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) return false;
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }
}
