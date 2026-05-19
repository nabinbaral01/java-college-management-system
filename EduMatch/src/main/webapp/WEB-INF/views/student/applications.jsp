<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>My Applications – EduMatch</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .sidebar{background:linear-gradient(180deg,#1a237e,#283593);min-height:calc(100vh - 62px);width:240px;flex-shrink:0;}
    .sidebar .nav-link{color:rgba(255,255,255,.75);border-radius:10px;padding:10px 14px;margin:2px 8px;transition:.2s;}
    .sidebar .nav-link:hover,.sidebar .nav-link.active{background:rgba(255,255,255,.15);color:#fff;}
    .sidebar .nav-link i{width:22px;}
    .app-card{border:none;border-radius:16px;transition:box-shadow .2s;}
    .app-card:hover{box-shadow:0 8px 24px rgba(0,0,0,.1)!important;}
    .timeline-dot{width:12px;height:12px;border-radius:50%;flex-shrink:0;margin-top:4px;}
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<div class="d-flex">
  <div class="sidebar py-4">
    <div class="px-4 mb-4"><div class="text-white opacity-50 small text-uppercase fw-semibold" style="letter-spacing:1px;">Student Menu</div></div>
    <nav class="nav flex-column">
      <a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard"><i class="bi bi-house me-2"></i>Dashboard</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person me-2"></i>My Profile</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/academic"><i class="bi bi-journal-text me-2"></i>Academic Records</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/match"><i class="bi bi-stars me-2"></i>College Match</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/colleges"><i class="bi bi-building me-2"></i>Browse Colleges</a>
      <a class="nav-link active" href="${pageContext.request.contextPath}/student/applications"><i class="bi bi-file-earmark-text me-2"></i>Applications</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/saved"><i class="bi bi-bookmark me-2"></i>Saved Colleges</a>
      <hr class="border-light opacity-25 mx-3">
      <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
    </nav>
  </div>

  <div class="flex-grow-1 p-4">
    <div class="mb-4">
      <h4 class="fw-bold" style="font-family:'Playfair Display',serif;color:#1a237e;">
        <i class="bi bi-file-earmark-text me-2"></i>My Applications
      </h4>
      <p class="text-muted">Track the status of all your college program applications.</p>
    </div>

    <c:choose>
      <c:when test="${empty applications}">
        <div class="text-center py-5 bg-white rounded-4 shadow-sm">
          <div class="fs-1 mb-3">📋</div>
          <h5 class="text-muted">No applications yet</h5>
          <p class="text-muted small">Use the College Match feature to find eligible programs and apply!</p>
          <a href="${pageContext.request.contextPath}/student/match" class="btn btn-primary rounded-pill px-4">
            <i class="bi bi-stars me-2"></i>Find My Match
          </a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="d-flex flex-column gap-3">
          <c:forEach var="app" items="${applications}">
          <div class="card app-card shadow-sm p-4">
            <div class="row align-items-center g-3">
              <div class="col-md-5">
                <div class="fw-bold mb-1">${app.programName}
                  <span class="badge bg-light text-dark border ms-1 small">${app.degreeLevel}</span>
                </div>
                <div class="text-muted small"><i class="bi bi-building me-1"></i>${app.collegeName}</div>
                <div class="text-muted small"><i class="bi bi-bookmark me-1"></i>${app.facultyName}</div>
              </div>
              <div class="col-md-3 text-md-center">
                <span class="badge bg-${app.statusBadgeClass} rounded-pill px-3 py-2 fs-6">${app.status}</span>
              </div>
              <div class="col-md-2 text-md-center">
                <div class="small text-muted">Applied</div>
                <div class="small fw-semibold">
                  ${app.appliedDateFormatted}
                </div>
              </div>
              <div class="col-md-2 text-md-end">
                <c:if test="${app.status == 'Submitted' or app.status == 'Draft'}">
                  <a href="${pageContext.request.contextPath}/student/applications/withdraw/${app.applicationId}"
                     class="btn btn-outline-danger btn-sm rounded-pill"
                     onclick="return confirm('Withdraw this application?')">
                    Withdraw
                  </a>
                </c:if>
                <c:if test="${not empty app.adminNotes}">
                  <button class="btn btn-outline-info btn-sm rounded-pill"
                          data-bs-toggle="tooltip" title="${app.adminNotes}">
                    <i class="bi bi-info-circle"></i>
                  </button>
                </c:if>
              </div>
            </div>
            <c:if test="${not empty app.adminNotes}">
            <div class="mt-3 pt-3 border-top">
              <div class="small text-muted"><i class="bi bi-chat-left-text me-2"></i><strong>Admin Note:</strong> ${app.adminNotes}</div>
            </div>
            </c:if>
          </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => new bootstrap.Tooltip(el));
</script>
</body>
</html>
