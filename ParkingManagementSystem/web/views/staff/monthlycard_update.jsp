<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/views/layout/header.jsp" />

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Cập nhật Thẻ tháng #${card.cardID}</h2>
        <a href="${pageContext.request.contextPath}/staff/monthlycard" class="btn btn-outline-secondary">Quay lại danh sách</a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/staff/monthlycard" method="POST">
                <!-- Sửa action thành edit và thêm cardID ẩn -->
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="cardID" value="${card.cardID}">

                <div class="mb-3">
                    <label class="form-label fw-bold">ID Khách hàng</label>
                    <input type="number" class="form-control" name="customerID" value="${card.customerID}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Loại xe</label>
                    <div class="d-flex gap-4 mt-2">
                        <c:forEach var="vt" items="${vehicleTypes}">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="vehicleTypeID" id="vt_${vt.id}" value="${vt.id}" ${vt.id == card.vehicleTypeID ? 'checked' : ''} required>
                                <label class="form-check-label" for="vt_${vt.id}">
                                    ${vt.name}
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Biển số xe</label>
                    <input type="text" class="form-control text-uppercase" name="plateNumber" value="${card.plateNumber}" required>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Ngày bắt đầu</label>
                        <input type="date" class="form-control" name="startDate" value="${card.startDate}" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Ngày kết thúc</label>
                        <input type="date" class="form-control" name="endDate" value="${card.endDate}" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Trạng thái thẻ</label>
                        <select name="status" class="form-select" required>
                            <option value="Active" ${card.status == 'Active' ? 'selected' : ''}>Hoạt động (Active)</option>
                            <option value="Expired" ${card.status == 'Expired' ? 'selected' : ''}>Hết hạn (Expired)</option>
                            <option value="Cancelled" ${card.status == 'Cancelled' ? 'selected' : ''}>Đã hủy (Cancelled)</option>
                        </select>
                    </div>
                </div>

                <div class="mt-4 border-top pt-3">
                    <button type="submit" class="btn btn-warning px-4 py-2">Lưu Cập nhật</button>
                    <a href="${pageContext.request.contextPath}/staff/monthlycard" class="btn btn-light px-4 py-2 ms-2">Hủy</a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />