<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row w-100 justify-content-center">
    <div class="col-md-6">
        <div class="card shadow border-success mb-4">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">Thanh toán Check-out Vé: ${ticket.ticketCode}</h5>
            </div>
            <div class="card-body">
                <table class="table table-borderless">
                    <tr><th>Biển số xe:</th><td>${ticket.plateNumber}</td></tr>
                    <tr><th>Loại xe:</th><td>${vehicleType.name} (${vehicleType.currentPrice} VNĐ/h)</td></tr>
                    <tr><th>Giờ vào:</th><td>${ticket.checkInTime}</td></tr>
                    <tr><th>Thời gian đỗ:</th><td>${hours} giờ</td></tr>
                </table>
                <hr>
                <div class="d-flex justify-content-between align-items-center bg-light p-3 rounded mb-3">
                    <h5 class="mb-0">Tổng phí (Dự kiến):</h5>
                    <h3 class="text-success mb-0 fw-bold">${calculatedFee} VNĐ</h3>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/staff/payments/process" method="POST">
                    <input type="hidden" name="ticketId" value="${ticket.id}">
                    <input type="hidden" name="amount" value="${calculatedFee}">
                    
                    <div class="mb-3">
                        <label class="form-label">Phương thức Thanh toán</label>
                        <select name="method" class="form-select" required>
                            <option value="Cash">Tiền mặt (Cash)</option>
                            <option value="Bank_Transfer">Chuyển khoản / QR Code</option>
                            <option value="Card">Thẻ / Card</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100 py-2 fs-5">Xác nhận Thanh toán & Hoàn thành Check-out</button>
                    <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-outline-secondary w-100 mt-2">Hủy Check-out</a>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
