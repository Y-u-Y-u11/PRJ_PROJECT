<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/views/layout/header.jsp" />

<div class="animate-fade-in d-flex justify-content-center align-items-center" style="min-height: 70vh;">
    <div class="card shadow-lg border-0" style="max-width: 500px; border-radius: 1.5rem;">
        <div class="card-body p-5 text-center">
            <div class="mb-4 text-danger">
                <i class="bi bi-exclamation-triangle-fill" style="font-size: 4rem;"></i>
            </div>
            
            <h2 class="fw-bold mb-3">Xác nhận xóa nhân viên?</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger bg-danger bg-opacity-10 text-danger border-0 small mb-4">
                    <i class="bi bi-info-circle me-1"></i>${error}
                </div>
            </c:if>
            
            <p class="text-muted mb-4">
                Bạn có chắc chắn muốn xóa tài khoản nhân viên 
                <span class="fw-bold text-dark">"${staff.fullName}"</span> 
                (Tên đăng nhập: <span class="badge bg-light text-muted border">${staff.username}</span>)?
            </p>
            
            <div class="bg-light p-3 rounded-3 mb-4 text-start small border">
                <p class="mb-1 text-secondary font-monospace"><i class="bi bi-info-circle me-2"></i>Thông tin tài khoản:</p>
                <ul class="mb-0 text-muted list-unstyled ps-4">
                    <li>ID: #${staff.id}</li>
                    <li>Vai trò: ${staff.role}</li>
                    <li>Trạng thái: ${staff.status}</li>
                </ul>
            </div>
            
            <p class="text-danger small mb-4">
                <i class="bi bi-shield-lock me-1"></i>
                Hành động này sẽ gỡ bỏ quyền truy cập của nhân viên này khỏi hệ thống ngay lập tức.
            </p>
            
            <form action="${pageContext.request.contextPath}/manager/users/delete" method="POST">
                <input type="hidden" name="id" value="${staff.id}">
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-danger py-3 fw-bold rounded-pill shadow-sm">
                        <i class="bi bi-trash me-2"></i>Xác nhận Xóa
                    </button>
                    <a href="${pageContext.request.contextPath}/manager/users" class="btn btn-light py-3 fw-bold rounded-pill border">
                        Quay lại danh sách
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
