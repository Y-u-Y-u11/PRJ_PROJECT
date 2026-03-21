<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row w-100 justify-content-center">
    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Thêm Loại xe mới</h5>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/manager/vehicle-types/create" method="POST">
                    <div class="mb-3">
                        <label class="form-label">Tên Loại xe (VD: Xe máy, Ô tô 4 chỗ)</label>
                        <input type="text" class="form-control" name="name" required autofocus>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Đơn giá / giờ (VNĐ)</label>
                        <input type="number" class="form-control" name="currentPrice" min="0" required>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" name="requiresPlate" id="requiresPlate" checked>
                        <label class="form-check-label" for="requiresPlate">Yêu cầu nhập biển số khi gửi</label>
                    </div>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                    <a href="${pageContext.request.contextPath}/manager/vehicle-types" class="btn btn-secondary">Hủy</a>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
