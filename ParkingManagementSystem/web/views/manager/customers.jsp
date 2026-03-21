<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Danh sách Khách hàng</h2>
</div>

<div class="card shadow-sm mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/manager/customers" method="GET" class="d-flex w-50">
            <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm tên hoặc SĐT" value="<c:out value='${keyword}'/>">
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            <a href="${pageContext.request.contextPath}/manager/customers" class="btn btn-outline-secondary ms-2">Bỏ lọc</a>
        </form>
    </div>
</div>

<div class="card shadow-sm">
    <div class="card-body">
        <table class="table table-hover table-bordered">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Họ tên</th>
                    <th>Số điện thoại</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${customers}">
                    <tr>
                        <td>${c.id}</td>
                        <td>${c.name}</td>
                        <td>${c.phone}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/manager/customers/view?id=${c.id}" class="btn btn-sm btn-outline-info">Xem chi tiết</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty customers}">
                    <tr><td colspan="4" class="text-center text-muted">Không tìm thấy khách hàng nào</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
