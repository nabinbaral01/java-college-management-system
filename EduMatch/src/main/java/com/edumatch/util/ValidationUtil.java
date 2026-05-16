package com.edumatch.util;

import java.util.regex.Pattern;

/**
 * ValidationUtil - Input validation utilities for EduMatch.
 * Centralises all validation logic to avoid code duplication.
 */
public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern PHONE_PATTERN =
        Pattern.compile("^(\\+977[-\\s]?)?(98|97|96|01|02|03|04|05|06|07|08|09)\\d{6,8}$");

    private static final Pattern USERNAME_PATTERN =
        Pattern.compile("^[a-zA-Z0-9_]{3,50}$");

    private static final Pattern PASSWORD_PATTERN =
        Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$");

    private ValidationUtil() {}

    public static boolean isNullOrEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        return phone == null || phone.trim().isEmpty() ||
               PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean isValidUsername(String username) {
        return username != null && USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    public static boolean isValidPassword(String password) {
        return password != null && PASSWORD_PATTERN.matcher(password).matches();
    }

    public static boolean isValidGPA(String gpa) {
        if (isNullOrEmpty(gpa)) return true;
        try {
            double val = Double.parseDouble(gpa.trim());
            return val >= 0 && val <= 4.0;
        } catch (NumberFormatException e) { return false; }
    }

    public static boolean isValidPercentage(String pct) {
        if (isNullOrEmpty(pct)) return true;
        try {
            double val = Double.parseDouble(pct.trim());
            return val >= 0 && val <= 100;
        } catch (NumberFormatException e) { return false; }
    }

    public static boolean isValidYear(String year) {
        if (isNullOrEmpty(year)) return true;
        try {
            int y = Integer.parseInt(year.trim());
            return y >= 1950 && y <= 2100;
        } catch (NumberFormatException e) { return false; }
    }

    public static boolean isPositiveInteger(String val) {
        if (isNullOrEmpty(val)) return true;
        try {
            return Integer.parseInt(val.trim()) > 0;
        } catch (NumberFormatException e) { return false; }
    }

    public static boolean isPositiveDouble(String val) {
        if (isNullOrEmpty(val)) return true;
        try {
            return Double.parseDouble(val.trim()) > 0;
        } catch (NumberFormatException e) { return false; }
    }

    public static String sanitize(String input) {
        if (input == null) return null;
        return input.trim()
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;")
                    .replace("/", "&#x2F;");
    }

    public static String safeString(String input, int maxLen) {
        String s = sanitize(input);
        if (s != null && s.length() > maxLen) s = s.substring(0, maxLen);
        return s;
    }
}
