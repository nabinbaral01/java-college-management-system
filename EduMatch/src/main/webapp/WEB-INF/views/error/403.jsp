<%--
  403.jsp - Access Forbidden Error Page
  Displays a user-friendly 403 error page when access to a resource is denied
  Shows forbidden icon, error code, and link to navigate back to homepage
--%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>403 – Forbidden</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body class="d-flex align-items-center justify-content-center min-vh-100 bg-light">
<div class="text-center p-5">
  <div style="font-size:5rem;">🚫</div>
  <h1 class="fw-bold mt-3" style="color:#1a237e;">403</h1>
  <h4 class="text-muted mb-3">Access Forbidden</h4>
  <p class="text-muted">You don't have permission to access this page.</p>
  <a href="${pageContext.request.contextPath}/" class="btn btn-primary rounded-pill px-4">← Go Home</a>
</div>
</body></html>
