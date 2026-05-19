package com.edumatch.controller;

import com.edumatch.dao.StudentProfileDAO;
import com.edumatch.dao.UserDAO;
import com.edumatch.model.StudentProfile;
import com.edumatch.util.PasswordUtil;
import com.edumatch.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.*;

public class RegisterServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());
    private final UserDAO           userDAO = new UserDAO();
    private final StudentProfileDAO spDAO   = new StudentProfileDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName        = req.getParameter("fullName");
        String username        = req.getParameter("username");
        String email           = req.getParameter("email");
        String password        = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        StringBuilder errors = new StringBuilder();
        if (ValidationUtil.isNullOrEmpty(fullName))          errors.append("Full name is required. ");
        if (!ValidationUtil.isValidUsername(username))        errors.append("Username: 3-50 alphanumeric chars only. ");
        if (!ValidationUtil.isValidEmail(email))              errors.append("Valid email required. ");
        if (!ValidationUtil.isValidPassword(password))        errors.append("Password: 8+ chars with upper, lower, digit & special char. ");
        if (password != null && !password.equals(confirmPassword)) errors.append("Passwords do not match. ");

        if (errors.length() > 0) {
            req.setAttribute("error",    errors.toString().trim());
            req.setAttribute("fullName", ValidationUtil.sanitize(fullName));
            req.setAttribute("username", ValidationUtil.sanitize(username));
            req.setAttribute("email",    ValidationUtil.sanitize(email));
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        try {
            if (userDAO.existsByUsername(username)) {
                req.setAttribute("error", "Username '" + ValidationUtil.sanitize(username) + "' is already taken.");
                req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
                return;
            }
            if (userDAO.existsByEmail(email)) {
                req.setAttribute("error", "Email '" + ValidationUtil.sanitize(email) + "' is already registered.");
                req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
                return;
            }

            String hash   = PasswordUtil.hashPassword(password);
            int    userId = userDAO.createUser(username, email, hash, 2);

            if (userId > 0) {
                StudentProfile sp = new StudentProfile();
                sp.setUserId(userId);
                sp.setFullName(fullName.trim());
                spDAO.createProfile(sp);

                LOGGER.info("New student registered: " + username);
                req.getSession().setAttribute("successMessage", "Registration successful! Please log in.");
                resp.sendRedirect(req.getContextPath() + "/login?registered=true");
            } else {
                req.setAttribute("error", "Registration failed. Please try again.");
                req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Registration error", e);
            req.setAttribute("error", "System error. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
        }
    }
}
