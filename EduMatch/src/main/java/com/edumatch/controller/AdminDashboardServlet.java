package com.edumatch.controller;

import com.edumatch.dao.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.*;

/** AdminDashboardServlet – summary stats for admin panel. */
public class AdminDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            UserDAO        uDAO   = new UserDAO();
            CollegeDAO     cDAO   = new CollegeDAO();
            ApplicationDAO aDAO   = new ApplicationDAO();

            req.setAttribute("totalStudents",    uDAO.countByRole("STUDENT"));
            req.setAttribute("totalColleges",    cDAO.countColleges());
            req.setAttribute("totalPrograms",    cDAO.countPrograms());
            req.setAttribute("totalApplications",aDAO.countApplications());
            req.setAttribute("pendingApps",      aDAO.countByStatus("Submitted"));
            req.setAttribute("acceptedApps",     aDAO.countByStatus("Accepted"));
            req.setAttribute("recentApps",       aDAO.getAllApplications("Submitted"));
            req.setAttribute("recentStudents",   uDAO.getUsersByRole("STUDENT"));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Admin dashboard error", e);
            req.setAttribute("dashError", "Could not load statistics.");
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}