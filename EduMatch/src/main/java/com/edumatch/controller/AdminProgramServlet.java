/**
 * AdminProgramServlet - Handles HTTP requests for program management operations
 * Provides CRUD operations for academic programs including degree levels, fees, eligibility criteria
 * Supports both GET and POST requests for managing program data associated with colleges
 */
package com.edumatch.controller;

import com.edumatch.dao.CollegeDAO;
import com.edumatch.model.Program;
import com.edumatch.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.*;

public class AdminProgramServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminProgramServlet.class.getName());
    private final CollegeDAO dao = new CollegeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                req.setAttribute("programs", dao.getAllPrograms());
                req.setAttribute("colleges", dao.getAllColleges(null, null, null, 0));
                req.getRequestDispatcher("/WEB-INF/views/admin/programs.jsp").forward(req, resp);

            } else if (pathInfo.equals("/new")) {
                req.setAttribute("colleges", dao.getAllColleges(null, null, null, 0));
                req.getRequestDispatcher("/WEB-INF/views/admin/program-form.jsp").forward(req, resp);

            } else if (pathInfo.startsWith("/edit/")) {
                int id = Integer.parseInt(pathInfo.substring("/edit/".length()));
                req.setAttribute("program", dao.findProgramById(id));
                req.setAttribute("colleges", dao.getAllColleges(null, null, null, 0));
                req.getRequestDispatcher("/WEB-INF/views/admin/program-form.jsp").forward(req, resp);

            } else if (pathInfo.startsWith("/delete/")) {
                int id = Integer.parseInt(pathInfo.substring("/delete/".length()));
                dao.deleteProgram(id);
                req.getSession().setAttribute("successMessage", "Program deleted.");
                resp.sendRedirect(req.getContextPath() + "/admin/programs");
            }
        } catch (SQLException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Admin program GET error", e);
            resp.sendRedirect(req.getContextPath() + "/admin/programs");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            Program p = new Program();
            p.setCollegeId      (Integer.parseInt(req.getParameter("collegeId")));
            p.setFacultyId      (Integer.parseInt(req.getParameter("facultyId")));
            p.setProgramName    (req.getParameter("programName").trim());
            p.setDegreeLevel    (req.getParameter("degreeLevel"));
            p.setDescription    (req.getParameter("description"));
            p.setEntranceName   (req.getParameter("entranceName"));

            String dur = req.getParameter("durationYears");
            if (dur != null && !dur.isEmpty())   p.setDurationYears(Double.parseDouble(dur));
            String seats = req.getParameter("totalSeats");
            if (seats != null && !seats.isEmpty()) p.setTotalSeats(Integer.parseInt(seats));
            String fee = req.getParameter("annualFee");
            if (fee != null && !fee.isEmpty())   p.setAnnualFee(Double.parseDouble(fee));
            String gpa = req.getParameter("minGpa");
            if (gpa != null && !gpa.isEmpty())   p.setMinGpa(Double.parseDouble(gpa));
            String pct = req.getParameter("minPercentage");
            if (pct != null && !pct.isEmpty())   p.setMinPercentage(Double.parseDouble(pct));
            p.setEntranceRequired("on".equals(req.getParameter("entranceRequired")));
            p.setActive(true);

            if ("update".equals(action)) {
                p.setProgramId(Integer.parseInt(req.getParameter("programId")));
                p.setActive("true".equals(req.getParameter("isActive")));
                dao.updateProgram(p);
                req.getSession().setAttribute("successMessage", "Program updated.");
            } else {
                dao.createProgram(p);
                req.getSession().setAttribute("successMessage", "Program added.");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/programs");
        } catch (SQLException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Admin program POST error", e);
            req.setAttribute("error", "Failed to save program: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/admin/program-form.jsp").forward(req, resp);
        }
    }
}
