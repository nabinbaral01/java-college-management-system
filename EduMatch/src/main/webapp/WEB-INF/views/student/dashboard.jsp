<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Dashboard – EduMatch</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .sidebar{background:linear-gradient(180deg,#1a237e,#283593);min-height:calc(100vh - 62px);width:240px;flex-shrink:0;}
    .sidebar .nav-link{color:rgba(255,255,255,.75);border-radius:10px;padding:10px 14px;margin:2px 8px;transition:.2s;}
    .sidebar .nav-link:hover,.sidebar .nav-link.active{background:rgba(255,255,255,.15);color:#fff;}
    .sidebar .nav-link i{width:22px;}
    .stat-card{border:none;border-radius:16px;transition:transform .2s;}
    .stat-card:hover{transform:translateY(-2px);}
    .app-badge{font-size:.7rem;padding:4px 10px;border-radius:20px;}
    .section-title{font-family:'Playfair Display',serif;color:#1a237e;}
    .quick-action{border:2px solid #e8eaf6;border-radius:16px;transition:.2s;text-decoration:none;color:inherit;}
    .quick-action:hover{border-color:#3f51b5;background:#f8f9ff;transform:translateY(-2px);}
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="d-flex">
  <!-- Sidebar -->
  <div class="sidebar py-4">
    <div class="px-4 mb-4">
      <div class="text-white opacity-50 small text-uppercase fw-semibold" style="letter-spacing:1px;">Student Menu</div>
    </div>
    <nav class="nav flex-column">
      <a class="nav-link active" href="${pageContext.request.contextPath}/student/dashboard"><i class="bi bi-house me-2"></i>Dashboard</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person me-2"></i>My Profile</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/academic"><i class="bi bi-journal-text me-2"></i>Academic Records</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/match"><i class="bi bi-stars me-2"></i>College Match</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/colleges"><i class="bi bi-building me-2"></i>Browse Colleges</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/applications"><i class="bi bi-file-earmark-text me-2"></i>Applications</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/saved"><i class="bi bi-bookmark me-2"></i>Saved Colleges</a>
      <hr class="border-light opacity-25 mx-3">
      <a class="nav-link text-danger-emphasis" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
    </nav>
  </div>

  <!-- Main Content -->
  <div class="flex-grow-1 p-4">
    <!-- Welcome Banner -->
    <div class="rounded-3 p-4 mb-4 text-white" style="background:linear-gradient(135deg,#1a237e,#3f51b5);">
      <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
        <div>
          <h4 class="fw-bold mb-1">
            Welcome back, <c:choose>
              <c:when test="${not empty profile}">${profile.fullName}</c:when>
              <c:otherwise>${sessionScope.username}</c:otherwise>
            </c:choose>! 👋
          </h4>
          <p class="mb-0 opacity-75">Your college journey dashboard</p>
        </div>
        <a href="${pageContext.request.contextPath}/student/match" class="btn btn-warning fw-semibold px-4 rounded-pill">
          <i class="bi bi-stars me-2"></i>Find My Match
        </a>
      </div>
    </div>

    <!-- Stats Row -->
    <div class="row g-3 mb-4">
      <div class="col-6 col-md-3">
        <div class="card stat-card shadow-sm h-100 border-0">
          <div class="card-body p-3 text-center">
            <div class="fs-1 mb-1 text-primary"><i class="bi bi-file-earmark-text"></i></div>
            <div class="fs-3 fw-bold" style="color:#1a237e;">${appCount}</div>
            <div class="small text-muted">Applications</div>
          </div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card stat-card shadow-sm h-100 border-0">
          <div class="card-body p-3 text-center">
            <div class="fs-1 mb-1 text-success"><i class="bi bi-check-circle"></i></div>
            <div class="fs-3 fw-bold text-success">${acceptedCount}</div>
            <div class="small text-muted">Accepted</div>
          </div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card stat-card shadow-sm h-100 border-0">
          <div class="card-body p-3 text-center">
            <div class="fs-1 mb-1 text-warning"><i class="bi bi-hourglass-split"></i></div>
            <div class="fs-3 fw-bold text-warning">${pendingCount}</div>
            <div class="small text-muted">Pending</div>
          </div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card stat-card shadow-sm h-100 border-0">
          <div class="card-body p-3 text-center">
            <div class="fs-1 mb-1 text-danger"><i class="bi bi-bookmark-heart"></i></div>
            <div class="fs-3 fw-bold text-danger">${savedCount}</div>
            <div class="small text-muted">Saved</div>
          </div>
        </div>
      </div>
    </div>

    <div class="row g-4">
      <!-- Profile completeness -->
      <div class="col-lg-4">
        <div class="card border-0 shadow-sm rounded-4 h-100">
          <div class="card-body p-4">
            <h6 class="fw-bold section-title mb-3"><i class="bi bi-person-check me-2"></i>Profile Status</h6>
            <c:choose>
              <c:when test="${not empty profile}">
                <div class="text-center mb-3">
                  <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center mx-auto mb-2 fw-bold fs-3 text-primary"
                       style="width:72px;height:72px;">
                    ${fn:substring(profile.fullName,0,1)}
                  </div>
                  <div class="fw-semibold">${profile.fullName}</div>
                  <div class="text-muted small">${profile.email}</div>
                </div>
                <ul class="list-unstyled small">
                  <li class="d-flex justify-content-between py-1 border-bottom">
                    <span class="text-muted">Province</span>
                    <span class="fw-semibold">${not empty profile.province ? profile.province : '—'}</span>
                  </li>
                  <li class="d-flex justify-content-between py-1 border-bottom">
                    <span class="text-muted">Phone</span>
                    <span class="fw-semibold">${not empty profile.phone ? profile.phone : '—'}</span>
                  </li>
                  <li class="d-flex justify-content-between py-1">
                    <span class="text-muted">Academic Records</span>
                    <span class="fw-semibold">${records.size()} added</span>
                  </li>
                </ul>
              </c:when>
              <c:otherwise>
                <div class="text-center py-3">
                  <div class="fs-1 text-muted mb-2">👤</div>
                  <p class="text-muted small">Complete your profile to get better matches</p>
                </div>
              </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/student/profile" class="btn btn-outline-primary rounded-pill w-100 mt-2 btn-sm">
              Edit Profile
            </a>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="col-lg-4">
        <div class="card border-0 shadow-sm rounded-4 h-100">
          <div class="card-body p-4">
            <h6 class="fw-bold section-title mb-3"><i class="bi bi-lightning me-2"></i>Quick Actions</h6>
            <div class="d-flex flex-column gap-2">
              <a href="${pageContext.request.contextPath}/student/match" class="quick-action d-flex align-items-center gap-3 p-3">
                <div class="rounded-2 bg-primary bg-opacity-10 p-2 text-primary"><i class="bi bi-stars fs-5"></i></div>
                <div><div class="fw-semibold small">Find College Match</div><div class="text-muted" style="font-size:.75rem;">Based on your grades</div></div>
                <i class="bi bi-chevron-right ms-auto text-muted"></i>
              </a>
              <a href="${pageContext.request.contextPath}/student/academic" class="quick-action d-flex align-items-center gap-3 p-3">
                <div class="rounded-2 bg-success bg-opacity-10 p-2 text-success"><i class="bi bi-journal-text fs-5"></i></div>
                <div><div class="fw-semibold small">Add Academic Records</div><div class="text-muted" style="font-size:.75rem;">SEE, +2 results</div></div>
                <i class="bi bi-chevron-right ms-auto text-muted"></i>
              </a>
              <a href="${pageContext.request.contextPath}/colleges" class="quick-action d-flex align-items-center gap-3 p-3">
                <div class="rounded-2 bg-warning bg-opacity-10 p-2 text-warning"><i class="bi bi-building fs-5"></i></div>
                <div><div class="fw-semibold small">Browse All Colleges</div><div class="text-muted" style="font-size:.75rem;">Explore & compare</div></div>
                <i class="bi bi-chevron-right ms-auto text-muted"></i>
              </a>
              <a href="${pageContext.request.contextPath}/student/applications" class="quick-action d-flex align-items-center gap-3 p-3">
                <div class="rounded-2 bg-info bg-opacity-10 p-2 text-info"><i class="bi bi-clipboard-check fs-5"></i></div>
                <div><div class="fw-semibold small">Track Applications</div><div class="text-muted" style="font-size:.75rem;">Status updates</div></div>
                <i class="bi bi-chevron-right ms-auto text-muted"></i>
              </a>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Applications -->
      <div class="col-lg-4">
        <div class="card border-0 shadow-sm rounded-4 h-100">
          <div class="card-body p-4">
            <h6 class="fw-bold section-title mb-3"><i class="bi bi-clock-history me-2"></i>Recent Applications</h6>
            <c:choose>
              <c:when test="${empty applications}">
                <div class="text-center py-4">
                  <div class="fs-1 mb-2 text-muted">📋</div>
                  <p class="text-muted small">No applications yet.<br>Use College Match to find programs!</p>
                  <a href="${pageContext.request.contextPath}/student/match" class="btn btn-sm btn-primary rounded-pill">Start Matching</a>
                </div>
              </c:when>
              <c:otherwise>
                <div class="d-flex flex-column gap-2">
                  <c:forEach var="app" items="${applications}" end="4">
                    <div class="d-flex align-items-start gap-2 p-2 rounded-3 bg-light">
                      <div class="flex-grow-1">
                        <div class="fw-semibold small lh-sm">${app.programName}</div>
                        <div class="text-muted" style="font-size:.72rem;">${app.collegeName}</div>
                      </div>
                      <span class="badge app-badge bg-${app.statusBadgeClass}">${app.status}</span>
                    </div>
                  </c:forEach>
                </div>
                <a href="${pageContext.request.contextPath}/student/applications" class="btn btn-outline-primary btn-sm rounded-pill w-100 mt-3">
                  View All
                </a>
              </c:otherwise>
            </c:choose>
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
