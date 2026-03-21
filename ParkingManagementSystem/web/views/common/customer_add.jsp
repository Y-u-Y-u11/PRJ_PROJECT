<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/views/layout/header.jsp"/>

<div class="container py-5 animate-fade-in">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm border-0" style="border-radius: 1.5rem; overflow: hidden;">
                <div class="card-header bg-white border-0 pt-4 px-4 pb-2">
                    <div class="d-flex align-items-center mb-2">
                        <div class="bg-soft-primary p-2 rounded-3 me-3" style="background-color: rgba(139, 92, 246, 0.1);">
                            <i class="bi bi-person-plus-fill text-primary fs-4"></i>
                        </div>
                        <h3 class="mb-0 fw-bold">Thêm khách hàng mới</h3>
                    </div>
                    <p class="text-muted small px-1">Nhập thông tin chi tiết của khách hàng để lưu vào hệ thống.</p>
                </div>
                
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger bg-danger bg-opacity-10 text-danger mb-4" role="alert">
                            <i class="bi bi-exclamation-circle me-2"></i>
                            <c:out value="${error}"/>
                        </div>
                    </c:if>
                    
                    <form action="" method="POST">
                        <div class="mb-4">
                            <label for="name" class="form-label fw-semibold text-secondary small text-uppercase ls-1">Họ và tên</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="bi bi-person text-muted"></i>
                                </span>
                                <input type="text" class="form-control border-start-0" id="name" name="name" 
                                       placeholder="Ví dụ: Nguyễn Văn A" required autofocus>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <label for="phone" class="form-label fw-semibold text-secondary small text-uppercase ls-1">Số điện thoại</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="bi bi-phone text-muted"></i>
                                </span>
                                <input type="tel" class="form-control border-start-0" id="phone" name="phone" 
                                       placeholder="Ví dụ: 0912345678" required>
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                            <a href="${pageContext.request.contextPath}/${sessionScope.LOGIN_USER.role}/customers" 
                               class="btn btn-light px-4 py-2 fw-semibold text-muted" style="border-radius: 0.75rem;">
                                Hủy bỏ
                            </a>
                            <button type="submit" class="btn btn-primary px-5 py-2 fw-bold" style="border-radius: 0.75rem;">
                                Lưu khách hàng
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="text-center mt-4">
                <p class="text-muted small">
                    <i class="bi bi-shield-check me-1 text-success"></i> 
                    Dữ liệu sẽ được bảo mật trong hệ thống quản lý.
                </p>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp"/>
