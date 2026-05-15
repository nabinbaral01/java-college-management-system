<%-- college/list.jsp - public college browse / search page with name, type and province filters --%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Browse Colleges – EduMatch Nepal</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .page-header{background:linear-gradient(135deg,#1a237e,#283593);color:#fff;padding:3rem 0;}
    .filter-card{border:none;border-radius:16px;box-shadow:0 4px 20px rgba(0,0,0,.06);}
    .college-card{border:none;border-radius:16px;transition:transform .2s,box-shadow .2s;}
    .college-card:hover{transform:translateY(-4px);box-shadow:0 12px 32px rgba(0,0,0,.1)!important;}
    .form-control,.form-select{border-radius:10px;border:2px solid #e8eaf6;}
    .form-control:focus,.form-select:focus{border-color:#3f51b5;box-shadow:none;}
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="page-header">
  <div class="container">
    <h2 class="fw-bold mb-1" style="font-family:'Playfair Display',serif;">Browse Colleges</h2>
    <p class="mb-0 opacity-75">Explore colleges and universities across all 7 provinces of Nepal</p>
  </div>
</div>

<div class="container py-4">
  <!-- Filters -->
  <div class="filter-card bg-white p-4 mb-4">
    <form action="${pageContext.request.contextPath}/colleges" method="get" class="row g-3 align-items-end">
      <div class="col-md-4">
        <label class="form-label small fw-semibold text-muted">Search</label>
        <input type="text" name="q" class="form-control" value="${searchQuery}" placeholder="College name, affiliation…">
      </div>
      <div class="col-md-3">
        <label class="form-label small fw-semibold text-muted">Type</label>
        <select name="type" class="form-select">
          <option value="">All Types</option>
          <option value="Government" ${selType=='Government'?'selected':''}>Government</option>
          <option value="Private"    ${selType=='Private'?'selected':''}>Private</option>
          <option value="Community"  ${selType=='Community'?'selected':''}>Community</option>
          <option value="Constituent"${selType=='Constituent'?'selected':''}>Constituent</option>
        </select>
      </div>
      <div class="col-md-3">
        <label class="form-label small fw-semibold text-muted">Province</label>
        <select name="province" class="form-select">
          <option value="">All Provinces</option>
          <c:forEach var="pv" items="${['Koshi Province','Madhesh Province','Bagmati Province','Gandaki Province','Lumbini Province','Karnali Province','Sudurpashchim Province']}">
            <option value="${pv}" ${selProvince==pv?'selected':''}>${pv}</option>
          </c:forEach>
        </select>
      </div>
      <div class="col-md-2 d-flex gap-2">
        <button type="submit" class="btn btn-primary rounded-pill flex-grow-1">Filter</button>
        <a href="${pageContext.request.contextPath}/colleges" class="btn btn-outline-secondary rounded-pill px-3">✕</a>
      </div>
    </form>
  </div>

  <!-- Results count -->
  <div class="d-flex justify-content-between align-items-center mb-3">
    <p class="text-muted mb-0 small">
      <strong>${colleges.size()}</strong> college${colleges.size()!=1?'s':''} found
    </p>
  </div>

  <!-- Grid -->
  <c:choose>
    <c:when test="${empty colleges}">
      <div class="text-center py-5 bg-white rounded-4 shadow-sm">
        <div class="fs-1 mb-3">🔍</div>
        <h5 class="text-muted">No colleges match your search</h5>
        <a href="${pageContext.request.contextPath}/colleges" class="btn btn-outline-primary rounded-pill mt-3">Clear Filters</a>
      </div>
    </c:when>
    <c:otherwise>
      <div class="row g-4">
        <c:forEach var="col" items="${colleges}">
        <div class="col-md-6 col-lg-4">
          <div class="card college-card shadow-sm h-100">
            <div class="card-body p-4">
              <div class="d-flex align-items-start gap-3 mb-3">
                <div class="rounded-3 bg-primary bg-opacity-10 text-primary d-flex align-items-center justify-content-center fw-bold flex-shrink-0"
                     style="width:56px;height:56px;font-size:1.1rem;">
                  ${fn:substring(col.collegeName,0,2)}
                </div>
                <div>
                  <h6 class="fw-bold mb-1 lh-sm">${col.collegeName}</h6>
                  <div>
                    <span class="badge rounded-pill me-1 ${col.collegeType=='Government'?'bg-success':'bg-primary'} small">${col.collegeType}</span>
                    <c:if test="${col.establishmentYear > 0}">
                      <span class="text-muted" style="font-size:.72rem;">Est. ${col.establishmentYear}</span>
                    </c:if>
                  </div>
                </div>
              </div>
              <div class="mb-2 small text-muted">
                <i class="bi bi-geo-alt me-1"></i>${col.districtName}, ${col.provinceName}
              </div>
              <div class="mb-2 small text-muted">
                <i class="bi bi-link me-1"></i>${col.affiliation}
              </div>
              <div class="d-flex gap-3 small mb-3">
                <span class="text-primary fw-semibold"><i class="bi bi-book me-1"></i>${col.totalPrograms} programs</span>
                <c:if test="${col.minFee > 0}">
                  <span class="text-muted"><i class="bi bi-currency-rupee me-1"></i>${col.formattedFeeRange}</span>
                </c:if>
              </div>
            </div>
            <div class="card-footer bg-transparent border-0 px-4 pb-3 d-flex gap-2">
              <a href="${pageContext.request.contextPath}/college/${col.collegeId}"
                 class="btn btn-sm btn-outline-primary rounded-pill flex-grow-1">View Details</a>
              <c:if test="${not empty sessionScope.loggedUser and sessionScope.role == 'STUDENT'}">
                <form action="${pageContext.request.contextPath}/student/saved" method="post">
                  <input type="hidden" name="action" value="save">
                  <input type="hidden" name="collegeId" value="${col.collegeId}">
                  <input type="hidden" name="redirect" value="${pageContext.request.requestURI}">
                  <button type="submit" class="btn btn-sm btn-outline-warning rounded-pill" title="Save">
                    <i class="bi bi-bookmark-plus"></i>
                  </button>
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

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
