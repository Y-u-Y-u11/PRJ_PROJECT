<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Danh sách Thẻ tháng (Subscriptions)</h2>
    <a href="${pageContext.request.contextPath}/staff/monthlycard/create" class="btn btn-success">+ Đăng ký Thẻ mới</a>
</div>

<c:if test="${param.success eq 'deleted'}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        Xóa thẻ tháng thành công!
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<c:if test="${not empty sessionScope.message}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${sessionScope.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="message" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${sessionScope.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="error" scope="session"/>
</c:if>

<div class="card shadow-sm mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/staff/monthlycard" method="GET" class="row gx-3 gy-2 align-items-center">
            <div class="col-sm-6">
                <input type="text" name="search" class="form-control" placeholder="Tìm theo Mã thẻ, Tên KH hoặc Biển số..." value="${searchKeyword}">
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

<div class="card shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover table-bordered align-middle">
                <thead class="table-light">
                    <tr>
                        <th><a href="?search=${searchKeyword}&sort=cardID&order=${nextOrder}" class="text-decoration-none text-dark">Mã Thẻ</a></th>
                        <th><a href="?search=${searchKeyword}&sort=customerName&order=${nextOrder}" class="text-decoration-none text-dark">Khách hàng</a></th>
                        <th><a href="?search=${searchKeyword}&sort=vehicleType&order=${nextOrder}" class="text-decoration-none text-dark">Loại xe</a></th>
                        <th><a href="?search=${searchKeyword}&sort=plateNumber&order=${nextOrder}" class="text-decoration-none text-dark">Biển số</a></th>
                        <th><a href="?search=${searchKeyword}&sort=startDate&order=${nextOrder}" class="text-decoration-none text-dark">Thời hạn</a></th>
                        <th>Giá tiền</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${cards}">
                        <tr>
                            <td><strong>#${c.cardID}</strong></td>
                            <td>${c.customerName != null ? c.customerName : c.customerID}</td>
                            <td>${c.vehicleTypeName}</td>
                            <td class="text-uppercase fw-bold text-primary">${c.plateNumber}</td>
                            <td>
                                <small class="text-muted">Từ:</small> ${c.startDate}<br>
                                <small class="text-muted">Đến:</small> <span class="text-danger">${c.endDate}</span>
                            </td>
                            <td>
                                <!-- Định dạng tiền tệ VNĐ -->
                                <fmt:formatNumber value="${c.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.status == 'Active'}"><span class="badge bg-success">Hoạt động</span></c:when>
                                    <c:when test="${c.status == 'Expired'}"><span class="badge bg-danger">Hết hạn</span></c:when>
                                    <c:when test="${c.status == 'Cancelled'}"><span class="badge bg-secondary">Đã hủy</span></c:when>
                                    <c:otherwise><span class="badge bg-dark">${c.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/staff/monthlycard/update?id=${c.cardID}" class="btn btn-sm btn-outline-warning">Sửa</a>
                                
                                <!-- Logic kiểm tra nếu Active thì hiển thị nút xóa dạng disable/cảnh báo -->
                                <a href="${pageContext.request.contextPath}/staff/monthlycard/delete?id=${c.cardID}" class="btn btn-sm btn-outline-danger">Xóa</a>
                                
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty cards}">
                        <tr><td colspan="8" class="text-center text-muted py-3">Không tìm thấy dữ liệu thẻ tháng.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />