<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />

<div class="row">
    <div class="col-md-12 mb-4">
        <h2>Tổng quan Bãi đỗ xe</h2>
    </div>
    
    <div class="col-md-3">
        <div class="card bg-primary text-white text-center mb-3 shadow-sm">
            <div class="card-body">
                <h5 class="card-title">Tổng số Ô đỗ</h5>
                <h2 class="display-4">${totalSlots}</h2>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-success text-white text-center mb-3 shadow-sm">
            <div class="card-body">
                <h5 class="card-title">Ô đang trống</h5>
                <h2 class="display-4">${availableSlots}</h2>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-danger text-white text-center mb-3 shadow-sm">
            <div class="card-body">
                <h5 class="card-title">Ô đang sử dụng</h5>
                <h2 class="display-4">${occupiedSlots}</h2>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-warning text-dark text-center mb-3 shadow-sm">
            <div class="card-body">
                <h5 class="card-title">Vé đang hoạt động</h5>
                <h2 class="display-4">${activeTickets}</h2>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />