<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Chỉ include header để lấy CSS/Bootstrap, không cần sidebar cho trang lỗi toàn cục -->
<jsp:include page="/views/header.jsp" />

<style>
    body {
        background-color: #f8fafc;
        height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .error-card {
        background: #ffffff;
        border-radius: 1rem;
        box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        padding: 3rem;
        max-width: 500px;
        width: 100%;
        text-align: center;
    }
    .btn-navy { background-color: #1e3a8a; color: white; border: none; }
    .btn-navy:hover { background-color: #0a192f; color: white; }
</style>

<div class="error-card">
    <div class="mb-4">
        <i class="fa-solid fa-triangle-exclamation text-danger" style="font-size: 5rem;"></i>
    </div>
    
    <h2 class="fw-bold mb-3" style="color: #0a192f;">Đã xảy ra lỗi!</h2>
    
    <div class="alert alert-danger text-start mb-4 border-0 bg-danger bg-opacity-10 text-danger">
        <i class="fa-solid fa-circle-info me-2"></i>
        <strong>Chi tiết: </strong> 
        ${not empty error ? error : 'Hệ thống đang gặp sự cố không xác định. Vui lòng thử lại sau.'}
    </div>
    
    <p class="text-secondary small mb-4">
        Nếu lỗi vẫn tiếp diễn, vui lòng liên hệ với Quản trị viên (Admin) hệ thống để được hỗ trợ.
    </p>
    
    <button onclick="history.back()" class="btn btn-light px-4 py-2 fw-bold me-2">
        <i class="fa-solid fa-arrow-left me-2"></i> Quay lại
    </button>
    <a href="${pageContext.request.contextPath}/login" class="btn btn-navy px-4 py-2 fw-bold">
        <i class="fa-solid fa-house me-2"></i> Về Trang chủ
    </a>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>