package com.edumatch.controller;

import com.edumatch.dao.CollegeDAO;
import com.edumatch.dao.StudentProfileDAO;
import com.edumatch.model.College;
import com.edumatch.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.*;

/** SavedCollegeServlet - student bookmark feature: list saved colleges (GET) and save / unsave on POST. */
public class SavedCollegeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SavedCollegeServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedUser");
        try {
            StudentProfileDAO spDAO  = new StudentProfileDAO();
            CollegeDAO        colDAO = new CollegeDAO();
            List<Integer> savedIds = spDAO.getSavedCollegeIds(user.getUserId());
            List<College>  saved   = new ArrayList<>();
            for (int id : savedIds) {
                College c = colDAO.findById(id);
                if (c != null) saved.add(c);
            }
            req.setAttribute("savedColleges", saved);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Saved colleges error", e);
        }
        req.getRequestDispatcher("/WEB-INF/views/student/saved.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user       = (User) req.getSession().getAttribute("loggedUser");
        String action   = req.getParameter("action");   // "save" or "unsave"
        String colIdStr = req.getParameter("collegeId");
        String redirect = req.getParameter("redirect");

        if (colIdStr == null || colIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/saved"); return;
        }
        try {
            int collegeId = Integer.parseInt(colIdStr);
            StudentProfileDAO dao = new StudentProfileDAO();
            if ("unsave".equals(action)) dao.unsaveCollege(user.getUserId(), collegeId);
            else                          dao.saveCollege  (user.getUserId(), collegeId);

            String dest = (redirect != null && !redirect.isEmpty())
                ? redirect
                : req.getContextPath() + "/student/saved";
            resp.sendRedirect(dest);
        } catch (SQLException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Save/unsave error", e);
            resp.sendRedirect(req.getContextPath() + "/student/saved");
        }
    }
}
