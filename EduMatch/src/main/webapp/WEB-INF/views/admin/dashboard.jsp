<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Admin Dashboard – EduMatch</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .admin-sidebar{background:linear-gradient(180deg,#0d1b4b,#1a237e);min-height:calc(100vh - 62px);width:250px;flex-shrink:0;}
    .admin-sidebar .nav-link{color:rgba(255,255,255,.7);border-radius:10px;padding:10px 14px;margin:2px 8px;transition:.2s;}
    .admin-sidebar .nav-link:hover,.admin-sidebar .nav-link.active{background:rgba(255,255,255,.15);color:#fff;}
    .admin-sidebar .nav-link i{width:22px;}
    .stat-card{border:none;border-radius:16px;overflow:hidden;}
    .stat-icon{width:56px;height:56px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:1.5rem;}
    .section-title{font-family:'Playfair Display',serif;color:#1a237e;}
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<div class="d-flex">
  <!-- Admin Sidebar -->
  <div class="admin-sidebar py-4">
    <div class="px-4 mb-3">
      <span class="badge bg-warning text-dark small px-3 py-2 rounded-pill">
        <i class="bi bi-shield-check me-1"></i>Admin Panel
      </span>
    </div>
    <nav class="nav flex-column mt-2">
      <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/colleges"><i class="bi bi-building me-2"></i>Manage Colleges</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/programs"><i class="bi bi-book me-2"></i>Manage Programs</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-2"></i>Manage Users</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/applications"><i class="bi bi-file-earmark-check me-2"></i>Applications</a>
      <hr class="border-light opacity-25 mx-3">
      <a class="nav-link" href="${pageContext.request.contextPath}/colleges"><i class="bi bi-eye me-2"></i>View Site</a>
      <a class="nav-link text-danger-emphasis" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
    </nav>
  </div>

  <!-- Main -->
  <div class="flex-grow-1 p-4">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
      <div>
        <h4 class="fw-bold mb-1 section-title">Admin Dashboard</h4>
        <p class="text-muted small mb-0">EduMatch platform overview</p>
      </div>
      <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/admin/college/new" class="btn btn-primary rounded-pill btn-sm px-3">
          <i class="bi bi-plus-circle me-1"></i>Add College
        </a>
        <a href="${pageContext.request.contextPath}/admin/program/new" class="btn btn-success rounded-pill btn-sm px-3">
          <i class="bi bi-plus-circle me-1"></i>Add Program
        </a>
      </div>
    </div>

    <!-- Stats Grid -->
    <div class="row g-3 mb-4">
      <div class="col-6 col-md-3">
        <div class="card stat-card shadow-sm p-4" style="border-left:4px solid #1a237e!important;">
          <div class="d-flex align-items-center gap-3">
            <div class="stat-icon bg-primary bg-opacity-10 text-primary"><i class="bi bi-people"></i></div>
            <div>
              <div class="fs-2 fw-bold" style="color:#1a237e;">${totalStudents}</div>
              <div class="text-muted small">Students</div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card stat-card shadow-sm p-4" style="border-left:4px solid #43a047!important;">
          <div class="d-flex align-items-center gap-3">
            <div class="stat-icon bg-success bg-opacity-10 text-success"><i class="bi bi-building"></i></div>
            <div>
              <div class="fs-2 fw-bold text-success">${totalColleges}</div>
              <div class="text-muted small">Colleges</div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card stat-card shadow-sm p-4" style="border-left:4px solid #f57c00!important;">
          <div class="d-flex align-items-center gap-3">
            <div class="stat-icon bg-warning bg-opacity-10 text-warning"><i class="bi bi-book"></i></div>
            <div>
              <div class="fs-2 fw-bold text-warning">${totalPrograms}</div>
              <div class="text-muted small">Programs</div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card stat-card shadow-sm p-4" style="border-left:4px solid #e53935!important;">
          <div class="d-flex align-items-center gap-3">
            <div class="stat-icon bg-danger bg-opacity-10 text-danger"><i class="bi bi-file-earmark-text"></i></div>
            <div>
              <div class="fs-2 fw-bold text-danger">${totalApplications}</div>
              <div class="text-muted small">Applications</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="row g-4">
      <!-- Pending Applications -->
      <div class="col-lg-8">
        <div class="card border-0 shadow-sm rounded-4">
          <div class="card-body p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <h6 class="fw-bold section-title mb-0"><i class="bi bi-clock me-2"></i>Pending Applications</h6>
              <a href="${pageContext.request.contextPath}/admin/applications?status=Submitted"
                 class="btn btn-outline-primary btn-sm rounded-pill">View All</a>
            </div>
            <c:choose>
              <c:when test="${empty recentApps}">
                <div class="text-center py-4 text-muted">
                  <i class="bi bi-check-circle fs-1 d-block mb-2 text-success"></i>No pending applications!
                </div>
              </c:when>
              <c:otherwise>
                <div class="table-responsive">
                  <table class="table table-hover align-middle mb-0">
                    <thead class="table-light"><tr>
                      <th class="small">Student</th>
                      <th class="small">Program</th>
                      <th class="small">College</th>
                      <th class="small">Status</th>
                      <th class="small">Action</th>
                    </tr></thead>
                    <tbody>
                      <c:forEach var="app" items="${recentApps}" end="7">
                      <tr>
                        <td class="small fw-semibold">${app.fullName}</td>
                        <td class="small">${app.programName}</td>
                        <td class="small text-muted">${app.collegeName}</td>
                        <td><span class="badge bg-${app.statusBadgeClass} rounded-pill">${app.status}</span></td>
                        <td>
                          <a href="${pageContext.request.contextPath}/admin/application/view/${app.applicationId}"
                             class="btn btn-sm btn-outline-primary rounded-pill">Review</a>
                        </td>
                      </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- Quick Actions + Stats -->
      <div class="col-lg-4">
        <div class="card border-0 shadow-sm rounded-4 mb-3">
          <div class="card-body p-4">
            <h6 class="fw-bold section-title mb-3"><i class="bi bi-lightning me-2"></i>Quick Actions</h6>
            <div class="d-flex flex-column gap-2">
              <a href="${pageContext.request.contextPath}/admin/college/new" class="btn btn-outline-primary btn-sm rounded-pill text-start px-3">
                <i class="bi bi-plus-circle me-2"></i>Add New College
              </a>
              <a href="${pageContext.request.contextPath}/admin/program/new" class="btn btn-outline-success btn-sm rounded-pill text-start px-3">
                <i class="bi bi-plus-circle me-2"></i>Add New Program
              </a>
              <a href="${pageContext.request.contextPath}/admin/applications" class="btn btn-outline-warning btn-sm rounded-pill text-start px-3">
                <i class="bi bi-file-earmark-check me-2"></i>Review Applications
              </a>
              <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm rounded-pill text-start px-3">
                <i class="bi bi-people me-2"></i>Manage Users
              </a>
            </div>
          </div>
        </div>
        <div class="card border-0 shadow-sm rounded-4">
          <div class="card-body p-4">
            <h6 class="fw-bold section-title mb-3"><i class="bi bi-bar-chart me-2"></i>Application Stats</h6>
            <div class="d-flex justify-content-between py-2 border-bottom">
              <span class="small text-muted">Pending</span>
              <span class="badge bg-primary rounded-pill">${pendingApps}</span>
            </div>
            <div class="d-flex justify-content-between py-2">
              <span class="small text-muted">Accepted</span>
              <span class="badge bg-success rounded-pill">${acceptedApps}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
