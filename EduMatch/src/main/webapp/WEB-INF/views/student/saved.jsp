<%-- student/saved.jsp - student's list of bookmarked colleges with quick view and unsave actions --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Saved Colleges – EduMatch</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .sidebar{background:linear-gradient(180deg,#1a237e,#283593);min-height:calc(100vh - 62px);width:240px;flex-shrink:0;}
    .sidebar .nav-link{color:rgba(255,255,255,.75);border-radius:10px;padding:10px 14px;margin:2px 8px;transition:.2s;}
    .sidebar .nav-link:hover,.sidebar .nav-link.active{background:rgba(255,255,255,.15);color:#fff;}
    .sidebar .nav-link i{width:22px;}
    .college-card{border:none;border-radius:16px;transition:transform .2s,box-shadow .2s;}
    .college-card:hover{transform:translateY(-3px);box-shadow:0 12px 30px rgba(0,0,0,.1)!important;}
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
      <a class="nav-link" href="${pageContext.request.contextPath}/student/applications"><i class="bi bi-file-earmark-text me-2"></i>Applications</a>
      <a class="nav-link active" href="${pageContext.request.contextPath}/student/saved"><i class="bi bi-bookmark me-2"></i>Saved Colleges</a>
      <hr class="border-light opacity-25 mx-3">
      <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
    </nav>
  </div>

  <div class="flex-grow-1 p-4">
    <h4 class="fw-bold mb-4" style="font-family:'Playfair Display',serif;color:#1a237e;">
      <i class="bi bi-bookmark-heart me-2"></i>Saved Colleges
      <span class="badge bg-primary ms-2 fs-6">${savedColleges.size()}</span>
    </h4>

    <c:choose>
      <c:when test="${empty savedColleges}">
        <div class="text-center py-5 bg-white rounded-4 shadow-sm">
          <div class="fs-1 mb-3">🔖</div>
          <h5 class="text-muted">No saved colleges yet</h5>
          <p class="text-muted small">Browse colleges and click the bookmark icon to save them here.</p>
          <a href="${pageContext.request.contextPath}/colleges" class="btn btn-primary rounded-pill px-4">
            <i class="bi bi-building me-2"></i>Browse Colleges
          </a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="row g-3">
          <c:forEach var="col" items="${savedColleges}">
          <div class="col-md-6 col-lg-4">
            <div class="card college-card shadow-sm h-100">
              <div class="card-body p-4">
                <div class="d-flex align-items-start gap-3 mb-3">
                  <div class="rounded-2 bg-primary bg-opacity-10 d-flex align-items-center justify-content-center text-primary fw-bold flex-shrink-0"
                       style="width:52px;height:52px;font-size:1.1rem;">
                    ${fn:substring(col.collegeName,0,2)}
                  </div>
                  <div>
                    <h6 class="fw-bold mb-1 lh-sm">${col.collegeName}</h6>
                    <span class="badge rounded-pill small ${col.collegeType=='Government'?'bg-success':'bg-primary'}">${col.collegeType}</span>
                  </div>
                </div>
                <div class="small text-muted mb-1"><i class="bi bi-geo-alt me-1"></i>${col.districtName}, ${col.provinceName}</div>
                <div class="small text-muted mb-3"><i class="bi bi-book me-1"></i>${col.totalPrograms} programs</div>
                <div class="d-flex gap-2">
                  <a href="${pageContext.request.contextPath}/college/${col.collegeId}" class="btn btn-sm btn-outline-primary rounded-pill flex-grow-1">View</a>
                  <form action="${pageContext.request.contextPath}/student/saved" method="post" class="d-inline">
                    <input type="hidden" name="action" value="unsave">
                    <input type="hidden" name="collegeId" value="${col.collegeId}">
                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill"
                            onclick="return confirm('Remove from saved?')">
                      <i class="bi bi-bookmark-x"></i>
                    </button>
                  </form>
                </div>
              </div>
            </div>
          </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
