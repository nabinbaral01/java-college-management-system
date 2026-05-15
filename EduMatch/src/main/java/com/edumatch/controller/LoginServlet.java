package com.edumatch.controller;

import com.edumatch.dao.UserDAO;
import com.edumatch.model.User;
import com.edumatch.util.PasswordUtil;
import com.edumatch.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.*;

/**
 * LoginServlet - Handles GET (show form) and POST (authenticate) for /login.
 */
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Already logged in → redirect to appropriate dashboard
        HttpSession session = req.getSession(false);
        if (session != null) {
            User u = (User) session.getAttribute("loggedUser");
            if (u != null) {
                redirectToDashboard(u, req, resp);
                return;
            }
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Basic validation
        if (ValidationUtil.isNullOrEmpty(username) || ValidationUtil.isNullOrEmpty(password)) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userDAO.findByUsername(username.trim());

            if (user == null || !PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
                req.setAttribute("error", "Invalid username or password.");
                req.setAttribute("username", ValidationUtil.sanitize(username));
                req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
                return;
            }

            if (!user.isActive()) {
                req.setAttribute("error", "Your account has been deactivated. Please contact admin.");
                req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
                return;
            }

            // Create session
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setAttribute("userId",     user.getUserId());
            session.setAttribute("username",   user.getUsername());
            session.setAttribute("role",       user.getRoleName());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            LOGGER.info("User logged in: " + user.getUsername() + " [" + user.getRoleName() + "]");

            // Handle redirect-after-login
            String redirect = (String) session.getAttribute("redirectAfterLogin");
            session.removeAttribute("redirectAfterLogin");
            if (redirect != null && !redirect.isEmpty()) {
                resp.sendRedirect(redirect);
            } else {
                redirectToDashboard(user, req, resp);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Login DB error", e);
            req.setAttribute("error", "A system error occurred. Please try again later.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
        }
    }

    private void redirectToDashboard(User user, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String ctx = req.getContextPath();
        if (user.isAdmin()) {
            resp.sendRedirect(ctx + "/admin/dashboard");
        } else {
            resp.sendRedirect(ctx + "/student/dashboard");
        }
    }
}
