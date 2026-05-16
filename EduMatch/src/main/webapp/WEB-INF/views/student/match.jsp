<%-- student/match.jsp - eligibility-matched program results based on student's +2 percentage and chosen faculty / province --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>College Match – EduMatch</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .sidebar{background:linear-gradient(180deg,#1a237e,#283593);min-height:calc(100vh - 62px);width:240px;flex-shrink:0;}
    .sidebar .nav-link{color:rgba(255,255,255,.75);border-radius:10px;padding:10px 14px;margin:2px 8px;transition:.2s;}
    .sidebar .nav-link:hover,.sidebar .nav-link.active{background:rgba(255,255,255,.15);color:#fff;}
    .sidebar .nav-link i{width:22px;}
    .filter-card{border:none;border-radius:16px;background:#fff;box-shadow:0 4px 20px rgba(0,0,0,.06);}
    .match-card{border:none;border-radius:16px;transition:transform .2s,box-shadow .2s;}
    .match-card:hover{transform:translateY(-3px);box-shadow:0 12px 32px rgba(0,0,0,.1)!important;}
    .eligible-badge{background:#e8f5e9;color:#2e7d32;border-radius:20px;padding:4px 12px;font-size:.78rem;font-weight:600;}
    .ineligible-badge{background:#ffebee;color:#c62828;border-radius:20px;padding:4px 12px;font-size:.78rem;font-weight:600;}
    .fee-tag{background:#e3f2fd;color:#1565c0;border-radius:20px;padding:3px 10px;font-size:.75rem;}
    .select2{border-radius:10px!important;border:2px solid #e8eaf6!important;}
    .select2:focus{border-color:#3f51b5!important;box-shadow:none!important;}
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
      <a class="nav-link active" href="${pageContext.request.contextPath}/student/match"><i class="bi bi-stars me-2"></i>College Match</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/colleges"><i class="bi bi-building me-2"></i>Browse Colleges</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/applications"><i class="bi bi-file-earmark-text me-2"></i>Applications</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/saved"><i class="bi bi-bookmark me-2"></i>Saved Colleges</a>
      <hr class="border-light opacity-25 mx-3">
      <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
    </nav>
  </div>

  <div class="flex-grow-1 p-4">
    <div class="mb-4">
      <h4 class="fw-bold" style="font-family:'Playfair Display',serif;color:#1a237e;">
        <i class="bi bi-stars me-2 text-warning"></i>College Eligibility Match
      </h4>
      <p class="text-muted">Programs matched against your academic records. Green = eligible based on your +2 results.</p>
    </div>

    <!-- Filters -->
    <div class="filter-card p-4 mb-4">
      <form action="${pageContext.request.contextPath}/student/match" method="get" class="row g-3 align-items-end">
        <div class="col-md-4">
          <label class="form-label small fw-semibold text-muted">Faculty / Stream</label>
          <select name="faculty" class="form-select select2">
            <option value="">All Faculties</option>
            <option value="1" ${selFaculty=='1'?'selected':''}>Science & Technology</option>
            <option value="2" ${selFaculty=='2'?'selected':''}>Management</option>
            <option value="3" ${selFaculty=='3'?'selected':''}>Humanities & Social Sciences</option>
            <option value="4" ${selFaculty=='4'?'selected':''}>Medical & Health Sciences</option>
            <option value="5" ${selFaculty=='5'?'selected':''}>Law</option>
            <option value="6" ${selFaculty=='6'?'selected':''}>Education</option>
            <option value="7" ${selFaculty=='7'?'selected':''}>Agriculture</option>
          </select>
        </div>
        <div class="col-md-4">
          <label class="form-label small fw-semibold text-muted">Province</label>
          <select name="province" class="form-select select2">
            <option value="">All Provinces</option>
            <option value="Koshi Province"         ${selProvince=='Koshi Province'?'selected':''}>Koshi Province</option>
            <option value="Madhesh Province"        ${selProvince=='Madhesh Province'?'selected':''}>Madhesh Province</option>
            <option value="Bagmati Province"        ${selProvince=='Bagmati Province'?'selected':''}>Bagmati Province</option>
            <option value="Gandaki Province"        ${selProvince=='Gandaki Province'?'selected':''}>Gandaki Province</option>
            <option value="Lumbini Province"        ${selProvince=='Lumbini Province'?'selected':''}>Lumbini Province</option>
            <option value="Karnali Province"        ${selProvince=='Karnali Province'?'selected':''}>Karnali Province</option>
            <option value="Sudurpashchim Province"  ${selProvince=='Sudurpashchim Province'?'selected':''}>Sudurpashchim Province</option>
          </select>
        </div>
        <div class="col-md-4 d-flex gap-2">
          <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold flex-grow-1">
            <i class="bi bi-funnel me-2"></i>Filter
          </button>
          <a href="${pageContext.request.contextPath}/student/match" class="btn btn-outline-secondary rounded-pill px-3">Reset</a>
        </div>
      </form>
    </div>

    <!-- Match Summary -->
    <c:if test="${not empty matches}">
    <div class="row g-3 mb-4">
      <div class="col-6 col-md-3">
        <div class="card border-0 bg-success bg-opacity-10 rounded-3 p-3 text-center">
          <div class="fs-2 fw-bold text-success">${eligible}</div>
          <div class="small text-success">✅ Eligible Programs</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card border-0 bg-danger bg-opacity-10 rounded-3 p-3 text-center">
          <div class="fs-2 fw-bold text-danger">${ineligible}</div>
          <div class="small text-danger">❌ Not Eligible</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card border-0 bg-primary bg-opacity-10 rounded-3 p-3 text-center">
          <div class="fs-2 fw-bold text-primary">${matches.size()}</div>
          <div class="small text-primary">📋 Total Programs</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card border-0 bg-warning bg-opacity-10 rounded-3 p-3 text-center">
          <div class="fs-2 fw-bold text-warning">🎯</div>
          <div class="small text-warning fw-semibold">Match Results</div>
        </div>
      </div>
    </div>
    </c:if>

    <!-- Error / Empty states -->
    <c:if test="${not empty matchError}">
      <div class="alert alert-warning rounded-3">
        <i class="bi bi-exclamation-triangle me-2"></i>${matchError}
        <a href="${pageContext.request.contextPath}/student/academic" class="alert-link ms-2">Add Academic Records →</a>
      </div>
    </c:if>

    <!-- Results Grid -->
    <c:choose>
      <c:when test="${empty matches and empty matchError}">
        <div class="text-center py-5">
          <div class="fs-1 mb-3">🔍</div>
          <h5 class="text-muted">No programs found for the selected filters</h5>
          <a href="${pageContext.request.contextPath}/student/match" class="btn btn-outline-primary rounded-pill mt-3">Clear Filters</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="row g-3">
          <c:forEach var="p" items="${matches}">
          <div class="col-md-6 col-xl-4">
            <div class="card match-card shadow-sm h-100 ${p.eligible ? 'border-success border-opacity-50' : 'border-danger border-opacity-25'}">
              <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-start mb-2">
                  <span class="${p.eligible ? 'eligible-badge' : 'ineligible-badge'}">
                    ${p.eligible ? '✅ Eligible' : '❌ Not Eligible'}
                  </span>
                  <span class="fee-tag">${p.formattedFee}</span>
                </div>
                <h6 class="fw-bold mb-1 mt-2">${p.programName}</h6>
                <div class="text-muted small mb-1"><i class="bi bi-building me-1"></i>${p.collegeName}</div>
                <div class="small text-muted mb-2">
                  <i class="bi bi-geo-alt me-1"></i>${p.districtName} &bull;
                  <i class="bi bi-mortarboard me-1"></i>${p.facultyName}
                </div>
                <div class="d-flex flex-wrap gap-1 mb-3">
                  <span class="badge bg-light text-dark border">${p.degreeLevel}</span>
                  <span class="badge bg-light text-dark border">${p.durationYears} yrs</span>
                  <c:if test="${p.entranceRequired}">
                    <span class="badge bg-orange text-white" style="background:#e65100!important;">Entrance Req.</span>
                  </c:if>
                </div>
                <c:if test="${p.minPercentage > 0}">
                  <div class="small text-muted mb-3">
                    <i class="bi bi-bar-chart me-1"></i>Min. percentage required: <strong>${p.minPercentage}%</strong>
                  </div>
                </c:if>
                <div class="d-flex gap-2">
                  <a href="${pageContext.request.contextPath}/college/${p.collegeId}"
                     class="btn btn-sm btn-outline-primary rounded-pill flex-grow-1">Details</a>
                  <c:if test="${p.eligible}">
                    <form action="${pageContext.request.contextPath}/student/applications" method="post" class="d-inline">
                      <input type="hidden" name="programId" value="${p.programId}">
                      <button type="submit" class="btn btn-sm btn-success rounded-pill px-3"
                              onclick="return confirm('Apply to ${p.programName} at ${p.collegeName}?')">
                        Apply
                      </button>
                    </form>
                  </c:if>
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
