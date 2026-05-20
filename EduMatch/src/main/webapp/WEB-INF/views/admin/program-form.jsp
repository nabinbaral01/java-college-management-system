<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Admin program form: used for adding or editing academic programs in admin portal --%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>${empty program ? 'Add' : 'Edit'} Program – Admin</title>
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
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/colleges"><i class="bi bi-building me-2"></i>Manage Colleges</a>
      <a class="nav-link active" href="${pageContext.request.contextPath}/admin/programs"><i class="bi bi-book me-2"></i>Manage Programs</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-2"></i>Manage Users</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/applications"><i class="bi bi-file-earmark-check me-2"></i>Applications</a>
      <hr class="border-light opacity-25 mx-3">
      <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
    </nav>
  </div>
  <div class="flex-grow-1 p-4">
    <div class="d-flex align-items-center gap-3 mb-4">
      <a href="${pageContext.request.contextPath}/admin/programs" class="btn btn-outline-secondary rounded-pill btn-sm"><i class="bi bi-arrow-left me-1"></i>Back</a>
      <h4 class="fw-bold mb-0" style="color:#1a237e;">${empty program ? 'Add New Program' : 'Edit Program'}</h4>
    </div>
    <c:if test="${not empty error}">
      <div class="alert alert-danger rounded-3"><i class="bi bi-x-circle me-2"></i>${error}</div>
    </c:if>
    <div class="card border-0 shadow-sm rounded-4 p-4" style="max-width:800px;">
      <form action="${pageContext.request.contextPath}/admin/programs" method="post">
        <input type="hidden" name="action" value="${empty program ? 'create' : 'update'}">
        <c:if test="${not empty program}"><input type="hidden" name="programId" value="${program.programId}"></c:if>
        <div class="row g-3">
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">College *</label>
            <select name="collegeId" class="form-select" required>
              <option value="">Select College</option>
              <c:forEach var="col" items="${colleges}">
                <option value="${col.collegeId}" ${program.collegeId==col.collegeId?'selected':''}>${col.collegeName}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">Faculty *</label>
            <select name="facultyId" class="form-select" required>
              <option value="">Select Faculty</option>
              <option value="1" ${program.facultyId==1?'selected':''}>Science & Technology</option>
              <option value="2" ${program.facultyId==2?'selected':''}>Management</option>
              <option value="3" ${program.facultyId==3?'selected':''}>Humanities & Social Sciences</option>
              <option value="4" ${program.facultyId==4?'selected':''}>Medical & Health Sciences</option>
              <option value="5" ${program.facultyId==5?'selected':''}>Law</option>
              <option value="6" ${program.facultyId==6?'selected':''}>Education</option>
              <option value="7" ${program.facultyId==7?'selected':''}>Agriculture</option>
              <option value="8" ${program.facultyId==8?'selected':''}>Fine Arts</option>
            </select>
          </div>
          <div class="col-md-8">
            <label class="form-label small fw-semibold text-muted">Program Name *</label>
            <input type="text" name="programName" class="form-control" value="${program.programName}" required placeholder="e.g. BE Computer Engineering">
          </div>
          <div class="col-md-4">
            <label class="form-label small fw-semibold text-muted">Degree Level *</label>
            <select name="degreeLevel" class="form-select" required>
              <option value="">Select</option>
              <c:forEach var="lv" items="${['Certificate','Diploma','+2','Bachelor','Master','PhD']}">
                <option value="${lv}" ${program.degreeLevel==lv?'selected':''}>${lv}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-3"><label class="form-label small fw-semibold text-muted">Duration (years)</label>
            <input type="number" name="durationYears" class="form-control" value="${program.durationYears}" step="0.5" min="0.5"></div>
          <div class="col-md-3"><label class="form-label small fw-semibold text-muted">Total Seats</label>
            <input type="number" name="totalSeats" class="form-control" value="${program.totalSeats}" min="1"></div>
          <div class="col-md-3"><label class="form-label small fw-semibold text-muted">Annual Fee (NPR)</label>
            <input type="number" name="annualFee" class="form-control" value="${program.annualFee}" min="0"></div>
          <div class="col-md-3"><label class="form-label small fw-semibold text-muted">Min. GPA</label>
            <input type="number" name="minGpa" class="form-control" value="${program.minGpa}" step="0.01" min="0" max="4"></div>
          <div class="col-md-4"><label class="form-label small fw-semibold text-muted">Min. Percentage (%)</label>
            <input type="number" name="minPercentage" class="form-control" value="${program.minPercentage}" step="0.01" min="0" max="100"></div>
          <div class="col-md-4">
            <label class="form-label small fw-semibold text-muted">Entrance Exam Name</label>
            <input type="text" name="entranceName" class="form-control" value="${program.entranceName}" placeholder="e.g. IOE Entrance">
          </div>
          <div class="col-md-4 d-flex align-items-end pb-2">
            <div class="form-check">
              <input type="checkbox" class="form-check-input" name="entranceRequired" id="entReq" ${program.entranceRequired?'checked':''}>
              <label class="form-check-label small fw-semibold" for="entReq">Entrance Exam Required</label>
            </div>
          </div>
          <div class="col-12">
            <label class="form-label small fw-semibold text-muted">Description</label>
            <textarea name="description" class="form-control" rows="3">${program.description}</textarea>
          </div>
          <div class="col-12 d-flex gap-2 mt-2">
            <button type="submit" class="btn btn-primary rounded-pill px-5 fw-semibold">
              <i class="bi bi-save me-2"></i>${empty program ? 'Add Program' : 'Update Program'}
            </button>
            <a href="${pageContext.request.contextPath}/admin/programs" class="btn btn-outline-secondary rounded-pill px-4">Cancel</a>
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
