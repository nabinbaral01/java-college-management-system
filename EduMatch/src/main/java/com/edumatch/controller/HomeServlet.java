package com.edumatch.controller;

import com.edumatch.dao.CollegeDAO;
import com.edumatch.model.College;
import com.edumatch.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.*;

/** HomeServlet - Public landing page at / */
public class HomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Redirect logged-in users to their dashboard
        HttpSession session = req.getSession(false);
        if (session != null) {
            User u = (User) session.getAttribute("loggedUser");
            if (u != null) {
                resp.sendRedirect(req.getContextPath() + (u.isAdmin() ? "/admin/dashboard" : "/student/dashboard"));
                return;
            }
        }
        try {
            CollegeDAO dao = new CollegeDAO();
            List<College> featured = dao.getAllColleges(null, null, null, 0);
            if (featured.size() > 6) featured = featured.subList(0, 6);
            req.setAttribute("featuredColleges", featured);
            req.setAttribute("totalColleges",    dao.countColleges());
            req.setAttribute("totalPrograms",    dao.countPrograms());
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Home page load error", e);
        }
        req.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(req, resp);
    }
}
