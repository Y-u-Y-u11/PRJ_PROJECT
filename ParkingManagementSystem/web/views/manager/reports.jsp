<jsp:include page="/views/layout/header.jsp" />

<div class="row">
    <div class="col-md-12 mb-4">
        <h2>Báo cáo hệ thống</h2>
    </div>
    
    <div class="col-md-6 mb-3">
        <div class="card shadow-sm h-100">
            <div class="card-body text-center">
                <h4 class="card-title text-success mb-3">Báo cáo Doanh thu</h4>
                <p class="card-text">Xem tổng hợp doanh thu từ các giao dịch thanh toán thành công, có lọc theo thời gian.</p>
                <a href="${pageContext.request.contextPath}/manager/reports/revenue" class="btn btn-outline-success">Xem Báo cáo Doanh thu</a>
            </div>
        </div>
    </div>

    <div class="col-md-6 mb-3">
        <div class="card shadow-sm h-100">
            <div class="card-body text-center">
                <h4 class="card-title text-primary mb-3">Báo cáo Tình trạng bãi</h4>
                <p class="card-text">Xem chi tiết trạng thái sức chứa, số xe đang đỗ và số ô trống hiện tại.</p>
                <a href="${pageContext.request.contextPath}/manager/reports/parking" class="btn btn-outline-primary">Xem Báo cáo Tình trạng</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
