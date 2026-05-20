<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Admin college view: displays detailed college information and associated programs --%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>College Details – Admin</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .admin-sidebar{background:linear-gradient(180deg,#0d1b4b,#1a237e);min-height:calc(100vh - 62px);width:250px;flex-shrink:0;}
    .admin-sidebar .nav-link{color:rgba(255,255,255,.7);border-radius:10px;padding:10px 14px;margin:2px 8px;transition:.2s;}
    .admin-sidebar .nav-link:hover,.admin-sidebar .nav-link.active{background:rgba(255,255,255,.15);color:#fff;}
    dt{color:#6c757d;font-weight:400;font-size:.88rem;}
    dd{font-weight:600;}
    .facility-chip{background:#e3f2fd;color:#1565c0;border-radius:20px;padding:3px 11px;font-size:.78rem;}
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<div class="d-flex">
  <div class="admin-sidebar py-4">
    <div class="px-4 mb-3"><span class="badge bg-warning text-dark small px-3 py-2 rounded-pill"><i class="bi bi-shield-check me-1"></i>Admin Panel</span></div>
    <nav class="nav flex-column mt-2">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
      <a class="nav-link active" href="${pageContext.request.contextPath}/admin/colleges"><i class="bi bi-building me-2"></i>Manage Colleges</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/programs"><i class="bi bi-book me-2"></i>Manage Programs</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-2"></i>Manage Users</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/applications"><i class="bi bi-file-earmark-check me-2"></i>Applications</a>
      <hr class="border-light opacity-25 mx-3">
      <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
    </nav>
  </div>

  <div class="flex-grow-1 p-4">
    <div class="d-flex align-items-center gap-3 mb-4 flex-wrap">
      <a href="${pageContext.request.contextPath}/admin/colleges" class="btn btn-outline-secondary rounded-pill btn-sm">
        <i class="bi bi-arrow-left me-1"></i>Back
      </a>
      <h4 class="fw-bold mb-0" style="color:#1a237e;">${college.collegeName}</h4>
      <a href="${pageContext.request.contextPath}/admin/college/edit/${college.collegeId}"
         class="btn btn-primary rounded-pill btn-sm px-3 ms-auto">
        <i class="bi bi-pencil me-1"></i>Edit
      </a>
    </div>

    <div class="row g-4">
      <!-- Info -->
      <div class="col-lg-5">
        <div class="card border-0 shadow-sm rounded-4 p-4 mb-3">
          <h6 class="fw-bold mb-3" style="color:#1a237e;"><i class="bi bi-info-circle me-2"></i>Basic Information</h6>
          <dl class="row mb-0 small">
            <dt class="col-5">Type</dt>
            <dd class="col-7"><span class="badge ${college.collegeType=='Government'?'bg-success':'bg-primary'}">${college.collegeType}</span></dd>
            <dt class="col-5">Affiliation</dt>  <dd class="col-7">${college.affiliation}</dd>
            <dt class="col-5">Established</dt>  <dd class="col-7">${college.establishmentYear}</dd>
            <dt class="col-5">District</dt>     <dd class="col-7">${college.districtName}</dd>
            <dt class="col-5">Province</dt>     <dd class="col-7">${college.provinceName}</dd>
            <dt class="col-5">Address</dt>      <dd class="col-7">${college.address}</dd>
            <dt class="col-5">Phone</dt>        <dd class="col-7">${college.phone}</dd>
            <dt class="col-5">Email</dt>        <dd class="col-7">${college.email}</dd>
            <dt class="col-5">Website</dt>
            <dd class="col-7">
              <c:if test="${not empty college.website}">
                <a href="${college.website}" target="_blank" class="text-decoration-none small">${college.website}</a>
              </c:if>
            </dd>
            <dt class="col-5">Status</dt>
            <dd class="col-7"><span class="badge ${college.active?'bg-success':'bg-secondary'}">${college.active?'Active':'Inactive'}</span></dd>
            <dt class="col-5">Total Programs</dt><dd class="col-7 text-primary fw-bold">${college.programs.size()}</dd>
          </dl>
        </div>

        <c:if test="${not empty college.facilities}">
        <div class="card border-0 shadow-sm rounded-4 p-4 mb-3">
          <h6 class="fw-bold mb-3" style="color:#1a237e;"><i class="bi bi-check2-square me-2"></i>Facilities</h6>
          <div class="d-flex flex-wrap gap-2">
            <c:forEach var="f" items="${college.facilities}">
              <span class="facility-chip">${f}</span>
            </c:forEach>
          </div>
        </div>
        </c:if>

        <c:if test="${not empty college.description}">
        <div class="card border-0 shadow-sm rounded-4 p-4">
          <h6 class="fw-bold mb-2" style="color:#1a237e;">About</h6>
          <p class="small text-muted mb-0">${college.description}</p>
        </div>
        </c:if>
      </div>

      <!-- Programs -->
      <div class="col-lg-7">
        <div class="card border-0 shadow-sm rounded-4 p-4">
          <div class="d-flex justify-content-between align-items-center mb-3">
            <h6 class="fw-bold mb-0" style="color:#1a237e;">
              <i class="bi bi-book me-2"></i>Programs
              <span class="badge bg-primary ms-1">${college.programs.size()}</span>
            </h6>
            <a href="${pageContext.request.contextPath}/admin/program/new"
               class="btn btn-sm btn-outline-success rounded-pill">
              <i class="bi bi-plus me-1"></i>Add Program
            </a>
          </div>
          <c:choose>
            <c:when test="${empty college.programs}">
              <p class="text-muted small">No programs added yet.</p>
            </c:when>
            <c:otherwise>
              <div class="table-responsive">
                <table class="table table-hover align-middle small mb-0">
                  <thead class="table-light">
                    <tr>
                      <th>Program</th>
                      <th>Level</th>
                      <th>Fee/yr</th>
                      <th>Min%</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="p" items="${college.programs}">
                    <tr>
                      <td>
                        <div class="fw-semibold">${p.programName}</div>
                        <div class="text-muted" style="font-size:.75rem;">${p.facultyName}</div>
                      </td>
                      <td><span class="badge bg-light text-dark border">${p.degreeLevel}</span></td>
                      <td>${p.formattedFee}</td>
                      <td>${p.minPercentage > 0 ? p.minPercentage : '—'}</td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/program/edit/${p.programId}"
                           class="btn btn-xs btn-outline-primary rounded-pill" style="font-size:.72rem;padding:2px 8px;">Edit</a>
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
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
