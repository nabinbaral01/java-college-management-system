<%-- college/detail.jsp - public detail page for one college showing programs, facilities and contact info --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>${college.collegeName} – EduMatch</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .college-header{background:linear-gradient(135deg,#1a237e,#283593);color:#fff;padding:3rem 0;}
    .info-card{border:none;border-radius:16px;box-shadow:0 4px 20px rgba(0,0,0,.06);}
    .program-row{border-left:3px solid #3f51b5;padding-left:12px;}
    .facility-chip{background:#e3f2fd;color:#1565c0;border-radius:20px;padding:4px 12px;font-size:.78rem;}
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- Header Banner -->
<div class="college-header">
  <div class="container">
    <nav aria-label="breadcrumb" class="mb-3">
      <ol class="breadcrumb mb-0 small opacity-75">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/colleges" class="text-white">Colleges</a></li>
        <li class="breadcrumb-item active text-white">${college.collegeName}</li>
      </ol>
    </nav>
    <div class="d-flex align-items-center gap-4 flex-wrap">
      <div class="rounded-3 bg-white d-flex align-items-center justify-content-center text-primary fw-bold"
           style="width:80px;height:80px;font-size:1.6rem;flex-shrink:0;">
        ${fn:substring(college.collegeName,0,2)}
      </div>
      <div class="flex-grow-1">
        <h2 class="fw-bold mb-1" style="font-family:'Playfair Display',serif;">${college.collegeName}</h2>
        <div class="d-flex gap-3 flex-wrap opacity-85 small">
          <span><i class="bi bi-geo-alt me-1"></i>${college.districtName}, ${college.provinceName}</span>
          <span><i class="bi bi-building me-1"></i>${college.collegeType}</span>
          <span><i class="bi bi-link me-1"></i>${college.affiliation}</span>
          <c:if test="${college.establishmentYear > 0}">
            <span><i class="bi bi-calendar me-1"></i>Est. ${college.establishmentYear}</span>
          </c:if>
        </div>
      </div>
      <c:if test="${not empty sessionScope.loggedUser and sessionScope.role == 'STUDENT'}">
        <form action="${pageContext.request.contextPath}/student/saved" method="post">
          <input type="hidden" name="action" value="${isSaved ? 'unsave' : 'save'}">
          <input type="hidden" name="collegeId" value="${college.collegeId}">
          <input type="hidden" name="redirect" value="${pageContext.request.requestURI}">
          <button type="submit" class="btn ${isSaved ? 'btn-warning' : 'btn-outline-light'} rounded-pill px-4">
            <i class="bi bi-bookmark${isSaved ? '-fill' : ''} me-2"></i>${isSaved ? 'Saved' : 'Save College'}
          </button>
        </form>
      </c:if>
    </div>
  </div>
</div>

<div class="container py-4">
  <div class="row g-4">
    <!-- Left: Details -->
    <div class="col-lg-4">
      <div class="card info-card bg-white p-4 mb-3">
        <h6 class="fw-bold mb-3" style="color:#1a237e;"><i class="bi bi-info-circle me-2"></i>Contact Info</h6>
        <ul class="list-unstyled small mb-0">
          <c:if test="${not empty college.phone}">
            <li class="d-flex gap-2 mb-2"><i class="bi bi-telephone text-primary mt-1"></i><span>${college.phone}</span></li>
          </c:if>
          <c:if test="${not empty college.email}">
            <li class="d-flex gap-2 mb-2"><i class="bi bi-envelope text-primary mt-1"></i><span>${college.email}</span></li>
          </c:if>
          <c:if test="${not empty college.website}">
            <li class="d-flex gap-2 mb-2"><i class="bi bi-globe text-primary mt-1"></i>
              <a href="${college.website}" target="_blank" class="text-decoration-none">${college.website}</a>
            </li>
          </c:if>
          <c:if test="${not empty college.address}">
            <li class="d-flex gap-2"><i class="bi bi-map text-primary mt-1"></i><span>${college.address}</span></li>
          </c:if>
        </ul>
      </div>
      <c:if test="${not empty college.facilities}">
      <div class="card info-card bg-white p-4">
        <h6 class="fw-bold mb-3" style="color:#1a237e;"><i class="bi bi-check2-square me-2"></i>Facilities</h6>
        <div class="d-flex flex-wrap gap-2">
          <c:forEach var="fac" items="${college.facilities}">
            <span class="facility-chip">${fac}</span>
          </c:forEach>
        </div>
      </div>
      </c:if>
    </div>

    <!-- Right: Programs -->
    <div class="col-lg-8">
      <c:if test="${not empty college.description}">
      <div class="card info-card bg-white p-4 mb-4">
        <h6 class="fw-bold mb-2" style="color:#1a237e;"><i class="bi bi-file-text me-2"></i>About</h6>
        <p class="text-muted small mb-0">${college.description}</p>
      </div>
      </c:if>

      <div class="card info-card bg-white p-4">
        <h6 class="fw-bold mb-4" style="color:#1a237e;">
          <i class="bi bi-book me-2"></i>Programs Offered
          <span class="badge bg-primary ms-2">${college.programs.size()}</span>
        </h6>
        <c:choose>
          <c:when test="${empty college.programs}">
            <p class="text-muted small">No programs listed yet.</p>
          </c:when>
          <c:otherwise>
            <div class="d-flex flex-column gap-3">
              <c:forEach var="prog" items="${college.programs}">
              <div class="program-row">
                <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                  <div>
                    <div class="fw-semibold">${prog.programName}</div>
                    <div class="small text-muted">
                      ${prog.facultyName} &bull;
                      ${prog.durationYears} yrs &bull;
                      <c:if test="${prog.totalSeats > 0}">${prog.totalSeats} seats</c:if>
                    </div>
                    <c:if test="${prog.entranceRequired}">
                      <span class="badge small" style="background:#e65100;color:#fff;">Entrance: ${prog.entranceName}</span>
                    </c:if>
                    <c:if test="${prog.minPercentage > 0}">
                      <span class="badge bg-light text-dark border small">Min. ${prog.minPercentage}%</span>
                    </c:if>
                  </div>
                  <div class="text-end">
                    <div class="fw-semibold text-primary small">${prog.formattedFee}</div>
                    <span class="badge bg-light text-dark border">${prog.degreeLevel}</span>
                    <c:if test="${not empty sessionScope.loggedUser and sessionScope.role == 'STUDENT'}">
                      <form action="${pageContext.request.contextPath}/student/applications" method="post" class="d-inline ms-1">
                        <input type="hidden" name="programId" value="${prog.programId}">
                        <button type="submit" class="btn btn-sm btn-success rounded-pill px-3"
                                onclick="return confirm('Apply to ${prog.programName}?')">Apply</button>
                      </form>
                    </c:if>
                  </div>
                </div>
              </div>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
