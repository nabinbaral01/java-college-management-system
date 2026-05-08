package com.edumatch.controller;

import com.edumatch.dao.CollegeDAO;
import com.edumatch.model.College;
import com.edumatch.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.*;

public class AdminCollegeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminCollegeServlet.class.getName());
    private final CollegeDAO dao = new CollegeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo(); // null=list, /new, /edit/5, /delete/5
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                req.setAttribute("colleges", dao.getAllColleges(null, null, null, 0));
                req.getRequestDispatcher("/WEB-INF/views/admin/colleges.jsp").forward(req, resp);

            } else if (pathInfo.equals("/new")) {
                req.getRequestDispatcher("/WEB-INF/views/admin/college-form.jsp").forward(req, resp);

            } else if (pathInfo.startsWith("/edit/")) {
                int id = Integer.parseInt(pathInfo.substring("/edit/".length()));
                College c = dao.findById(id);
                if (c == null) { resp.sendError(404); return; }
                req.setAttribute("college", c);
                req.getRequestDispatcher("/WEB-INF/views/admin/college-form.jsp").forward(req, resp);

            } else if (pathInfo.startsWith("/delete/")) {
                int id = Integer.parseInt(pathInfo.substring("/delete/".length()));
                dao.deleteCollege(id);
                req.getSession().setAttribute("successMessage", "College deleted successfully.");
                resp.sendRedirect(req.getContextPath() + "/admin/colleges");

            } else if (pathInfo.startsWith("/view/")) {
                int id = Integer.parseInt(pathInfo.substring("/view/".length()));
                College c = dao.findById(id);
                req.setAttribute("college", c);
                req.getRequestDispatcher("/WEB-INF/views/admin/college-view.jsp").forward(req, resp);
            }
        } catch (SQLException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Admin college GET error", e);
            req.getSession().setAttribute("errorMessage", "Error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/colleges");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action   = req.getParameter("action"); // "create" or "update"

        String name   = req.getParameter("collegeName");
        String type   = req.getParameter("collegeType");

        if (ValidationUtil.isNullOrEmpty(name) || ValidationUtil.isNullOrEmpty(type)) {
            req.setAttribute("error", "College name and type are required.");
            req.getRequestDispatcher("/WEB-INF/views/admin/college-form.jsp").forward(req, resp);
            return;
        }

        try {
            College c = new College();
            c.setCollegeName     (name.trim());
            c.setShortName       (req.getParameter("shortName"));
            c.setCollegeType     (type);
            c.setAffiliation     (req.getParameter("affiliation"));
            c.setAddress         (req.getParameter("address"));
            c.setPhone           (req.getParameter("phone"));
            c.setEmail           (req.getParameter("email"));
            c.setWebsite         (req.getParameter("website"));
            c.setDescription     (req.getParameter("description"));
            c.setActive          (true);

            String distStr = req.getParameter("districtId");
            if (distStr != null && !distStr.isEmpty())
                c.setDistrictId(Integer.parseInt(distStr));

            String yearStr = req.getParameter("establishmentYear");
            if (yearStr != null && !yearStr.isEmpty())
                c.setEstablishmentYear(Integer.parseInt(yearStr));

            String[] facs = req.getParameterValues("facilities");
            int[] facIds  = new int[0];
            if (facs != null) {
                facIds = new int[facs.length];
                for (int i = 0; i < facs.length; i++) facIds[i] = Integer.parseInt(facs[i]);
            }

            if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("collegeId"));
                c.setCollegeId(id);
                c.setActive("true".equals(req.getParameter("isActive")));
                dao.updateCollege(c);
                dao.updateFacilities(id, facIds);
                req.getSession().setAttribute("successMessage", "College updated successfully.");
            } else {
                int newId = dao.createCollege(c);
                if (newId > 0) dao.updateFacilities(newId, facIds);
                req.getSession().setAttribute("successMessage", "College added successfully.");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/colleges");

        } catch (SQLException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Admin college POST error", e);
            req.setAttribute("error", "Failed to save college: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/admin/college-form.jsp").forward(req, resp);
        }
    }
}
