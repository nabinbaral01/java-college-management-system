package com.edumatch.controller;

import com.edumatch.dao.*;
import com.edumatch.model.*;
import com.edumatch.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.logging.*;

/** StudentProfileServlet – view & update student profile. */
public class StudentProfileServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StudentProfileServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedUser");
        try {
            StudentProfileDAO dao = new StudentProfileDAO();
            StudentProfile profile = dao.findByUserId(user.getUserId());
            req.setAttribute("profile", profile);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Profile load error", e);
        }
        req.getRequestDispatcher("/WEB-INF/views/student/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedUser");

        String fullName      = req.getParameter("fullName");
        String dob           = req.getParameter("dateOfBirth");
        String gender        = req.getParameter("gender");
        String phone         = req.getParameter("phone");
        String address       = req.getParameter("address");
        String district      = req.getParameter("district");
        String province      = req.getParameter("province");
        String citizenshipNo = req.getParameter("citizenshipNo");
        String bio           = req.getParameter("bio");

        if (ValidationUtil.isNullOrEmpty(fullName)) {
            req.setAttribute("error", "Full name is required.");
            doGet(req, resp); return;
        }
        if (!ValidationUtil.isValidPhone(phone)) {
            req.setAttribute("error", "Invalid phone number format.");
            doGet(req, resp); return;
        }

        try {
            StudentProfileDAO dao = new StudentProfileDAO();
            StudentProfile sp = new StudentProfile();
            sp.setUserId      (user.getUserId());
            sp.setFullName    (fullName.trim());
            sp.setGender      (gender);
            sp.setPhone       (phone);
            sp.setAddress     (address);
            sp.setDistrict    (district);
            sp.setProvince    (province);
            sp.setCitizenshipNo(citizenshipNo);
            sp.setBio         (bio);
            if (dob != null && !dob.isEmpty()) {
                try { sp.setDateOfBirth(LocalDate.parse(dob)); } catch (Exception ignored) {}
            }

            if (dao.profileExists(user.getUserId())) dao.updateProfile(sp);
            else dao.createProfile(sp);

            req.getSession().setAttribute("successMessage", "Profile updated successfully!");
            resp.sendRedirect(req.getContextPath() + "/student/profile");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Profile save error", e);
            req.setAttribute("error", "Failed to update profile. Please try again.");
            doGet(req, resp);
        }
    }
}
