<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Admin users view: lists users and provides toggle/delete actions for administrators --%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Manage Users – Admin</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .admin-sidebar{background:linear-gradient(180deg,#0d1b4b,#1a237e);min-height:calc(100vh - 62px);width:250px;flex-shrink:0;}
    .admin-sidebar .nav-link{color:rgba(255,255,255,.7);border-radius:10px;padding:10px 14px;margin:2px 8px;transition:.2s;}
    .admin-sidebar .nav-link:hover,.admin-sidebar .nav-link.active{background:rgba(255,255,255,.15);color:#fff;}
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<div class="d-flex">
  <div class="admin-sidebar py-4">
    <div class="px-4 mb-3"><span class="badge bg-warning text-dark small px-3 py-2 rounded-pill"><i class="bi bi-shield-check me-1"></i>Admin Panel</span></div>
    <nav class="nav flex-column mt-2">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/colleges"><i class="bi bi-building me-2"></i>Manage Colleges</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/programs"><i class="bi bi-book me-2"></i>Manage Programs</a>
      <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-2"></i>Manage Users</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/applications"><i class="bi bi-file-earmark-check me-2"></i>Applications</a>
      <hr class="border-light opacity-25 mx-3">
      <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
    </nav>
  </div>
  <div class="flex-grow-1 p-4">
    <h4 class="fw-bold mb-4" style="color:#1a237e;"><i class="bi bi-people me-2"></i>Manage Users</h4>
    <div class="card border-0 shadow-sm rounded-4">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
              <tr>
                <th class="px-4 py-3">User</th>
                <th>Email</th>
                <th>Role</th>
                <th>Status</th>
                <th>Registered</th>
                <th class="px-4">Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="u" items="${users}">
              <tr>
                <td class="px-4">
                  <div class="d-flex align-items-center gap-2">
                    <div class="rounded-circle bg-primary bg-opacity-10 text-primary fw-bold d-flex align-items-center justify-content-center"
                         style="width:36px;height:36px;font-size:.9rem;">${fn:toUpperCase(fn:substring(u.username,0,1))}</div>
                    <span class="fw-semibold">${u.username}</span>
                  </div>
                </td>
                <td class="small text-muted">${u.email}</td>
                <td><span class="badge rounded-pill ${u.roleName=='ADMIN'?'bg-danger':'bg-primary'}">${u.roleName}</span></td>
                <td><span class="badge rounded-pill ${u.active?'bg-success':'bg-secondary'}">${u.active?'Active':'Inactive'}</span></td>
                <td class="small text-muted">${u.createdAtFormatted}</td>
                <td class="px-4">
                  <div class="d-flex gap-1">
                    <a href="${pageContext.request.contextPath}/admin/user/toggle/${u.userId}"
                       class="btn btn-sm ${u.active?'btn-outline-warning':'btn-outline-success'} rounded-pill">
                      <i class="bi bi-${u.active?'pause':'play'}-circle"></i>
                    </a>
                    <c:if test="${u.roleName != 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/user/delete/${u.userId}"
                       class="btn btn-sm btn-outline-danger rounded-pill"
                       onclick="return confirm('Delete user ${u.username}?')">
                       <i class="bi bi-trash"></i>
                    </a>
                    </c:if>
                  </div>
                </td>
              </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
