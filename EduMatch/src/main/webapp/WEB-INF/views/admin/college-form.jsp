<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Admin college form: used for adding or editing college records in the admin portal --%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>${empty college ? 'Add' : 'Edit'} College – Admin</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .admin-sidebar{background:linear-gradient(180deg,#0d1b4b,#1a237e);min-height:calc(100vh - 62px);width:250px;flex-shrink:0;}
    .admin-sidebar .nav-link{color:rgba(255,255,255,.7);border-radius:10px;padding:10px 14px;margin:2px 8px;transition:.2s;}
    .admin-sidebar .nav-link:hover,.admin-sidebar .nav-link.active{background:rgba(255,255,255,.15);color:#fff;}
    .form-control,.form-select{border-radius:10px;border:2px solid #e8eaf6;}
    .form-control:focus,.form-select:focus{border-color:#3f51b5;box-shadow:none;}
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
    <div class="d-flex align-items-center gap-3 mb-4">
      <a href="${pageContext.request.contextPath}/admin/colleges" class="btn btn-outline-secondary rounded-pill btn-sm">
        <i class="bi bi-arrow-left me-1"></i>Back
      </a>
      <h4 class="fw-bold mb-0" style="color:#1a237e;">
        ${empty college ? 'Add New College' : 'Edit College'}
      </h4>
    </div>

    <c:if test="${not empty error}">
      <div class="alert alert-danger rounded-3"><i class="bi bi-x-circle me-2"></i>${error}</div>
    </c:if>

    <div class="card border-0 shadow-sm rounded-4 p-4" style="max-width:800px;">
      <form action="${pageContext.request.contextPath}/admin/colleges" method="post">
        <input type="hidden" name="action" value="${empty college ? 'create' : 'update'}">
        <c:if test="${not empty college}">
          <input type="hidden" name="collegeId" value="${college.collegeId}">
        </c:if>

        <div class="row g-3">
          <div class="col-md-8">
            <label class="form-label small fw-semibold text-muted">College Name *</label>
            <input type="text" name="collegeName" class="form-control"
                   value="${college.collegeName}" required placeholder="Full official name">
          </div>
          <div class="col-md-4">
            <label class="form-label small fw-semibold text-muted">Short Name</label>
            <input type="text" name="shortName" class="form-control"
                   value="${college.shortName}" placeholder="e.g. IOE, KU">
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">College Type *</label>
            <select name="collegeType" class="form-select" required>
              <option value="">Select Type</option>
              <option value="Government"   ${college.collegeType=='Government'?'selected':''}>Government</option>
              <option value="Private"      ${college.collegeType=='Private'?'selected':''}>Private</option>
              <option value="Community"    ${college.collegeType=='Community'?'selected':''}>Community</option>
              <option value="Constituent"  ${college.collegeType=='Constituent'?'selected':''}>Constituent</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">Affiliation / University</label>
            <input type="text" name="affiliation" class="form-control" value="${college.affiliation}" placeholder="e.g. Tribhuvan University">
          </div>
          <div class="col-md-4">
            <label class="form-label small fw-semibold text-muted">District ID</label>
            <input type="number" name="districtId" class="form-control" value="${college.districtId}">
          </div>
          <div class="col-md-4">
            <label class="form-label small fw-semibold text-muted">Established Year</label>
            <input type="number" name="establishmentYear" class="form-control" value="${college.establishmentYear}" placeholder="1990">
          </div>
          <div class="col-md-4">
            <label class="form-label small fw-semibold text-muted">Phone</label>
            <input type="text" name="phone" class="form-control" value="${college.phone}">
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">Email</label>
            <input type="email" name="email" class="form-control" value="${college.email}">
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">Website</label>
            <input type="url" name="website" class="form-control" value="${college.website}" placeholder="https://...">
          </div>
          <div class="col-12">
            <label class="form-label small fw-semibold text-muted">Address</label>
            <input type="text" name="address" class="form-control" value="${college.address}">
          </div>
          <div class="col-12">
            <label class="form-label small fw-semibold text-muted">Description</label>
            <textarea name="description" class="form-control" rows="4">${college.description}</textarea>
          </div>

          <!-- Facilities checkboxes -->
          <div class="col-12">
            <label class="form-label small fw-semibold text-muted">Facilities</label>
            <div class="row g-2">
              <c:forEach var="fac" items="${[['1','Library'],['2','Computer Lab'],['3','Hostel'],['4','Canteen'],['5','Sports Ground'],['6','Wi-Fi Campus'],['7','Research Lab'],['8','Auditorium'],['9','Medical Facility'],['10','Scholarship Available'],['11','Transportation'],['12','Parking']]}">
              <div class="col-md-3 col-6">
                <div class="form-check">
                  <input type="checkbox" class="form-check-input" name="facilities" value="${fac[0]}"
                         id="fac${fac[0]}"
                         <c:if test="${not empty college.facilities and college.facilities.contains(fac[1])}">checked</c:if>>
                  <label class="form-check-label small" for="fac${fac[0]}">${fac[1]}</label>
                </div>
              </div>
              </c:forEach>
            </div>
          </div>

          <c:if test="${not empty college}">
          <div class="col-md-4">
            <div class="form-check form-switch">
              <input type="checkbox" class="form-check-input" id="isActive" name="isActive" value="true" ${college.active?'checked':''}>
              <label class="form-check-label small fw-semibold" for="isActive">Active (visible to students)</label>
            </div>
          </div>
          </c:if>

          <div class="col-12 d-flex gap-2 mt-2">
            <button type="submit" class="btn btn-primary rounded-pill px-5 fw-semibold">
              <i class="bi bi-save me-2"></i>${empty college ? 'Add College' : 'Update College'}
            </button>
            <a href="${pageContext.request.contextPath}/admin/colleges" class="btn btn-outline-secondary rounded-pill px-4">Cancel</a>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
