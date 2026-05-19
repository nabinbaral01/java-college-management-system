<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Academic Records – EduMatch</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .sidebar{background:linear-gradient(180deg,#1a237e,#283593);min-height:calc(100vh - 62px);width:240px;flex-shrink:0;}
    .sidebar .nav-link{color:rgba(255,255,255,.75);border-radius:10px;padding:10px 14px;margin:2px 8px;transition:.2s;}
    .sidebar .nav-link:hover,.sidebar .nav-link.active{background:rgba(255,255,255,.15);color:#fff;}
    .sidebar .nav-link i{width:22px;}
    .form-control,.form-select{border-radius:10px;border:2px solid #e8eaf6;}
    .form-control:focus,.form-select:focus{border-color:#3f51b5;box-shadow:none;}
    .record-card{border:none;border-radius:16px;border-left:4px solid #3f51b5!important;}
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
      <a class="nav-link active" href="${pageContext.request.contextPath}/student/academic"><i class="bi bi-journal-text me-2"></i>Academic Records</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/match"><i class="bi bi-stars me-2"></i>College Match</a>
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
        <i class="bi bi-journal-text me-2"></i>Academic Records
      </h4>
      <p class="text-muted">Add your SEE, +2, and Bachelor level results. These are used for eligibility matching.</p>
    </div>

    <c:if test="${not empty error}">
      <div class="alert alert-danger rounded-3"><i class="bi bi-x-circle me-2"></i>${error}</div>
    </c:if>

    <div class="row g-4">
      <!-- Add Form -->
      <div class="col-lg-5">
        <div class="card border-0 shadow-sm rounded-4 p-4">
          <h6 class="fw-bold mb-4" style="color:#1a237e;"><i class="bi bi-plus-circle me-2"></i>Add / Update Record</h6>
          <form action="${pageContext.request.contextPath}/student/academic" method="post">
            <div class="mb-3">
              <label class="form-label small fw-semibold text-muted">Education Level *</label>
              <select name="level" class="form-select" required>
                <option value="">Select Level</option>
                <option value="SEE">SEE (Class 10)</option>
                <option value="+2">+2 / NEB (Class 12)</option>
                <option value="Bachelor">Bachelor's Degree</option>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label small fw-semibold text-muted">Board / University</label>
              <input type="text" name="board" class="form-control" placeholder="e.g., NEB, TU, KU">
            </div>
            <div class="mb-3">
              <label class="form-label small fw-semibold text-muted">Institution Name</label>
              <input type="text" name="institution" class="form-control" placeholder="School / College name">
            </div>
            <div class="row g-2 mb-3">
              <div class="col-6">
                <label class="form-label small fw-semibold text-muted">Passed Year</label>
                <input type="number" name="passedYear" class="form-control" placeholder="e.g. 2080" min="2000" max="2085">
              </div>
              <div class="col-6">
                <label class="form-label small fw-semibold text-muted">Grade</label>
                <input type="text" name="grade" class="form-control" placeholder="e.g. A+, B">
              </div>
            </div>
            <div class="row g-2 mb-4">
              <div class="col-6">
                <label class="form-label small fw-semibold text-muted">GPA (0–4.0)</label>
                <input type="number" name="gpa" class="form-control" step="0.01" min="0" max="4" placeholder="3.85">
              </div>
              <div class="col-6">
                <label class="form-label small fw-semibold text-muted">Percentage (%)</label>
                <input type="number" name="percentage" class="form-control" step="0.01" min="0" max="100" placeholder="78.50">
              </div>
            </div>
            <button type="submit" class="btn btn-primary rounded-pill w-100 fw-semibold">
              <i class="bi bi-save me-2"></i>Save Record
            </button>
          </form>
        </div>
      </div>

      <!-- Existing Records -->
      <div class="col-lg-7">
        <h6 class="fw-bold mb-3" style="color:#1a237e;">Your Records</h6>
        <c:choose>
          <c:when test="${empty records}">
            <div class="text-center py-5 bg-white rounded-4 shadow-sm">
              <div class="fs-1 mb-2">📚</div>
              <p class="text-muted">No academic records yet. Add your results to start matching!</p>
            </div>
          </c:when>
          <c:otherwise>
            <div class="d-flex flex-column gap-3">
              <c:forEach var="r" items="${records}">
              <div class="card record-card shadow-sm p-4">
                <div class="d-flex justify-content-between align-items-center mb-2">
                  <span class="badge rounded-pill bg-primary px-3">${r.level}</span>
                  <span class="text-muted small">${r.passedYear}</span>
                </div>
                <div class="fw-semibold">${r.institution}</div>
                <div class="text-muted small mb-2">${r.board}</div>
                <div class="d-flex flex-wrap gap-3 small">
                  <c:if test="${r.gpa > 0}">
                    <span><i class="bi bi-star me-1 text-warning"></i><strong>GPA:</strong> ${r.formattedGpa}</span>
                  </c:if>
                  <c:if test="${r.percentage > 0}">
                    <span><i class="bi bi-percent me-1 text-success"></i><strong>%:</strong> ${r.formattedPercentage}</span>
                  </c:if>
                  <c:if test="${not empty r.grade}">
                    <span><i class="bi bi-award me-1 text-info"></i><strong>Grade:</strong> ${r.grade}</span>
                  </c:if>
                </div>
              </div>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
        <div class="alert alert-info rounded-3 mt-4 small">
          <i class="bi bi-info-circle me-2"></i>
          <strong>Tip:</strong> Adding your +2 percentage unlocks the College Match feature. Each level can only have one record (updating replaces the existing one).
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
