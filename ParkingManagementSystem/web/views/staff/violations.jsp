<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Danh sách Vi phạm</h2>
    <a href="${pageContext.request.contextPath}/staff/violations/create" class="btn btn-danger">+ Lập biên bản mới</a>
</div>

<!-- Thông báo thao tác -->
<c:if test="${param.msg == 'success'}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        Lập biên bản vi phạm thành công!
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'update_success'}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        Cập nhật biên bản thành công!
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'delete_success'}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        Đã xóa biên bản vi phạm!
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
<c:if test="${param.msg == 'delete_fail'}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        Không thể xóa biên bản này. Vui lòng kiểm tra lại.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<div class="card shadow-sm mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/staff/violations" method="GET" class="row gx-3 gy-2 align-items-center">
            <div class="col-sm-6">
                <input type="text" name="keyword" class="form-control" placeholder="Tìm theo lý do vi phạm..." value="${keyword}">
            </div>
            <div class="col-sm-2">
                <button type="submit" class="btn btn-primary w-100">Tìm kiếm</button>
            </div>
            <div class="col-sm-2">
                <a href="${pageContext.request.contextPath}/staff/violations" class="btn btn-outline-secondary w-100">Bỏ lọc</a>
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
                        <th>ID</th>
                        <th>Mã Vé (ID)</th>
                        <th>ID Khách hàng</th>
                        <th>Lý do</th>
                        <th>Tiền phạt</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="v" items="${violations}">
                        <tr>
                            <td><strong>#${v.id}</strong></td>
                            <td>${v.ticketID != null ? v.ticketID : '--'}</td>
                            <td>${v.customerID != null ? v.customerID : '--'}</td>
                            <td>${v.reason}</td>
                            <td class="text-danger fw-bold">${v.fine} VNĐ</td>
                            <td>
                                <c:choose>
                                    <c:when test="${v.status == 'Unpaid'}"><span class="badge bg-warning text-dark">Chưa thanh toán</span></c:when>
                                    <c:when test="${v.status == 'Paid'}"><span class="badge bg-success">Đã thanh toán</span></c:when>
                                    <c:when test="${v.status == 'Voided'}"><span class="badge bg-secondary">Hủy bỏ</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">${v.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>${v.createdAt}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/staff/violations/update?id=${v.id}" class="btn btn-sm btn-outline-warning">Sửa</a>
                                <a href="${pageContext.request.contextPath}/staff/violations/delete?id=${v.id}" class="btn btn-sm btn-outline-danger">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty violations}">
                        <tr><td colspan="8" class="text-center text-muted py-3">Không tìm thấy dữ liệu vi phạm nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />