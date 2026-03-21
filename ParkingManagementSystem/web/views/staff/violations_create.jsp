<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row w-100 justify-content-center">
    <div class="col-md-6">
        <div class="card shadow border-danger mb-4">
            <div class="card-header bg-danger text-white">
                <h5 class="mb-0">Lập biên bản vi phạm</h5>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/staff/violations/create" method="POST">
                    <c:if test="${ticket != null}">
                        <input type="hidden" name="ticketId" value="${ticket.id}">
                        <div class="alert alert-info">Ghi nhận vi phạm cho vé: <strong>${ticket.ticketCode}</strong> (Biển số: ${ticket.plateNumber})</div>
                    </c:if>

                    <h6 class="mb-3 border-bottom pb-2">Thông tin Khách hàng (Bắt buộc)</h6>
                    <div class="mb-3">
                        <label class="form-label">Họ tên</label>
                        <input type="text" class="form-control" name="customerName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">SĐT</label>
                        <input type="text" class="form-control" name="customerPhone" required>
                    </div>

                    <h6 class="mb-3 border-bottom pb-2 mt-4">Chi tiết Vi phạm</h6>
                    <div class="mb-3">
                        <label class="form-label">Lý do</label>
                        <textarea class="form-control" name="reason" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tiền phạt (VNĐ)</label>
                        <input type="number" class="form-control" name="fine" min="0" required>
                    </div>
                    
                    <button type="submit" class="btn btn-danger w-100 py-2 fs-5">Lưu Vi phạm</button>
                    <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-outline-secondary w-100 mt-2">Hủy</a>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />