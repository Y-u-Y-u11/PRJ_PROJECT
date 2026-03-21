<jsp:include page="/views/layout/header.jsp" />

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Báo cáo Tình trạng Bãi đỗ</h2>
    <a href="${pageContext.request.contextPath}/manager/reports" class="btn btn-secondary">Quay lại</a>
</div>

<div class="row text-center mt-4">
    <div class="col-md-4">
        <div class="card shadow border-info mb-3">
            <div class="card-body">
                <h4 class="text-info">Tổng Số Ô</h4>
                <h1 class="display-4">${total}</h1>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card shadow border-danger mb-3">
            <div class="card-body">
                <h4 class="text-danger">Đang Sử Dụng</h4>
                <h1 class="display-4">${occupied}</h1>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card shadow border-success mb-3">
            <div class="card-body">
                <h4 class="text-success">Còn Trống</h4>
                <h1 class="display-4">${available}</h1>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
