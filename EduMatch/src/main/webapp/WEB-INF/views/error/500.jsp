<%--
  500.jsp - Internal Server Error Page
  Displays a user-friendly 500 error page when an unhandled exception occurs on the server
  Shows error code, server error message, and optional debug info when DEBUG mode is enabled
  Includes navigation link back to homepage
--%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>500 – Server Error</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body class="d-flex align-items-center justify-content-center min-vh-100 bg-light">
<div class="text-center p-5">
  <div style="font-size:5rem;">⚙️</div>
  <h1 class="fw-bold mt-3 text-danger">500</h1>
  <h4 class="text-muted mb-3">Internal Server Error</h4>
  <p class="text-muted">Something went wrong on our end. Please try again later.</p>
  <% if (exception != null && application.getInitParameter("DEBUG") != null) { %>
    <div class="alert alert-danger text-start small mt-3">
      <strong>Error:</strong> <%=exception.getMessage()%>
    </div>
  <% } %>
  <a href="${pageContext.request.contextPath}/" class="btn btn-primary rounded-pill px-4">← Go Home</a>
</div>
</body></html>
