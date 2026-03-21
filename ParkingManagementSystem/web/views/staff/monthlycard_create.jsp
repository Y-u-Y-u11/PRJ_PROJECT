<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card shadow-sm border-success">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">Đăng ký Thẻ tháng mới</h4>
            </div>
            <div class="card-body">
                <!-- Action trỏ về doPost của MonthlyCardController -->
                <form action="${pageContext.request.contextPath}/staff/subscriptions" method="POST">
                    <input type="hidden" name="action" value="add">
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên Khách hàng (Hoặc ID)</label>
                        <input type="text" name="customerName" class="form-control" placeholder="Nhập tên khách hàng..." required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Biển số xe</label>
                        <input type="text" name="licensePlate" class="form-control" placeholder="Ví dụ: 29A-12345" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Ngày bắt đầu</label>
                        <input type="date" name="startDate" class="form-control" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Số tháng đăng ký</label>
                        <input type="number" name="months" class="form-control" value="1" min="1" required>
                    </div>
                    
                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-success">Lưu đăng ký</button>
                        <a href="${pageContext.request.contextPath}/staff/subscriptions" class="btn btn-outline-secondary">Quay lại danh sách</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />