<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Danh sách Thẻ tháng (Subscriptions)</h2>
    <!-- Chuyển từ Button Modal sang Link tới trang Create riêng -->
    <a href="${pageContext.request.contextPath}/staff/monthlycard/create" class="btn btn-success">+ Đăng ký Thẻ mới</a>
</div>

<!-- Hiển thị thông báo (Thêm/Sửa/Xóa thành công) -->
<c:if test="${not empty sessionScope.message}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${sessionScope.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="message" scope="session"/>
</c:if>

<!-- Form Tìm kiếm -->
<div class="card shadow-sm mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/staff/monthlycard" method="GET" class="row gx-3 gy-2 align-items-center">
            <div class="col-sm-6">
                <!-- Tên param là 'search' khớp với Controller -->
                <input type="text" name="search" class="form-control" placeholder="Tìm theo ID, Tên KH hoặc Biển số..." value="${searchKeyword}">
            </div>
            <div class="col-sm-2">
                <button type="submit" class="btn btn-primary w-100">Tìm kiếm</button>
            </div>
            <div class="col-sm-2">
                <a href="${pageContext.request.contextPath}/staff/monthlycard" class="btn btn-outline-secondary w-100">Bỏ lọc</a>
            </div>
        </form>
    </div>
</div>

<!-- Bảng hiển thị Dữ liệu -->
<div class="card shadow-sm">
    <div class="card-body">
        <table class="table table-hover table-bordered">
            <thead class="table-light">
                <tr>
                    <!-- Tiêu đề có link để Sắp xếp theo Controller -->
                    <th><a href="?search=${searchKeyword}&sort=cardID&order=${nextOrder}" class="text-decoration-none text-dark">Mã Thẻ</a></th>
                    <th><a href="?search=${searchKeyword}&sort=customerName&order=${nextOrder}" class="text-decoration-none text-dark">Khách hàng</a></th>
                    <th><a href="?search=${searchKeyword}&sort=plateNumber&order=${nextOrder}" class="text-decoration-none text-dark">Biển số</a></th>
                    <th><a href="?search=${searchKeyword}&sort=startDate&order=${nextOrder}" class="text-decoration-none text-dark">Ngày bắt đầu</a></th>
                    <th><a href="?search=${searchKeyword}&sort=endDate&order=${nextOrder}" class="text-decoration-none text-dark">Ngày kết thúc</a></th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${cards}">
                    <tr>
                        <td><strong>${c.cardID}</strong></td>
                        <td>${c.customerName != null ? c.customerName : c.customerID}</td>
                        <td class="text-uppercase">${c.plateNumber != null ? c.plateNumber : c.vehicleID}</td>
                        <td>${c.startDate}</td>
                        <td>${c.endDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${c.status == 'Active'}"><span class="badge bg-success">Hoạt động</span></c:when>
                                <c:when test="${c.status == 'Expired'}"><span class="badge bg-danger">Hết hạn</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">${c.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <!-- Thêm nút Sửa trỏ tới trang Update -->
                            <a href="${pageContext.request.contextPath}/staff/monthlycard/update?id=${c.cardID}" class="btn btn-sm btn-outline-warning me-1">Sửa</a>
                            
                            <!-- Nút Xóa giữ nguyên dạng Form -->
                            <form action="${pageContext.request.contextPath}/staff/monthlycard" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc muốn xóa thẻ này?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="cardID" value="${c.cardID}">
                                <button type="submit" class="btn btn-sm btn-outline-danger">Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty cards}">
                    <tr><td colspan="7" class="text-center text-muted">Không tìm thấy dữ liệu thẻ tháng.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />