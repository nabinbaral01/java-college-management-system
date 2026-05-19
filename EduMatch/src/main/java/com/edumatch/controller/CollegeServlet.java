package com.edumatch.controller;

import com.edumatch.dao.CollegeDAO;
import com.edumatch.dao.StudentProfileDAO;
import com.edumatch.model.College;
import com.edumatch.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.*;

/** CollegeServlet – public browsing of colleges. /colleges and /college/{id} */
public class CollegeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CollegeServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo(); // null for /colleges, "/5" for /college/5

        CollegeDAO dao = new CollegeDAO();
        try {
            if (pathInfo != null && pathInfo.length() > 1) {
                // Detail view
                int collegeId = Integer.parseInt(pathInfo.substring(1));
                College college = dao.findById(collegeId);
                if (college == null) { resp.sendError(404, "College not found"); return; }

                // Check if saved by current user
                HttpSession session = req.getSession(false);
                if (session != null) {
                    User u = (User) session.getAttribute("loggedUser");
                    if (u != null && u.isStudent()) {
                        List<Integer> saved = new StudentProfileDAO().getSavedCollegeIds(u.getUserId());
                        req.setAttribute("isSaved", saved.contains(collegeId));
                    }
                }
                req.setAttribute("college", college);
                req.getRequestDispatcher("/WEB-INF/views/college/detail.jsp").forward(req, resp);
            } else {
                // List view
                String search   = req.getParameter("q");
                String type     = req.getParameter("type");
                String province = req.getParameter("province");
                String facStr   = req.getParameter("faculty");
                int facultyId   = 0;
                try { if (facStr != null) facultyId = Integer.parseInt(facStr); } catch (Exception ignored) {}

                List<College> colleges = dao.getAllColleges(search, type, province, facultyId);
                req.setAttribute("colleges",    colleges);
                req.setAttribute("searchQuery", search);
                req.setAttribute("selType",     type);
                req.setAttribute("selProvince", province);
                req.setAttribute("selFaculty",  facStr);
                req.getRequestDispatcher("/WEB-INF/views/college/list.jsp").forward(req, resp);
            }
        } catch (SQLException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "College browse error", e);
            req.setAttribute("error", "Error loading college data.");
            req.getRequestDispatcher("/WEB-INF/views/college/list.jsp").forward(req, resp);
        }
    }
}
