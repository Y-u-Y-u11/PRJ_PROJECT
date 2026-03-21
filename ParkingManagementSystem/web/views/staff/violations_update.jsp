<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Xử lý Vi phạm #${violation.id}</h2>
        <a href="${pageContext.request.contextPath}/staff/violations" class="btn btn-outline-secondary">Quay lại danh sách</a>
    </div>

    <div class="card shadow-sm border-warning">
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/staff/violations/update" method="POST">
                <!-- ID Vi phạm cần sửa -->
                <input type="hidden" name="id" value="${violation.id}">

                <div class="row">
                    <!-- Read-only fields -->
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted">ID Vé tham chiếu</label>
                        <input type="text" class="form-control bg-light" value="${violation.ticketID != null ? violation.ticketID : 'N/A (Không có vé)'}" readonly disabled>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label text-muted">ID Khách hàng</label>
                        <input type="text" class="form-control bg-light" value="${violation.customerID != null ? violation.customerID : 'N/A'}" readonly disabled>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Lý do vi phạm <span class="text-danger">*</span></label>
                    <textarea class="form-control" name="reason" rows="3" required>${violation.reason}</textarea>
                </div>

                <!-- Gom 3 trường liên quan đến tiền bạc / trạng thái lên cùng 1 hàng -->
                <div class="row align-items-end p-3 bg-light rounded border mb-4">
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Tiền phạt (VNĐ) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control text-danger fw-bold fs-5 border-danger" name="fine" value="${violation.fine}" min="0" required>
                    </div>
                    
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Trạng thái xử lý <span class="text-danger">*</span></label>
                        <select class="form-select border-warning fw-bold" name="status" required>
                            <option value="Unpaid" ${violation.status == 'Unpaid' ? 'selected' : ''}>Chưa thanh toán</option>
                            <option value="Paid" ${violation.status == 'Paid' ? 'selected' : ''}>Đã thanh toán (Nộp phạt)</option>
                            <option value="Voided" ${violation.status == 'Voided' ? 'selected' : ''}>Hủy bỏ (Voided)</option>
                        </select>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold text-success">
                            Hình thức thu <small class="text-muted fw-normal">(Nếu Đã thanh toán)</small>
                        </label>
                        <select name="paymentMethod" class="form-select border-success">
                            <option value="Cash">Tiền mặt (Cash)</option>
                            <option value="Bank_Transfer">Chuyển khoản / QR Code</option>
                            <option value="Card">Thẻ / Card</option>
                        </select>
                    </div>
                </div>

                <div class="mt-2 border-top pt-4 text-end">
                    <a href="${pageContext.request.contextPath}/staff/violations" class="btn btn-light px-4 py-2 me-2">Hủy bỏ</a>
                    <button type="submit" class="btn btn-primary px-5 py-2 fw-bold">Lưu Thay Đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />