<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Chi tiết Vé xe</h2>
    <a href="${pageContext.request.contextPath}/staff/tickets" class="btn btn-secondary">Quay lại danh sách</a>
</div>

<div class="row">
    <div class="col-md-5">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">Mã vé: ${ticket.ticketCode}</h5>
            </div>
            <div class="card-body">
                <table class="table table-borderless">
                    <tr><th>Biển số:</th><td><strong class="text-uppercase">${ticket.plateNumber != null ? ticket.plateNumber : 'N/A'}</strong></td></tr>
                    <tr><th>Trạng thái:</th>
                        <td>
                            <c:choose>
                                <c:when test="${ticket.status == 'Parking'}"><span class="badge bg-warning text-dark">Đang đỗ</span></c:when>
                                <c:when test="${ticket.status == 'Completed'}"><span class="badge bg-success">Đã hoàn thành</span></c:when>
                                <c:when test="${ticket.status == 'Lost_Ticket'}"><span class="badge bg-danger">Mất vé</span></c:when>
                                <c:when test="${ticket.status == 'Voided'}"><span class="badge bg-secondary">Bị huỷ</span></c:when>
                                <c:otherwise><span class="badge bg-primary">${ticket.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr><th>ID Khách hàng:</th><td>${ticket.customerID != null ? ticket.customerID : 'Khách vãng lai'}</td></tr>
                    <tr><th>Vị trí đỗ (ID):</th><td>${ticket.slotID != null ? ticket.slotID : '--'}</td></tr>
                    <tr><th>Thời gian vào:</th><td>${ticket.checkInTime}</td></tr>
                    <tr><th>Thời gian ra:</th><td>${ticket.checkOutTime != null ? ticket.checkOutTime : '--'}</td></tr>
                </table>
                
                <c:if test="${ticket.status == 'Parking'}">
                    <div class="mt-3 text-center">
                        <a href="${pageContext.request.contextPath}/staff/tickets/checkout?ticketCode=${ticket.ticketCode}" class="btn btn-success w-100">Chuyển đến màn hình Check-out</a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <div class="col-md-7">
        <div class="card shadow-sm">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">Lịch sử Thanh toán Giao dịch</h5>
            </div>
            <div class="card-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Mã GD (ID)</th>
                            <th>Số tiền</th>
                            <th>H.thức</th>
                            <th>Trạng thái</th>
                            <th>Mã đối chiếu</th>
                            <th>Thời gian</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${payments}">
                            <tr>
                                <td>${p.id}</td>
                                <td><strong>${p.amount} VNĐ</strong></td>
                                <td>${p.method}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.status == 'Success'}"><span class="text-success fw-bold">Thành công</span></c:when>
                                        <c:when test="${p.status == 'Failed'}"><span class="text-danger">Thất bại</span></c:when>
                                        <c:when test="${p.status == 'Reversed'}"><span class="text-warning">Hoàn tiền</span></c:when>
                                        <c:otherwise>${p.status}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${p.referenceCode != null ? p.referenceCode : '--'}</td>
                                <td>${p.paidAt}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty payments}">
                            <tr><td colspan="6" class="text-center text-muted">Chưa có giao dịch thanh toán nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />