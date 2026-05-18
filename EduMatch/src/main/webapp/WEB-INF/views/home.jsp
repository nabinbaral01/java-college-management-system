<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- EduMatch homepage with featured colleges and discovery UX -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>EduMatch Nepal – College Discovery & Eligibility Platform</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;600&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'DM Sans', sans-serif; }
    .hero { background: linear-gradient(135deg, #0d1b4b 0%, #1a237e 50%, #283593 100%); min-height: 88vh; position: relative; overflow: hidden; }
    .hero::before { content:''; position:absolute; inset:0; background:url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.03'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E"); }
    .hero-title { font-family: 'Playfair Display', serif; font-size: clamp(2.5rem, 5vw, 4rem); line-height: 1.1; }
    .stat-card { background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.15); border-radius: 16px; }
    .search-bar { background: rgba(255,255,255,0.95); border-radius: 50px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
    .feature-card { border: none; border-radius: 20px; transition: transform .3s, box-shadow .3s; }
    .feature-card:hover { transform: translateY(-6px); box-shadow: 0 20px 40px rgba(26,35,126,0.15) !important; }
    .college-card { border: none; border-radius: 16px; overflow: hidden; transition: transform .3s, box-shadow .3s; }
    .college-card:hover { transform: translateY(-4px); box-shadow: 0 16px 40px rgba(0,0,0,0.12) !important; }
    .type-badge-gov  { background: #e8f5e9; color: #2e7d32; }
    .type-badge-priv { background: #e3f2fd; color: #1565c0; }
    .step-num { width: 52px; height: 52px; border-radius: 50%; background: linear-gradient(135deg,#1a237e,#283593); color: #fff; font-weight: 700; font-size: 1.2rem; display: flex; align-items: center; justify-content: center; }
  </style>
</head>
<body class="d-flex flex-column min-vh-100">
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- ── HERO ─────────────────────────────────────────── -->
<section class="hero d-flex align-items-center">
  <div class="container py-5 position-relative">
    <div class="row align-items-center g-5">
      <div class="col-lg-6 text-white">
        <span class="badge rounded-pill mb-3 px-3 py-2" style="background:rgba(255,193,7,0.2);color:#ffc107;border:1px solid rgba(255,193,7,0.3);">
          🇳🇵 Designed for Nepal
        </span>
        <h1 class="hero-title mb-4">
          Find Your <span style="color:#ffc107;">Perfect College</span> Match in Nepal
        </h1>
        <p class="lead mb-5 opacity-75">Enter your academic scores once — EduMatch instantly shows every college and program you're eligible for across all 7 provinces.</p>

        <!-- Search bar -->
        <form action="${pageContext.request.contextPath}/colleges" method="get">
          <div class="search-bar d-flex align-items-center p-2 gap-2">
            <i class="bi bi-search ms-3 text-muted fs-5"></i>
            <input type="text" name="q" class="form-control border-0 bg-transparent shadow-none ps-1"
                   placeholder="Search colleges, programs, universities…" style="font-size:1rem;">
            <button type="submit" class="btn btn-primary px-4 py-2 rounded-pill fw-semibold">Search</button>
          </div>
        </form>

        <!-- Stats -->
        <div class="row g-3 mt-4">
          <div class="col-4">
            <div class="stat-card text-center py-3 px-2">
              <div class="fw-bold fs-4 text-warning">${totalColleges}+</div>
              <div class="small opacity-75">Colleges</div>
            </div>
          </div>
          <div class="col-4">
            <div class="stat-card text-center py-3 px-2">
              <div class="fw-bold fs-4 text-warning">${totalPrograms}+</div>
              <div class="small opacity-75">Programs</div>
            </div>
          </div>
          <div class="col-4">
            <div class="stat-card text-center py-3 px-2">
              <div class="fw-bold fs-4 text-warning">7</div>
              <div class="small opacity-75">Provinces</div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-lg-6 text-center d-none d-lg-block">
        <div class="position-relative" style="height:420px;">
          <div class="position-absolute rounded-3 p-4 text-white text-start shadow-lg"
               style="background:rgba(255,255,255,0.12);backdrop-filter:blur(12px);border:1px solid rgba(255,255,255,0.2);top:20px;left:20px;right:80px;">
            <div class="d-flex align-items-center gap-3 mb-3">
              <span class="fs-2">🏛️</span>
              <div>
                <div class="fw-bold">IOE Pulchowk Campus</div>
                <div class="small opacity-75">Engineering • Lalitpur</div>
              </div>
            </div>
            <div class="d-flex gap-2 flex-wrap">
              <span class="badge rounded-pill bg-success">✓ Eligible</span>
              <span class="badge rounded-pill" style="background:rgba(255,255,255,0.2);">BE Civil</span>
              <span class="badge rounded-pill" style="background:rgba(255,255,255,0.2);">BE Electronics</span>
            </div>
          </div>
          <div class="position-absolute rounded-3 p-4 text-white text-start shadow-lg"
               style="background:rgba(255,193,7,0.15);backdrop-filter:blur(12px);border:1px solid rgba(255,193,7,0.3);bottom:60px;right:0;left:60px;">
            <div class="d-flex align-items-center gap-3 mb-2">
              <span class="fs-2">🎯</span>
              <div>
                <div class="fw-bold">Your Match Score</div>
                <div class="small opacity-75">Based on +2 grades</div>
              </div>
            </div>
            <div class="progress bg-white bg-opacity-25" style="height:8px;border-radius:4px;">
              <div class="progress-bar bg-warning" style="width:78%"></div>
            </div>
            <div class="small mt-1 opacity-75">78% of programs match your profile</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ── HOW IT WORKS ──────────────────────────────────── -->
<section class="py-6 bg-light" style="padding:5rem 0;">
  <div class="container">
    <div class="text-center mb-5">
      <h2 class="fw-bold" style="font-family:'Playfair Display',serif;color:#1a237e;">How EduMatch Works</h2>
      <p class="text-muted">Three simple steps to your perfect college</p>
    </div>
    <div class="row g-4 justify-content-center">
      <div class="col-md-4">
        <div class="feature-card card shadow-sm h-100 p-4 text-center">
          <div class="step-num mx-auto mb-4">1</div>
          <div class="fs-1 mb-3"><i class="bi bi-person-plus text-primary"></i></div>
          <h5 class="fw-bold mb-2">Register Free</h5>
          <p class="text-muted small mb-0">Create your account in under 2 minutes with just a username and email.</p>
        </div>
      </div>
      <div class="col-md-4">
        <div class="feature-card card shadow-sm h-100 p-4 text-center">
          <div class="step-num mx-auto mb-4">2</div>
          <div class="fs-1 mb-3"><i class="bi bi-journal-text text-primary"></i></div>
          <h5 class="fw-bold mb-2">Add Your Grades</h5>
          <p class="text-muted small mb-0">Enter your SEE and +2 results to enable automatic eligibility checking.</p>
        </div>
      </div>
      <div class="col-md-4">
        <div class="feature-card card shadow-sm h-100 p-4 text-center">
          <div class="step-num mx-auto mb-4">3</div>
          <div class="fs-1 mb-3"><i class="bi bi-rocket-takeoff text-primary"></i></div>
          <h5 class="fw-bold mb-2">Discover &amp; Apply</h5>
          <p class="text-muted small mb-0">Browse matched colleges, save favourites, and submit applications directly.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ── FEATURED COLLEGES ─────────────────────────────── -->
<c:if test="${not empty featuredColleges}">
<section class="py-5">
  <div class="container">
    <div class="d-flex justify-content-between align-items-end mb-4">
      <div>
        <h2 class="fw-bold mb-1" style="font-family:'Playfair Display',serif;color:#1a237e;">Featured Colleges</h2>
        <p class="text-muted mb-0">Leading institutions across Nepal</p>
      </div>
      <a href="${pageContext.request.contextPath}/colleges" class="btn btn-outline-primary rounded-pill">
        View All <i class="bi bi-arrow-right ms-1"></i>
      </a>
    </div>
    <div class="row g-4">
      <c:forEach var="col" items="${featuredColleges}">
      <div class="col-md-6 col-lg-4">
        <div class="college-card card shadow-sm h-100">
          <div class="card-body p-4">
            <div class="d-flex align-items-start gap-3 mb-3">
              <div class="rounded-2 bg-primary bg-opacity-10 d-flex align-items-center justify-content-center text-primary fw-bold"
                   style="width:52px;height:52px;font-size:1.1rem;flex-shrink:0;">
                ${fn:substring(col.collegeName,0,2)}
              </div>
              <div>
                <h6 class="fw-bold mb-1 lh-sm">${col.collegeName}</h6>
                <span class="badge rounded-pill small ${col.collegeType == 'Government' ? 'type-badge-gov' : 'type-badge-priv'}">
                  ${col.collegeType}
                </span>
              </div>
            </div>
            <div class="d-flex gap-3 small text-muted mb-3">
              <span><i class="bi bi-geo-alt me-1"></i>${col.districtName}</span>
              <span><i class="bi bi-book me-1"></i>${col.totalPrograms} programs</span>
            </div>
            <div class="small text-muted mb-3">
              <i class="bi bi-link me-1"></i>${col.affiliation}
            </div>
          </div>
          <div class="card-footer bg-transparent border-top-0 px-4 pb-3">
            <a href="${pageContext.request.contextPath}/college/${col.collegeId}"
               class="btn btn-sm btn-outline-primary rounded-pill w-100">
              View Details <i class="bi bi-arrow-right ms-1"></i>
            </a>
          </div>
        </div>
      </div>
      </c:forEach>
    </div>
  </div>
</section>
</c:if>

<!-- ── CTA ──────────────────────────────────────────── -->
<section class="py-5 my-4">
  <div class="container">
    <div class="rounded-4 p-5 text-center text-white"
         style="background:linear-gradient(135deg,#1a237e,#1565c0);">
      <h2 class="fw-bold mb-3" style="font-family:'Playfair Display',serif;">Ready to Find Your College?</h2>
      <p class="lead mb-4 opacity-75">Join thousands of Nepali students already using EduMatch</p>
      <a href="${pageContext.request.contextPath}/register"
         class="btn btn-warning btn-lg px-5 fw-bold rounded-pill">
        Get Started Free <i class="bi bi-arrow-right ms-2"></i>
      </a>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
