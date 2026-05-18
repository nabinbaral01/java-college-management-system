package com.edumatch.controller;

import com.edumatch.dao.*;
import com.edumatch.model.*;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.*;

public class StudentDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StudentDashboardServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedUser");
        try {
            StudentProfileDAO spDAO  = new StudentProfileDAO();
            ApplicationDAO    appDAO = new ApplicationDAO();

            StudentProfile    profile = spDAO.findByUserId(user.getUserId());
            List<AcademicRecord> records = spDAO.getRecordsByUser(user.getUserId());
            List<Application> applications = appDAO.getApplicationsByUser(user.getUserId());
            List<Integer>     savedIds = spDAO.getSavedCollegeIds(user.getUserId());

            req.setAttribute("profile",      profile);
            req.setAttribute("records",      records);
            req.setAttribute("applications", applications);
            req.setAttribute("savedCount",   savedIds.size());
            req.setAttribute("appCount",     applications.size());

            long accepted = applications.stream().filter(a -> "Accepted".equals(a.getStatus())).count();
            long pending  = applications.stream().filter(a -> "Submitted".equals(a.getStatus()) || "Under Review".equals(a.getStatus())).count();
            req.setAttribute("acceptedCount", accepted);
            req.setAttribute("pendingCount",  pending);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Dashboard load error", e);
            req.setAttribute("dashboardError", "Could not load dashboard data.");
        }
        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }
}
