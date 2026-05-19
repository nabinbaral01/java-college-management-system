<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Review Application – Admin</title>
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
    dt{color:#6c757d;font-weight:400;font-size:.9rem;}
    dd{font-weight:600;}
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
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/programs"><i class="bi bi-book me-2"></i>Manage Programs</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-2"></i>Manage Users</a>
      <a class="nav-link active" href="${pageContext.request.contextPath}/admin/applications"><i class="bi bi-file-earmark-check me-2"></i>Applications</a>
      <hr class="border-light opacity-25 mx-3">
      <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
    </nav>
  </div>
  <div class="flex-grow-1 p-4">
    <div class="d-flex align-items-center gap-3 mb-4">
      <a href="${pageContext.request.contextPath}/admin/applications" class="btn btn-outline-secondary rounded-pill btn-sm">
        <i class="bi bi-arrow-left me-1"></i>Back
      </a>
      <h4 class="fw-bold mb-0" style="color:#1a237e;">Review Application #${application.applicationId}</h4>
    </div>

    <div class="row g-4">
      <!-- Application Info -->
      <div class="col-lg-5">
        <div class="card border-0 shadow-sm rounded-4 p-4 mb-3">
          <h6 class="fw-bold mb-3" style="color:#1a237e;"><i class="bi bi-person me-2"></i>Student Details</h6>
          <dl class="row mb-0">
            <dt class="col-5">Full Name</dt><dd class="col-7">${application.fullName}</dd>
            <dt class="col-5">Username</dt><dd class="col-7">${application.username}</dd>
            <dt class="col-5">Email</dt><dd class="col-7">${application.email}</dd>
          </dl>
        </div>
        <div class="card border-0 shadow-sm rounded-4 p-4">
          <h6 class="fw-bold mb-3" style="color:#1a237e;"><i class="bi bi-building me-2"></i>Program Details</h6>
          <dl class="row mb-0">
            <dt class="col-5">Program</dt><dd class="col-7">${application.programName}</dd>
            <dt class="col-5">College</dt><dd class="col-7">${application.collegeName}</dd>
            <dt class="col-5">Faculty</dt><dd class="col-7">${application.facultyName}</dd>
            <dt class="col-5">Level</dt><dd class="col-7">${application.degreeLevel}</dd>
            <dt class="col-5">Applied</dt><dd class="col-7 small">${application.appliedDate}</dd>
            <dt class="col-5">Status</dt>
            <dd class="col-7"><span class="badge bg-${application.statusBadgeClass} rounded-pill">${application.status}</span></dd>
          </dl>
          <c:if test="${not empty application.remarks}">
            <hr>
            <div class="small text-muted mb-1 fw-semibold">Student's Remarks:</div>
            <div class="small bg-light rounded-3 p-2">${application.remarks}</div>
          </c:if>
        </div>
      </div>

      <!-- Update Status -->
      <div class="col-lg-7">
        <div class="card border-0 shadow-sm rounded-4 p-4">
          <h6 class="fw-bold mb-4" style="color:#1a237e;"><i class="bi bi-pencil-square me-2"></i>Update Application Status</h6>
          <form action="${pageContext.request.contextPath}/admin/applications" method="post">
            <input type="hidden" name="applicationId" value="${application.applicationId}">
            <div class="mb-3">
              <label class="form-label small fw-semibold text-muted">New Status *</label>
              <select name="status" class="form-select" required>
                <option value="">Select Status</option>
                <c:forEach var="st" items="${['Submitted','Under Review','Shortlisted','Accepted','Rejected','Withdrawn']}">
                  <option value="${st}" ${application.status==st?'selected':''}>${st}</option>
                </c:forEach>
              </select>
            </div>
            <div class="mb-4">
              <label class="form-label small fw-semibold text-muted">Admin Notes (visible to student)</label>
              <textarea name="adminNotes" class="form-control" rows="5"
                        placeholder="Enter feedback, instructions, or notes for the student...">${application.adminNotes}</textarea>
            </div>
            <div class="d-flex gap-2">
              <button type="submit" class="btn btn-primary rounded-pill px-5 fw-semibold">
                <i class="bi bi-save me-2"></i>Update Status
              </button>
              <a href="${pageContext.request.contextPath}/admin/applications" class="btn btn-outline-secondary rounded-pill px-4">Cancel</a>
            </div>
          </form>
        </div>

        <!-- Status History / Timeline hint -->
        <div class="alert alert-info rounded-3 mt-3 small">
          <i class="bi bi-info-circle me-2"></i>
          <strong>Workflow:</strong> Submitted → Under Review → Shortlisted → Accepted / Rejected.
          The student will see the status and admin notes on their Applications page.
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
