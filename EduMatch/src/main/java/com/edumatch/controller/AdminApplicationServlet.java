package com.edumatch.controller;

import com.edumatch.dao.ApplicationDAO;
import com.edumatch.model.Application;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.*;

public class AdminApplicationServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminApplicationServlet.class.getName());
    private final ApplicationDAO dao = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String filter   = req.getParameter("status");
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                List<Application> apps = dao.getAllApplications(filter);
                req.setAttribute("applications", apps);
                req.setAttribute("statusFilter", filter);
                req.getRequestDispatcher("/WEB-INF/views/admin/applications.jsp").forward(req, resp);

            } else if (pathInfo.startsWith("/view/")) {
                int id = Integer.parseInt(pathInfo.substring("/view/".length()));
                Application app = dao.findById(id);
                req.setAttribute("application", app);
                req.getRequestDispatcher("/WEB-INF/views/admin/application-view.jsp").forward(req, resp);
            }
        } catch (SQLException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Admin application GET error", e);
            resp.sendRedirect(req.getContextPath() + "/admin/applications");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String appIdStr    = req.getParameter("applicationId");
        String newStatus   = req.getParameter("status");
        String adminNotes  = req.getParameter("adminNotes");

        try {
            int appId = Integer.parseInt(appIdStr);
            dao.updateStatus(appId, newStatus, adminNotes);
            req.getSession().setAttribute("successMessage",
                "Application status updated to: " + newStatus);
            resp.sendRedirect(req.getContextPath() + "/admin/applications");
        } catch (SQLException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Admin application POST error", e);
            req.getSession().setAttribute("errorMessage", "Failed to update application.");
            resp.sendRedirect(req.getContextPath() + "/admin/applications");
        }
    }
}
