<%--
  footer.jsp - Common Footer Component
  Reusable footer fragment included in all pages of the EduMatch application
  Displays platform branding, navigation links, quick links, contact information, and copyright
  Styled with dark blue background (#0d1b4b) and responsive Bootstrap grid layout
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<footer class="py-5 mt-auto" style="background:#0d1b4b;color:#aab4d4;">
  <div class="container">
    <div class="row g-4">
      <div class="col-md-4">
        <h5 class="text-white fw-bold mb-3">🎓 EduMatch Nepal</h5>
        <p class="small">Helping Nepali students discover the right college for their academic journey. Powered by real eligibility matching.</p>
      </div>
      <div class="col-md-2">
        <h6 class="text-white fw-semibold mb-3">Platform</h6>
        <ul class="list-unstyled small">
          <li><a href="${pageContext.request.contextPath}/colleges" class="text-decoration-none" style="color:#aab4d4;">Browse Colleges</a></li>
          <li><a href="${pageContext.request.contextPath}/register" class="text-decoration-none" style="color:#aab4d4;">Register</a></li>
          <li><a href="${pageContext.request.contextPath}/login" class="text-decoration-none" style="color:#aab4d4;">Login</a></li>
        </ul>
      </div>
      <div class="col-md-3">
        <h6 class="text-white fw-semibold mb-3">Quick Links</h6>
        <ul class="list-unstyled small">
          <li><a href="#" class="text-decoration-none" style="color:#aab4d4;">TU Entrance</a></li>
          <li><a href="#" class="text-decoration-none" style="color:#aab4d4;">IOE Entrance</a></li>
          <li><a href="#" class="text-decoration-none" style="color:#aab4d4;">MECEE-BL</a></li>
        </ul>
      </div>
      <div class="col-md-3">
        <h6 class="text-white fw-semibold mb-3">Contact</h6>
        <p class="small mb-1"><i class="bi bi-geo-alt me-2"></i>Kathmandu, Nepal</p>
        <p class="small mb-1"><i class="bi bi-envelope me-2"></i>info@edumatch.np</p>
        <p class="small"><i class="bi bi-telephone me-2"></i>+977-01-XXXXXXX</p>
      </div>
    </div>
    <hr style="border-color:#2a3a7a;">
    <div class="text-center small">
      &copy; 2025 EduMatch Nepal &mdash; College Discovery &amp; Eligibility Platform &bull;
      Built with Java Servlet &bull; JSP &bull; MySQL &bull; MVC Architecture
    </div>
  </div>
</footer>
