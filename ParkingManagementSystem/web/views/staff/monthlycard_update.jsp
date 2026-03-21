<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card shadow-sm border-warning">
            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">Cập nhật thông tin Thẻ tháng</h4>
            </div>
            <div class="card-body">
                <!-- Action trỏ về doPost của MonthlyCardController -->
                <form action="${pageContext.request.contextPath}/staff/subscriptions" method="POST">
                    <input type="hidden" name="action" value="edit">
                    <!-- cardID bắt buộc phải có để backend nhận diện thẻ cần update -->
                    <input type="hidden" name="cardID" value="${card.cardID}">
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Mã Khách hàng (CustomerID)</label>
                        <input type="text" name="customerID" class="form-control" value="${card.customerID}" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Mã Xe (VehicleID)</label>
                        <input type="text" name="vehicleID" class="form-control" value="${card.vehicleID}" required>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Ngày bắt đầu</label>
                            <input type="date" name="startDate" class="form-control" value="${card.startDate}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Ngày kết thúc</label>
                            <input type="date" name="endDate" class="form-control" value="${card.endDate}" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="Active" <c:if test="${card.status == 'Active'}">selected</c:if>>Hoạt động (Active)</option>
                            <option value="Expired" <c:if test="${card.status == 'Expired'}">selected</c:if>>Hết hạn (Expired)</option>
                            <option value="Cancelled" <c:if test="${card.status == 'Cancelled'}">selected</c:if>>Đã hủy (Cancelled)</option>
                        </select>
                    </div>
                    
                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-warning">Lưu thay đổi</button>
                        <a href="${pageContext.request.contextPath}/staff/subscriptions" class="btn btn-outline-secondary">Quay lại danh sách</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />