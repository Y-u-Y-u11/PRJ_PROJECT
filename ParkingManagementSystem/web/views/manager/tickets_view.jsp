<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row">
    <div class="col-md-5">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">Chi tiết Vé xe: ${ticket.ticketCode}</h5>
            </div>
            <div class="card-body">
                <table class="table table-borderless">
                    <tr><th>Biển số:</th><td>${ticket.plateNumber}</td></tr>
                    <tr><th>Trạng thái:</th><td><span class="badge bg-primary">${ticket.status}</span></td></tr>
                    <tr><th>ID Khách hàng:</th><td>${ticket.customerID}</td></tr>
                    <tr><th>ID ô đỗ:</th><td>${ticket.slotID}</td></tr>
                    <tr><th>T/G Vào:</th><td>${ticket.checkInTime}</td></tr>
                    <tr><th>T/G Ra:</th><td>${ticket.checkOutTime}</td></tr>
                </table>
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
                                <td>${p.amount} VNĐ</td>
                                <td>${p.method}</td>
                                <td>${p.status}</td>
                                <td>${p.referenceCode}</td>
                                <td>${p.paidAt}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty payments}">
                            <tr><td colspan="6" class="text-center">Chưa có giao dịch thanh toán nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />