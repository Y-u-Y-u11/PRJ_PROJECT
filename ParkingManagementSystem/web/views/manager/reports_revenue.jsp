<jsp:include page="/views/layout/header.jsp" />

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Báo cáo Doanh thu</h2>
    <a href="${pageContext.request.contextPath}/manager/reports" class="btn btn-secondary">Quay lại</a>
</div>

<div class="card shadow-sm">
    <div class="card-body text-center py-5">
        <h3 class="text-muted">Tổng doanh thu hệ thống</h3>
        <h1 class="display-3 text-success fw-bold">${totalRevenue} VNĐ</h1>
        <p class="text-muted mt-3">Đây là báo cáo tổng hợp nhanh. Sắp tới sẽ hỗ trợ bộ lọc theo ngày/tháng/năm.</p>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
