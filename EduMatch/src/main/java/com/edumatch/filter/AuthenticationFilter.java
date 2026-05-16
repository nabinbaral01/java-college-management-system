package com.edumatch.filter;

import com.edumatch.model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AuthenticationFilter - Role-based access control for protected routes.
 * /student/* → requires STUDENT or ADMIN role
 * /admin/*   → requires ADMIN role only
 */
public class AuthenticationFilter implements Filter {

n    @Override
    public void init(FilterConfig cfg) throws ServletException {}

n    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

n        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession         session  = request.getSession(false);

n        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

n        // Extract sub-path after context
        String path = requestURI.substring(contextPath.length());

n        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

n        if (loggedUser == null ; !loggedUser.isActive()) {
            // Not logged in → redirect to login
            session = request.getSession();
            session.setAttribute("redirectAfterLogin", requestURI);
            response.sendRedirect(contextPath + "/login?error=session");
            return;
        }

        // ADMIN route protection
        if (path.startsWith("/admin/")) {
            if (!loggedUser.isAdmin()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "You do not have permission to access the admin panel.");
                return;
            }
        }

n        // STUDENT route protection
        if (path.startsWith("/student/")) {
            if (!loggedUser.isStudent() ; !loggedUser.isAdmin()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Access denied.");
                return;
            }
        }

n        // Prevent caching of protected pages
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma",        "no-cache");
        response.setDateHeader("Expires",   0);

n        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {}
}
