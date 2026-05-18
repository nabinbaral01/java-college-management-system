<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Login – EduMatch Nepal</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body { font-family:'DM Sans',sans-serif; background:linear-gradient(135deg,#e8eaf6,#e3f2fd); min-height:100vh; }
    .auth-card { border:none; border-radius:24px; box-shadow:0 24px 60px rgba(26,35,126,0.12); }
    .brand-panel { background:linear-gradient(160deg,#1a237e,#283593); border-radius:24px 0 0 24px; }
    .form-control { border-radius:12px; padding:12px 16px; border:2px solid #e8eaf6; transition:border-color .2s; }
    .form-control:focus { border-color:#3f51b5; box-shadow:none; }
    .btn-login { background:linear-gradient(135deg,#1a237e,#3f51b5); border:none; border-radius:12px; padding:12px; font-weight:600; letter-spacing:.5px; }
    .btn-login:hover { opacity:.9; }
    .input-group-text { border-radius:12px 0 0 12px; border:2px solid #e8eaf6; background:#f8f9ff; border-right:0; }
    .form-control.with-prefix { border-left:0; border-radius:0 12px 12px 0; }
    @media(max-width:768px) { .brand-panel { display:none; } .auth-card { border-radius:24px; } }
  </style>
</head>
<body class="d-flex align-items-center justify-content-center p-3">
<div class="card auth-card" style="max-width:900px;width:100%;">
  <div class="row g-0">
    <!-- Brand Panel -->
    <div class="col-md-5 brand-panel d-flex flex-column justify-content-center align-items-center text-white p-5">
      <div class="mb-4 fs-1">🎓</div>
      <h2 class="fw-bold mb-2 text-center" style="font-family:'Playfair Display',serif;">EduMatch</h2>
      <p class="text-center opacity-75 mb-4">Nepal's college discovery and eligibility matching platform</p>
      <hr class="border-light opacity-25 w-75">
      <ul class="list-unstyled text-center opacity-75 small mt-3">
        <li class="mb-2">✅ Eligibility-based college matching</li>
        <li class="mb-2">✅ Browse 100+ colleges across Nepal</li>
        <li class="mb-2">✅ Track your applications</li>
        <li>✅ Save favourite colleges</li>
      </ul>
    </div>

    <!-- Login Form -->
    <div class="col-md-7 p-5">
      <h4 class="fw-bold mb-1" style="color:#1a237e;">Welcome back!</h4>
      <p class="text-muted mb-4 small">Sign in to your EduMatch account</p>

      <c:if test="${param.registered eq 'true'}">
        <div class="alert alert-success rounded-3 small"><i class="bi bi-check-circle me-2"></i>Registration successful! Please log in.</div>
      </c:if>
      <c:if test="${param.logout eq 'true'}">
        <div class="alert alert-info rounded-3 small"><i class="bi bi-info-circle me-2"></i>You have been logged out.</div>
      </c:if>
      <c:if test="${param.error eq 'session'}">
        <div class="alert alert-warning rounded-3 small"><i class="bi bi-exclamation-triangle me-2"></i>Session expired. Please log in again.</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger rounded-3 small"><i class="bi bi-x-circle me-2"></i>${error}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
        <div class="mb-3">
          <label class="form-label fw-semibold small text-muted">Username</label>
          <div class="input-group">
            <span class="input-group-text"><i class="bi bi-person text-muted"></i></span>
            <input type="text" name="username" class="form-control with-prefix"
                   value="${username}" placeholder="Enter your username" required autofocus>
          </div>
        </div>
        <div class="mb-4">
          <label class="form-label fw-semibold small text-muted">Password</label>
          <div class="input-group">
            <span class="input-group-text"><i class="bi bi-lock text-muted"></i></span>
            <input type="password" name="password" id="pwd" class="form-control with-prefix"
                   placeholder="Enter your password" required>
            <button type="button" class="btn btn-outline-secondary border-start-0 border"
                    onclick="togglePwd()" style="border-radius:0 12px 12px 0;border-left:0 !important;">
              <i class="bi bi-eye" id="eyeIcon"></i>
            </button>
          </div>
        </div>
        <button type="submit" class="btn btn-login btn-primary w-100 text-white mb-4">
          Sign In <i class="bi bi-arrow-right ms-2"></i>
        </button>
        <div class="text-center small text-muted">
          Don't have an account?
          <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-semibold" style="color:#1a237e;">Create one free</a>
        </div>
        <div class="text-center mt-3 small text-muted">
          <i class="bi bi-shield-lock me-1"></i>Admin? Use admin credentials to access the admin panel.
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function togglePwd() {
  const p = document.getElementById('pwd');
  const i = document.getElementById('eyeIcon');
  p.type = p.type === 'password' ? 'text' : 'password';
  i.className = p.type === 'password' ? 'bi bi-eye' : 'bi bi-eye-slash';
}
</script>
</body>
</html>
