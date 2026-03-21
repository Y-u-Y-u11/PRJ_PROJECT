<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/views/layout/header.jsp" />

<div class="animate-fade-in d-flex justify-content-center align-items-center" style="min-height: 70vh;">
    <div class="card shadow-lg border-0" style="max-width: 550px; border-radius: 1.5rem;">
        <div class="card-body p-5 text-center">
            <div class="mb-4 text-warning">
                <i class="bi bi-shield-exclamation" style="font-size: 4rem;"></i>
            </div>
            
            <h2 class="fw-bold mb-3">Xác nhận xóa thẻ tháng?</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger bg-danger bg-opacity-10 text-danger border-0 small mb-4 text-start">
                    <i class="bi bi-x-circle-fill me-2"></i>${error}
                </div>
            </c:if>
            
            <p class="text-muted mb-4">
                Bạn đang thực hiện xóa thẻ tháng mã số <span class="fw-bold text-primary">#${card.cardID}</span>.
                <br>Chủ thẻ: <span class="fw-bold text-dark">${card.customerName}</span>
            </p>
            
            <div class="bg-light p-3 rounded-3 mb-4 text-start small border">
                <p class="mb-2 text-secondary fw-bold"><i class="bi bi-card-list me-2"></i>Chi tiết thẻ:</p>
                <div class="row g-2">
                    <div class="col-6 text-muted">Biển số:</div>
                    <div class="col-6 fw-bold text-end">${card.plateNumber}</div>
                    <div class="col-6 text-muted">Loại xe:</div>
                    <div class="col-6 text-end">${card.vehicleTypeName}</div>
                    <div class="col-6 text-muted">Ngày hết hạn:</div>
                    <div class="col-6 text-end text-danger">${card.endDate}</div>
                    <div class="col-6 text-muted">Trạng thái hiện tại:</div>
                    <div class="col-6 text-end">
                        <span class="badge ${card.status == 'Active' ? 'bg-success' : 'bg-secondary'}">${card.status}</span>
                    </div>
                </div>
            </div>
            
            <div class="alert alert-info bg-info bg-opacity-10 text-info border-0 small mb-4 text-start">
                <i class="bi bi-info-circle-fill me-2"></i>
                Lưu ý: Chỉ có thể xóa các thẻ đã hết hạn hoặc đã bị hủy. Đối với thẻ đang hoạt động (Active), vui lòng "Hủy" thẻ trước khi xóa.
            </div>
            
            <form action="${pageContext.request.contextPath}/staff/monthlycard" method="POST">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="cardID" value="${card.cardID}">
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-danger py-3 fw-bold rounded-pill shadow-sm" ${card.status == 'Active' ? 'disabled' : ''}>
                        <i class="bi bi-trash-fill me-2"></i>Xác nhận Xóa
                    </button>
                    <a href="${pageContext.request.contextPath}/staff/monthlycard" class="btn btn-light py-3 fw-bold rounded-pill border">
                        Quay lại danh sách
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
