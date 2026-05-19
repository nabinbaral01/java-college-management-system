package com.edumatch.controller;

import com.edumatch.dao.CollegeDAO;
import com.edumatch.model.Program;
import com.edumatch.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.*;

/** CollegeMatchServlet – eligibility-based college matching for students. */
public class CollegeMatchServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CollegeMatchServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user       = (User) req.getSession().getAttribute("loggedUser");
        String faculty  = req.getParameter("faculty");
        String province = req.getParameter("province");

        int facultyId = 0;
        try { if (faculty != null && !faculty.isEmpty()) facultyId = Integer.parseInt(faculty); }
        catch (NumberFormatException ignored) {}

        try {
            CollegeDAO dao   = new CollegeDAO();
            List<Program> matches = dao.matchPrograms(user.getUserId(), facultyId, province);

            long eligible   = matches.stream().filter(Program::isEligible).count();
            long ineligible = matches.size() - eligible;

            req.setAttribute("matches",    matches);
            req.setAttribute("eligible",   eligible);
            req.setAttribute("ineligible", ineligible);
            req.setAttribute("selFaculty", faculty);
            req.setAttribute("selProvince",province);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Match error", e);
            req.setAttribute("matchError", "Could not perform matching. Please ensure your academic records are complete.");
        }
        req.getRequestDispatcher("/WEB-INF/views/student/match.jsp").forward(req, resp);
    }
}
