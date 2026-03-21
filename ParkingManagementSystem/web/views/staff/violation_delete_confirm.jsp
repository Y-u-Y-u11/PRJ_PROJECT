<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/views/layout/header.jsp" />

<div class="animate-fade-in d-flex justify-content-center align-items-center" style="min-height: 70vh;">
    <div class="card shadow-lg border-0" style="max-width: 500px; border-radius: 1.5rem;">
        <div class="card-body p-5 text-center">
            <div class="mb-4 text-danger">
                <i class="bi bi-x-octagon-fill" style="font-size: 4rem;"></i>
            </div>
            
            <h2 class="fw-bold mb-3">Xóa biên bản vi phạm?</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger bg-danger bg-opacity-10 text-danger border-0 small mb-4 text-start">
                    <i class="bi bi-exclamation-circle-fill me-2"></i>${error}
                </div>
            </c:if>
            
            <p class="text-muted mb-4">
                Bạn có chắc chắn muốn xóa biên bản vi phạm <span class="fw-bold text-danger">#${violation.id}</span>?
            </p>
            
            <div class="bg-light p-3 rounded-3 mb-4 text-start small border">
                <p class="mb-2 text-secondary fw-bold"><i class="bi bi-info-square me-2"></i>Chi tiết vi phạm:</p>
                <div class="row g-2">
                    <div class="col-5 text-muted">Lý do:</div>
                    <div class="col-7 fw-bold">${violation.reason}</div>
                    <div class="col-5 text-muted">Mức phạt:</div>
                    <div class="col-7 text-danger fw-bold">${violation.fine} VNĐ</div>
                    <div class="col-5 text-muted">Trạng thái:</div>
                    <div class="col-7">
                        <span class="badge ${violation.status == 'Paid' ? 'bg-success' : 'bg-warning text-dark'}">${violation.status}</span>
                    </div>
                </div>
            </div>
            
            <p class="text-secondary small mb-4">
                <i class="bi bi-info-circle me-1"></i>
                Hành động này sẽ xóa vĩnh viễn biên bản khỏi hệ thống và không thể khôi phục.
            </p>
            
            <form action="${pageContext.request.contextPath}/staff/violations/delete" method="POST">
                <input type="hidden" name="id" value="${violation.id}">
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-danger py-3 fw-bold rounded-pill shadow-sm">
                        <i class="bi bi-trash3-fill me-2"></i>Xác nhận Xóa
                    </button>
                    <a href="${pageContext.request.contextPath}/staff/violations" class="btn btn-light py-3 fw-bold rounded-pill border">
                        Hủy bỏ
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
