<%--
  header.jsp - Common Header Navigation Component
  Reusable header fragment included in all pages of the EduMatch application
  Features:
  - Sticky navigation bar with responsive design
  - Role-based menu items (STUDENT, ADMIN, or anonymous)
  - User authentication dropdown with dashboard/profile links
  - Bootstrap icons and styling
  - Session-based flash message display for success/error alerts
  - Dynamic navbar styling based on user login status
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.edumatch.model.User _u = (com.edumatch.model.User) session.getAttribute("loggedUser");
    String _role = (_u != null) ? _u.getRoleName() : "";
    String _ctx  = request.getContextPath();
%>
<nav class="navbar navbar-expand-lg navbar-dark sticky-top" style="background:linear-gradient(135deg,#1a237e,#283593);">
  <div class="container-fluid px-4">
    <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="<%=_ctx%>/">
      <span style="font-size:1.5rem;">🎓</span>
      <span style="letter-spacing:1px;">EduMatch</span>
      <small class="badge bg-warning text-dark ms-1" style="font-size:.55rem;">Nepal</small>
    </a>
    <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMain">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navMain">
      <ul class="navbar-nav me-auto gap-1">
        <li class="nav-item"><a class="nav-link" href="<%=_ctx%>/colleges"><i class="bi bi-building me-1"></i>Colleges</a></li>
        <% if ("STUDENT".equals(_role)) { %>
        <li class="nav-item"><a class="nav-link" href="<%=_ctx%>/student/match"><i class="bi bi-stars me-1"></i>Match Me</a></li>
        <li class="nav-item"><a class="nav-link" href="<%=_ctx%>/student/applications"><i class="bi bi-file-earmark-text me-1"></i>Applications</a></li>
        <li class="nav-item"><a class="nav-link" href="<%=_ctx%>/student/saved"><i class="bi bi-bookmark me-1"></i>Saved</a></li>
        <% } else if ("ADMIN".equals(_role)) { %>
        <li class="nav-item"><a class="nav-link" href="<%=_ctx%>/admin/dashboard"><i class="bi bi-speedometer2 me-1"></i>Admin</a></li>
        <% } %>
      </ul>
      <ul class="navbar-nav gap-1 align-items-center">
        <% if (_u != null) { %>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" data-bs-toggle="dropdown">
            <span class="rounded-circle bg-warning text-dark d-flex align-items-center justify-content-center fw-bold"
                  style="width:32px;height:32px;font-size:.85rem;">
              <%=_u.getUsername().substring(0,1).toUpperCase()%>
            </span>
            <span><%=_u.getUsername()%></span>
          </a>
          <ul class="dropdown-menu dropdown-menu-end shadow border-0">
            <% if ("STUDENT".equals(_role)) { %>
            <li><a class="dropdown-item" href="<%=_ctx%>/student/dashboard"><i class="bi bi-house me-2 text-primary"></i>Dashboard</a></li>
            <li><a class="dropdown-item" href="<%=_ctx%>/student/profile"><i class="bi bi-person me-2 text-primary"></i>Profile</a></li>
            <li><a class="dropdown-item" href="<%=_ctx%>/student/academic"><i class="bi bi-journal-text me-2 text-primary"></i>Academic Records</a></li>
            <% } else if ("ADMIN".equals(_role)) { %>
            <li><a class="dropdown-item" href="<%=_ctx%>/admin/dashboard"><i class="bi bi-speedometer2 me-2 text-primary"></i>Dashboard</a></li>
            <% } %>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="<%=_ctx%>/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
          </ul>
        </li>
        <% } else { %>
        <li class="nav-item"><a class="nav-link" href="<%=_ctx%>/login">Login</a></li>
        <li class="nav-item"><a class="btn btn-warning btn-sm px-3 fw-semibold ms-2" href="<%=_ctx%>/register">Register Free</a></li>
        <% } %>
      </ul>
    </div>
  </div>
</nav>

<%-- Flash messages --%>
<c:if test="${not empty sessionScope.successMessage}">
  <div class="alert alert-success alert-dismissible fade show mb-0 rounded-0 text-center fw-semibold" role="alert">
    <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.successMessage}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  </div>
  <% session.removeAttribute("successMessage"); %>
</c:if>
<c:if test="${not empty sessionScope.errorMessage}">
  <div class="alert alert-danger alert-dismissible fade show mb-0 rounded-0 text-center fw-semibold" role="alert">
    <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.errorMessage}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  </div>
  <% session.removeAttribute("errorMessage"); %>
</c:if>
