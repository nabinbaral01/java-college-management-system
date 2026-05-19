/**
 * ApplicationServlet – handles student application actions (list, submit, withdraw).
 *
 * MVC controller for student-facing application operations.
 * Updated: pushed code provided by user on 2026-05-19.
 */
package com.edumatch.controller;

import com.edumatch.dao.ApplicationDAO;
import com.edumatch.model.*;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.*;

public class ApplicationServlet extends HttpServlet {
	private static final Logger LOGGER = Logger.getLogger(ApplicationServlet.class.getName());

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		User user = (User) req.getSession().getAttribute("loggedUser");
		String pathInfo = req.getPathInfo(); // e.g. /withdraw/5

		try {
			ApplicationDAO dao = new ApplicationDAO();
			if (pathInfo != null && pathInfo.startsWith("/withdraw/")) {
				int appId = Integer.parseInt(pathInfo.substring("/withdraw/".length()));
				dao.withdrawApplication(appId, user.getUserId());
				req.getSession().setAttribute("successMessage", "Application withdrawn successfully.");
				resp.sendRedirect(req.getContextPath() + "/student/applications");
				return;
			}

			List<Application> apps = dao.getApplicationsByUser(user.getUserId());
			req.setAttribute("applications", apps);
		} catch (SQLException | NumberFormatException e) {
			LOGGER.log(Level.SEVERE, "Application error", e);
			req.setAttribute("error", "Could not load applications.");
		}
		req.getRequestDispatcher("/WEB-INF/views/student/applications.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		User user      = (User) req.getSession().getAttribute("loggedUser");
		String progIdStr = req.getParameter("programId");
		String remarks   = req.getParameter("remarks");

		if (progIdStr == null || progIdStr.isEmpty()) {
			resp.sendRedirect(req.getContextPath() + "/student/match");
			return;
		}

		try {
			int programId = Integer.parseInt(progIdStr);
			ApplicationDAO dao = new ApplicationDAO();

			if (dao.hasApplied(user.getUserId(), programId)) {
				req.getSession().setAttribute("errorMessage", "You have already applied to this program.");
				resp.sendRedirect(req.getContextPath() + "/student/applications");
				return;
			}

			int appId = dao.createApplication(user.getUserId(), programId, remarks);
			if (appId > 0) {
				req.getSession().setAttribute("successMessage", "Application submitted successfully!");
			} else {
				req.getSession().setAttribute("errorMessage", "Failed to submit application. Please try again.");
			}
			resp.sendRedirect(req.getContextPath() + "/student/applications");

		} catch (SQLException | NumberFormatException e) {
			LOGGER.log(Level.SEVERE, "Application submit error", e);
			req.getSession().setAttribute("errorMessage", "System error. Please try again.");
			resp.sendRedirect(req.getContextPath() + "/student/match");
		}
	}
}
