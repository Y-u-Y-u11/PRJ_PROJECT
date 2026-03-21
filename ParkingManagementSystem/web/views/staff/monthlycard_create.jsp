<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/views/layout/header.jsp" />

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Đăng ký Thẻ tháng mới</h2>
        <a href="${pageContext.request.contextPath}/staff/monthlycard" class="btn btn-outline-secondary">Quay lại danh sách</a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/staff/monthlycard" method="POST">
                <input type="hidden" name="action" value="add">

                <div class="mb-3">
                    <label class="form-label fw-bold">ID Khách hàng</label>
                    <input type="number" class="form-control" name="customerID" placeholder="Nhập mã ID của khách hàng" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Loại xe</label>
                    <div class="d-flex gap-4 mt-2">
                        <c:forEach var="vt" items="${vehicleTypes}">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="vehicleTypeID" id="vt_${vt.id}" value="${vt.id}" required>
                                <label class="form-check-label" for="vt_${vt.id}">
                                    ${vt.name}
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Biển số xe</label>
                    <input type="text" class="form-control text-uppercase" name="plateNumber" placeholder="VD: 29A-123.45" required>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Ngày bắt đầu</label>
                        <input type="date" class="form-control" name="startDate" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Số tháng đăng ký</label>
                        <input type="number" class="form-control" name="months" value="1" min="1" required>
                        <small class="text-danger mt-1 d-block">
                            * Giá tiền sẽ được hệ thống tự động tính: (Giá mặc định của loại xe) x 20 x (Số tháng).
                        </small>
                    </div>
                </div>

                <div class="mt-4 border-top pt-3">
                    <button type="submit" class="btn btn-success px-4 py-2">Xác nhận Đăng ký</button>
                    <button type="reset" class="btn btn-light px-4 py-2 ms-2">Làm mới</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />