<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Register page for EduMatch Nepal with enhanced UI and client-side validation -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Register – EduMatch Nepal</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@400;600&display=swap" rel="stylesheet">
  <style>
    body{font-family:'DM Sans',sans-serif;background:linear-gradient(135deg,#e8eaf6,#e3f2fd);min-height:100vh;}
    .auth-card{border:none;border-radius:24px;box-shadow:0 24px 60px rgba(26,35,126,.12);}
    .brand-panel{background:linear-gradient(160deg,#1a237e,#283593);border-radius:24px 0 0 24px;}
    .form-control{border-radius:12px;padding:12px 16px;border:2px solid #e8eaf6;transition:border-color .2s;}
    .form-control:focus{border-color:#3f51b5;box-shadow:none;}
    .btn-reg{background:linear-gradient(135deg,#1a237e,#3f51b5);border:none;border-radius:12px;padding:12px;font-weight:600;}
    .input-group-text{border-radius:12px 0 0 12px;border:2px solid #e8eaf6;background:#f8f9ff;border-right:0;}
    .form-control.ip{border-left:0;border-radius:0 12px 12px 0;}
    .strength-bar{height:4px;border-radius:2px;transition:width .3s,background .3s;}
    @media(max-width:768px){.brand-panel{display:none;}.auth-card{border-radius:24px;}}
  </style>
</head>
<body class="d-flex align-items-center justify-content-center p-3 py-5">
<div class="card auth-card" style="max-width:920px;width:100%;">
  <div class="row g-0">
    <div class="col-md-4 brand-panel d-flex flex-column justify-content-center align-items-center text-white p-5">
      <div class="mb-3 fs-1">🎓</div>
      <h3 class="fw-bold mb-2 text-center" style="font-family:'Playfair Display',serif;">Join EduMatch</h3>
      <p class="text-center opacity-75 small mb-4">Start your college discovery journey today — completely free.</p>
      <hr class="border-light opacity-25 w-75">
      <ul class="list-unstyled opacity-75 small mt-3 text-center">
        <li class="mb-2">🏫 Access all Nepal colleges</li>
        <li class="mb-2">📊 Eligibility matching</li>
        <li class="mb-2">📝 Apply online</li>
        <li>🔔 Application tracking</li>
      </ul>
    </div>
    <div class="col-md-8 p-5">
      <h4 class="fw-bold mb-1" style="color:#1a237e;">Create your account</h4>
      <p class="text-muted mb-4 small">Fill in your details to get started</p>

      <c:if test="${not empty error}">
        <div class="alert alert-danger rounded-3 small"><i class="bi bi-x-circle me-2"></i>${error}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/register" method="post" novalidate id="regForm">
        <div class="mb-3">
          <label class="form-label fw-semibold small text-muted">Full Name *</label>
          <div class="input-group">
            <span class="input-group-text"><i class="bi bi-person-badge text-muted"></i></span>
            <input type="text" name="fullName" class="form-control ip" value="${fullName}"
                   placeholder="Your full name as on citizenship" required>
          </div>
        </div>
        <div class="row g-3 mb-3">
          <div class="col-sm-6">
            <label class="form-label fw-semibold small text-muted">Username *</label>
            <div class="input-group">
              <span class="input-group-text"><i class="bi bi-at text-muted"></i></span>
              <input type="text" name="username" class="form-control ip" value="${username}"
                     placeholder="e.g. ram_thapa" pattern="[a-zA-Z0-9_]{3,50}" required>
            </div>
            <div class="form-text">3-50 chars, letters/numbers/underscore</div>
          </div>
          <div class="col-sm-6">
            <label class="form-label fw-semibold small text-muted">Email *</label>
            <div class="input-group">
              <span class="input-group-text"><i class="bi bi-envelope text-muted"></i></span>
              <input type="email" name="email" class="form-control ip" value="${email}"
                     placeholder="your@email.com" required>
            </div>
          </div>
        </div>
        <div class="row g-3 mb-4">
          <div class="col-sm-6">
            <label class="form-label fw-semibold small text-muted">Password *</label>
            <div class="input-group">
              <span class="input-group-text"><i class="bi bi-lock text-muted"></i></span>
              <input type="password" name="password" id="pwd" class="form-control ip"
                     placeholder="Min 8 chars" required oninput="checkStrength(this.value)">
            </div>
            <div class="mt-2">
              <div class="bg-light rounded" style="height:4px;">
                <div class="strength-bar" id="strengthBar" style="width:0%;"></div>
              </div>
              <div class="form-text" id="strengthText"></div>
            </div>
          </div>
          <div class="col-sm-6">
            <label class="form-label fw-semibold small text-muted">Confirm Password *</label>
            <div class="input-group">
              <span class="input-group-text"><i class="bi bi-lock-fill text-muted"></i></span>
              <input type="password" name="confirmPassword" id="cpwd" class="form-control ip"
                     placeholder="Repeat password" required>
            </div>
            <div class="form-text text-danger d-none" id="matchError">Passwords do not match</div>
          </div>
        </div>
        <div class="mb-4 form-check">
          <input type="checkbox" class="form-check-input" id="terms" required>
          <label class="form-check-label small" for="terms">
            I agree to the <a href="#" class="text-decoration-none fw-semibold" style="color:#1a237e;">Terms of Service</a> and
            <a href="#" class="text-decoration-none fw-semibold" style="color:#1a237e;">Privacy Policy</a>
          </label>
        </div>
        <button type="submit" class="btn btn-reg btn-primary w-100 text-white mb-3" onclick="return validate()">
          Create Account <i class="bi bi-arrow-right ms-2"></i>
        </button>
        <div class="text-center small text-muted">
          Already have an account?
          <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-semibold" style="color:#1a237e;">Sign in</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function checkStrength(v) {
  let s=0,t='',c='';
  if(v.length>=8)s++;
  if(/[A-Z]/.test(v))s++;
  if(/[0-9]/.test(v))s++;
  if(/[@$!%*?&]/.test(v))s++;
  if(s<=1){t='Weak';c='#ef5350';}
  else if(s<=2){t='Fair';c='#ff9800';}
  else if(s<=3){t='Good';c='#66bb6a';}
  else{t='Strong';c='#2e7d32';}
  document.getElementById('strengthBar').style.width=(s*25)+'%';
  document.getElementById('strengthBar').style.background=c;
  document.getElementById('strengthText').textContent=v?'Strength: '+t:'';
  document.getElementById('strengthText').style.color=c;
}
function validate() {
  const p=document.getElementById('pwd').value;
  const c=document.getElementById('cpwd').value;
  const m=document.getElementById('matchError');
  if(p!==c){m.classList.remove('d-none');return false;}
  m.classList.add('d-none');
  return true;
}
document.getElementById('cpwd').addEventListener('input',function(){
  const m=document.getElementById('matchError');
  if(this.value && this.value!==document.getElementById('pwd').value)
    m.classList.remove('d-none');
  else m.classList.add('d-none');
});
</script>
</body>
</html>
