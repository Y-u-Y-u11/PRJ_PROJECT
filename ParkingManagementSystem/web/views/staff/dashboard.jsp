<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/views/layout/header.jsp" />

<div class="row">
    <div class="col-md-12 mb-4">
        <h2>Trạm Gác - Nhân viên</h2>
    </div>
    
    <div class="col-md-4">
        <div class="card bg-success text-white text-center mb-3 shadow-sm">
            <div class="card-body">
                <h5 class="card-title">Check-in Xe Mới</h5>
                <p>Mở phiên đỗ xe và cấp vé cho khách.</p>
                <a href="${pageContext.request.contextPath}/staff/tickets/checkin" class="btn btn-light">Đi đến Check-in</a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card bg-warning text-dark text-center mb-3 shadow-sm">
            <div class="card-body">
                <h5 class="card-title">Check-out Thu Phí</h5>
                <p>Khép phiên đỗ xe và thanh toán.</p>
                <a href="${pageContext.request.contextPath}/staff/tickets/checkout" class="btn btn-dark">Đi đến Check-out</a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card bg-info text-white text-center mb-3 shadow-sm">
            <div class="card-body">
                <h5 class="card-title">Tìm kiếm Xe</h5>
                <p>Tra cứu tình trạng vé qua biển số.</p>
                <a href="${pageContext.request.contextPath}/staff/tickets/search" class="btn btn-light">Đi đến Tìm kiếm</a>
            </div>
        </div>
    </div>
</div>

<div class="row mt-4">
    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-body text-center">
                <h5>Tổng số ô đang trống: <span class="text-success display-6">${availableSlots}</span></h5>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-body text-center">
                <h5>Tổng xe đang đỗ (Vé Active): <span class="text-primary display-6">${activeTickets}</span></h5>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />