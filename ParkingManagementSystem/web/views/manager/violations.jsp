<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Danh sách Vi phạm</h2>
</div>

<div class="card shadow-sm mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/manager/violations" method="GET" class="row gx-3 gy-2 align-items-center">
            <div class="col-sm-5">
                <input type="text" name="keyword" class="form-control" placeholder="Tìm theo lý do vi phạm..." value="${keyword}">
            </div>
            <div class="col-sm-2">
                <button type="submit" class="btn btn-primary w-100">Tìm kiếm</button>
            </div>
            <div class="col-sm-2">
                <a href="${pageContext.request.contextPath}/manager/violations" class="btn btn-outline-secondary w-100">Bỏ lọc</a>
            </div>
        </form>
    </div>
</div>

<div class="card shadow-sm">
    <div class="card-body">
        <table class="table table-hover table-bordered">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Mã Vé</th>
                    <th>ID Khách hàng</th>
                    <th>Lý do</th>
                    <th>Tiền phạt</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="v" items="${violations}">
                    <tr>
                        <td>${v.id}</td>
                        <td>${v.ticketID}</td>
                        <td>${v.customerID}</td>
                        <td>${v.reason}</td>
                        <td>${v.fine} VNĐ</td>
                        <td>
                            <c:choose>
                                <c:when test="${v.status == 'Unpaid'}"><span class="badge bg-warning text-dark">Chưa thanh toán</span></c:when>
                                <c:when test="${v.status == 'Paid'}"><span class="badge bg-success">Đã thanh toán</span></c:when>
                                <c:when test="${v.status == 'Voided'}"><span class="badge bg-secondary">Hủy bỏ</span></c:when>
                            </c:choose>
                        </td>
                        <td>${v.createdAt}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty violations}">
                    <tr><td colspan="7" class="text-center text-muted">Không có dữ liệu vi phạm.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />