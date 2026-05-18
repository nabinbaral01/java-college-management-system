package com.edumatch.controller;

import com.edumatch.dao.StudentProfileDAO;
import com.edumatch.model.AcademicRecord;
import com.edumatch.model.User;
import com.edumatch.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.*;

public class AcademicRecordServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AcademicRecordServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedUser");
        try {
            StudentProfileDAO dao = new StudentProfileDAO();
            List<AcademicRecord> records = dao.getRecordsByUser(user.getUserId());
            req.setAttribute("records", records);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Academic records load error", e);
        }
        req.getRequestDispatcher("/WEB-INF/views/student/academic.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedUser");

        String level       = req.getParameter("level");
        String board       = req.getParameter("board");
        String institution = req.getParameter("institution");
        String passedYear  = req.getParameter("passedYear");
        String gpa         = req.getParameter("gpa");
        String percentage  = req.getParameter("percentage");
        String grade       = req.getParameter("grade");

        // Validation
        if (ValidationUtil.isNullOrEmpty(level)) {
            req.setAttribute("error", "Education level is required.");
            doGet(req, resp); return;
        }
        if (!ValidationUtil.isValidGPA(gpa)) {
            req.setAttribute("error", "GPA must be between 0.00 and 4.00.");
            doGet(req, resp); return;
        }
        if (!ValidationUtil.isValidPercentage(percentage)) {
            req.setAttribute("error", "Percentage must be between 0 and 100.");
            doGet(req, resp); return;
        }
        if (!ValidationUtil.isValidYear(passedYear)) {
            req.setAttribute("error", "Please enter a valid year.");
            doGet(req, resp); return;
        }

        try {
            AcademicRecord r = new AcademicRecord();
            r.setUserId     (user.getUserId());
            r.setLevel      (level);
            r.setBoard      (board);
            r.setInstitution(institution);
            r.setGrade      (grade);
            if (passedYear != null && !passedYear.isEmpty())
                r.setPassedYear(Integer.parseInt(passedYear));
            if (gpa != null && !gpa.isEmpty())
                r.setGpa(Double.parseDouble(gpa));
            if (percentage != null && !percentage.isEmpty())
                r.setPercentage(Double.parseDouble(percentage));

            new StudentProfileDAO().saveAcademicRecord(r);
            req.getSession().setAttribute("successMessage", "Academic record saved successfully!");
            resp.sendRedirect(req.getContextPath() + "/student/academic");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Academic record save error", e);
            req.setAttribute("error", "Failed to save academic record.");
            doGet(req, resp);
        }
    }
}
