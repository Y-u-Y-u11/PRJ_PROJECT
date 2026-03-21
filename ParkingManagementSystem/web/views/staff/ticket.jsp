<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="row w-100 justify-content-center">
    <div class="col-md-5">
        <!-- Khung tờ vé -->
        <div class="card shadow border-dark" style="border-style: dashed !important; border-width: 2px !important;">
            <div class="card-header bg-white text-center border-bottom-0 pt-4">
                <h3 class="fw-bold mb-0">VÉ GỬI XE</h3>
                <p class="text-muted small">Bãi đỗ xe thông minh ParkingSystem</p>
            </div>
            <div class="card-body px-5">
                
                <div class="text-center mb-4">
                    <!-- Hiển thị Mã vé to, rõ ràng dạng Monospace -->
                    <span class="d-block text-muted mb-1">Mã thẻ / Ticket Code</span>
                    <h2 class="fw-bold text-success" style="font-family: monospace;">${ticket.ticketCode}</h2>
                </div>

                <table class="table table-borderless table-sm mb-4">
                    <tbody>
                        <tr>
                            <td class="text-muted">Biển số:</td>
                            <td class="text-end fw-bold fs-5 text-uppercase">
                                <c:choose>
                                    <c:when test="${not empty ticket.plateNumber}">${ticket.plateNumber}</c:when>
                                    <c:otherwise><i>(Không có)</i></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted">Loại xe:</td>
                            <td class="text-end fw-bold">${vehicleType.name}</td>
                        </tr>
                        <tr>
                            <td class="text-muted border-bottom pb-2">Vị trí đỗ (Slot):</td>
                            <td class="text-end fw-bold border-bottom pb-2">
                                ${ticket.slotID != null ? ticket.slotID : '<i>Chưa xếp</i>'}
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted pt-2">Giờ vào:</td>
                            <td class="text-end fw-bold pt-2">
                                <!-- Tạo biến thời gian hiện tại nếu ticket.checkInTime bị null -->
                                <jsp:useBean id="now" class="java.util.Date" />
                                <fmt:formatDate value="${ticket.checkInTime != null ? ticket.checkInTime : now}" pattern="dd/MM/yyyy HH:mm:ss" />
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted">Đơn giá cơ bản:</td>
                            <td class="text-end fw-bold text-danger">
                                <fmt:formatNumber value="${vehicleType.currentPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>/lượt
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- Ghi chú luật tính tiền -->
                <div class="alert alert-warning text-center small p-2 mb-0" role="alert">
                    <i class="bi bi-info-circle-fill"></i> 
                    <strong>Lưu ý:</strong> Phí gửi xe sẽ <b>cộng thêm 100%</b> đơn giá nếu thời gian gửi bước sang ngày mới (sau 24:00).
                </div>

            </div>
            
            <!-- Các nút thao tác (Không in ra khi bấm in) -->
            <div class="card-footer bg-white border-top-0 pb-4 text-center d-print-none">
                <button onclick="window.print()" class="btn btn-primary px-4"><i class="bi bi-printer"></i> In Vé</button>
                <a href="${pageContext.request.contextPath}/staff/tickets/checkin" class="btn btn-outline-secondary px-4 ms-2">Tạo vé khác</a>
                <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-link d-block mt-3 text-decoration-none">Về trang chủ</a>
            </div>
        </div>
    </div>
</div>

<!-- CSS siêu nhỏ để giấu các thành phần không cần thiết khi bấm "In Vé" (Ctrl+P) -->
<style>
    @media print {
        body * { visibility: hidden; }
        .card, .card * { visibility: visible; }
        .card { position: absolute; left: 0; top: 0; width: 100%; border: none !important; box-shadow: none !important; }
        .d-print-none { display: none !important; }
    }
</style>

<jsp:include page="/views/layout/footer.jsp" />