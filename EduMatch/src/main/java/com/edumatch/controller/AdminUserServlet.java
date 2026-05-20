/**
 * AdminUserServlet - Handles HTTP requests for user management operations
 * Provides functionality to view all users, toggle user active/inactive status, and delete users
 * Supports user account management and access control through status modifications
 */
package com.edumatch.controller;

import com.edumatch.dao.UserDAO;
import com.edumatch.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.*;

public class AdminUserServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminUserServlet.class.getName());
    private final UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                req.setAttribute("users", dao.getAllUsers());
                req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);

            } else if (pathInfo.startsWith("/toggle/")) {
                int id = Integer.parseInt(pathInfo.substring("/toggle/".length()));
                User u = dao.findById(id);
                if (u != null) {
                    dao.updateActiveStatus(id, !u.isActive());
                    req.getSession().setAttribute("successMessage",
                        "User " + (u.isActive() ? "deactivated" : "activated") + " successfully.");
                }
                resp.sendRedirect(req.getContextPath() + "/admin/users");

            } else if (pathInfo.startsWith("/delete/")) {
                int id = Integer.parseInt(pathInfo.substring("/delete/".length()));
                dao.deleteUser(id);
                req.getSession().setAttribute("successMessage", "User deleted.");
                resp.sendRedirect(req.getContextPath() + "/admin/users");
            }
        } catch (SQLException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Admin user error", e);
            resp.sendRedirect(req.getContextPath() + "/admin/users");
        }
    }
}
