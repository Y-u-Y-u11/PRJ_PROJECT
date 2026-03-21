<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/views/layout/header.jsp" />

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card shadow-sm border-0 rounded-4 overflow-hidden">
            <div class="card-header bg-white py-3 border-bottom-0">
                <h4 class="mb-0 fw-bold text-gradient">Sửa loại xe</h4>
            </div>
            <div class="card-body p-4">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger rounded-3" role="alert">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/manager/vehicle-types/edit" method="POST">
                    <input type="hidden" name="id" value="${type.id}">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tên loại xe</label>
                        <input type="text" name="name" class="form-control rounded-3 py-2" value="${type.name}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Giá gửi xe hiện tại (giờ)</label>
                        <div class="input-group">
                            <input type="number" step="0.01" name="currentPrice" class="form-control rounded-start-3 py-2" value="${type.currentPrice}" required>
                            <span class="input-group-text rounded-end-3 bg-light px-3 fw-semibold">VNĐ</span>
                        </div>
                    </div>
                    <div class="mb-4 d-flex align-items-center gap-3">
                        <label class="form-label mb-0 fw-semibold">Yêu cầu biển số?</label>
                        <div class="form-check form-switch fs-5">
                            <input class="form-check-input" type="checkbox" name="requiresPlate" value="true" ${type.requiresPlate ? 'checked' : ''}>
                        </div>
                    </div>
                    
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/manager/vehicle-types" class="btn btn-light rounded-3 px-4 flex-grow-1 fw-semibold">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary rounded-3 px-4 flex-grow-1 fw-semibold">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
