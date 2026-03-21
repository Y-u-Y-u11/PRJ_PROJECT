<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />

<div class="animate-fade-in">
    <div class="mb-4">
        <h2 class="mb-1">Báo cáo hệ thống</h2>
        <p class="text-muted">Phân tích dữ liệu và theo dõi hoạt động bãi đỗ xe</p>
    </div>
    
    <div class="row g-4">
        <!-- Revenue Report Card -->
        <div class="col-md-6 col-lg-4">
            <div class="card h-100 border-0 shadow-sm report-card">
                <div class="card-body p-4 text-center">
                    <div class="icon-box bg-soft-success text-success rounded-circle mx-auto mb-3 d-flex align-items-center justify-content-center" style="width: 64px; height: 64px;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-cash-stack" viewBox="0 0 16 16">
                          <path d="M1 3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1H1zm7 8a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/>
                          <path d="M0 5a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1V5zm3 0a2 2 0 0 1-2 2v4a2 2 0 0 1 2 2h10a2 2 0 0 1 2-2V7a2 2 0 0 1-2-2H3z"/>
                        </svg>
                    </div>
                    <h4 class="card-title fw-bold text-dark mb-3">Doanh thu</h4>
                    <p class="card-text text-muted small mb-4">Tổng hợp các giao dịch thanh toán thành công, lọc theo thời gian cụ thể.</p>
                    <a href="${pageContext.request.contextPath}/manager/reports/revenue" class="btn btn-success w-100 rounded-pill shadow-sm">Xem Báo cáo</a>
                </div>
            </div>
        </div>

        <!-- Parking Status Card -->
        <div class="col-md-6 col-lg-4">
            <div class="card h-100 border-0 shadow-sm report-card">
                <div class="card-body p-4 text-center">
                    <div class="icon-box bg-soft-primary text-primary rounded-circle mx-auto mb-3 d-flex align-items-center justify-content-center" style="width: 64px; height: 64px;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-p-square-fill" viewBox="0 0 16 16">
                          <path d="M8.27 8.074c.893 0 1.419-.545 1.419-1.488s-.526-1.482-1.42-1.482H6.778v2.97H8.27Z"/>
                          <path d="M2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2Zm3.5 4.04h3.11c1.596 0 2.486 1.016 2.486 2.434 0 1.452-.908 2.498-2.493 2.498H6.778V12H5.5V4.04Z"/>
                        </svg>
                    </div>
                    <h4 class="card-title fw-bold text-dark mb-3">Tình trạng bãi</h4>
                    <p class="card-text text-muted small mb-4">Sức chứa tổng thể, số xe hiện tại và các ô đỗ xe còn trống.</p>
                    <a href="${pageContext.request.contextPath}/manager/reports/parking" class="btn btn-primary w-100 rounded-pill shadow-sm">Xem Tình trạng</a>
                </div>
            </div>
        </div>

        <!-- Audit Log Card -->
        <div class="col-md-6 col-lg-4">
            <div class="card h-100 border-0 shadow-sm report-card border-bottom border-danger">
                <div class="card-body p-4 text-center">
                    <div class="icon-box bg-soft-danger text-danger rounded-circle mx-auto mb-3 d-flex align-items-center justify-content-center" style="width: 64px; height: 64px;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-clock-history" viewBox="0 0 16 16">
                          <path d="M8.515 1.019A7 7 0 0 0 8 1V0a8 8 0 0 1 .589.022l-.074.997zm2.004.45a7.003 7.003 0 0 0-.985-.299l.219-.976c.383.086.76.2 1.126.342l-.36.933zm1.37.71a7.01 7.01 0 0 0-.439-.24l.493-.87a8.025 8.025 0 0 1 .979.654l-.615.789a6.996 6.996 0 0 0-.418-.333zM16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0z"/>
                          <path d="M8 4.5a.5.5 0 0 1 .5.5v2.5h2.5a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5v-3a.5.5 0 0 1 .5-.5z"/>
                        </svg>
                    </div>
                    <h4 class="card-title fw-bold text-dark mb-3">Nhật ký hệ thống</h4>
                    <p class="card-text text-muted small mb-4">Lịch sử thao tác dữ liệu chi tiết của nhân viên và quản trị viên.</p>
                    <a href="${pageContext.request.contextPath}/admin/audit" class="btn btn-danger w-100 rounded-pill shadow-sm">Xem Nhật ký</a>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .report-card {
        transition: all 0.3s ease;
        border-top: 4px solid transparent !important;
    }
    .report-card:hover {
        transform: translateY(-10px);
        border-top: 4px solid var(--primary) !important;
    }
    .icon-box {
        transition: all 0.3s ease;
    }
    .report-card:hover .icon-box {
        transform: rotate(15deg) scale(1.1);
    }
</style>

<jsp:include page="/views/layout/footer.jsp" />