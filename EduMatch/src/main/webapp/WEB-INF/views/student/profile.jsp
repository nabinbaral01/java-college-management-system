<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>My Profile – EduMatch</title>
  <link class="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link class="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:#f0f2f8;}
    .sidebar{background:linear-gradient(180deg,#1a237e,#283593);min-height:calc(100vh - 62px);width:240px;flex-shrink:0;}
    .sidebar .nav-link{color:rgba(255,255,255,.75);border-radius:10px;padding:10px 14px;margin:2px 8px;transition:.2s;}
    .sidebar .nav-link:hover,.sidebar .nav-link.active{background:rgba(255,255,255,.15);color:#fff;}
    .sidebar .nav-link i{width:22px;}
    .form-control,.form-select{border-radius:10px;border:2px solid #e8eaf6;}
    .form-control:focus,.form-select:focus{border-color:#3f51b5;box-shadow:none;}
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<div class="d-flex">
  <div class="sidebar py-4">
    <div class="px-4 mb-4"><div class="text-white opacity-50 small text-uppercase fw-semibold" style="letter-spacing:1px;">Student Menu</div></div>
    <nav class="nav flex-column">
      <a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard"><i class="bi bi-house me-2"></i>Dashboard</a>
      <a class="nav-link active" href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person me-2"></i>My Profile</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/academic"><i class="bi bi-journal-text me-2"></i>Academic Records</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/match"><i class="bi bi-stars me-2"></i>College Match</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/colleges"><i class="bi bi-building me-2"></i>Browse Colleges</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/applications"><i class="bi bi-file-earmark-text me-2"></i>Applications</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/student/saved"><i class="bi bi-bookmark me-2"></i>Saved Colleges</a>
      <hr class="border-light opacity-25 mx-3">
      <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
    </nav>
  </div>

  <div class="flex-grow-1 p-4">
    <h4 class="fw-bold mb-4" style="font-family:'Playfair Display',serif;color:#1a237e;">
      <i class="bi bi-person-circle me-2"></i>My Profile
    </h4>
    <c:if test="${not empty error}">
      <div class="alert alert-danger rounded-3"><i class="bi bi-x-circle me-2"></i>${error}</div>
    </c:if>

    <div class="card border-0 shadow-sm rounded-4 p-4" style="max-width:700px;">
      <form action="${pageContext.request.contextPath}/student/profile" method="post">
        <div class="row g-3">
          <div class="col-12">
            <label class="form-label small fw-semibold text-muted">Full Name *</label>
            <input type="text" name="fullName" class="form-control"
                   value="${profile.fullName}" placeholder="Full legal name" required>
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">Date of Birth</label>
            <input type="date" name="dateOfBirth" class="form-control" value="${profile.dateOfBirth}">
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">Gender</label>
            <select name="gender" class="form-select">
              <option value="">Select</option>
              <option value="Male"              ${profile.gender=='Male'?'selected':''}>Male</option>
              <option value="Female"            ${profile.gender=='Female'?'selected':''}>Female</option>
              <option value="Other"             ${profile.gender=='Other'?'selected':''}>Other</option>
              <option value="Prefer not to say" ${profile.gender=='Prefer not to say'?'selected':''}>Prefer not to say</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">Phone</label>
            <input type="tel" name="phone" class="form-control" value="${profile.phone}" placeholder="98XXXXXXXX">
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">Citizenship No.</label>
            <input type="text" name="citizenshipNo" class="form-control" value="${profile.citizenshipNo}">
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">Province</label>
            <select name="province" class="form-select">
              <option value="">Select Province</option>
              <c:forEach var="prov" items="${['Koshi Province','Madhesh Province','Bagmati Province','Gandaki Province','Lumbini Province','Karnali Province','Sudurpashchim Province']}">
                <option value="${prov}" ${profile.province==prov?'selected':''}>${prov}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label small fw-semibold text-muted">District</label>
            <input type="text" name="district" class="form-control" value="${profile.district}" placeholder="Your district">
          </div>
          <div class="col-12">
            <label class="form-label small fw-semibold text-muted">Address</label>
            <input type="text" name="address" class="form-control" value="${profile.address}" placeholder="Street / Ward / Municipality">
          </div>
          <div class="col-12">
            <label class="form-label small fw-semibold text-muted">Bio / About</label>
            <textarea name="bio" class="form-control" rows="3" placeholder="A short intro about yourself...">${profile.bio}</textarea>
          </div>
          <div class="col-12">
            <button type="submit" class="btn btn-primary rounded-pill px-5 fw-semibold">
              <i class="bi bi-save me-2"></i>Save Profile
            </button>
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
