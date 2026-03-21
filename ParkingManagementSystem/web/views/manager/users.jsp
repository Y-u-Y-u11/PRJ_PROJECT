<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Quản lý Nhân viên (Staff)</h2>
    <a href="${pageContext.request.contextPath}/manager/users/create" class="btn btn-primary">Thêm Nhân viên</a>
</div>

<div class="card shadow-sm">
    <div class="card-body">
        <table class="table table-hover table-bordered">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Tài khoản</th>
                    <th>Họ tên</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="s" items="${staffList}">
                    <tr>
                        <td>${s.id}</td>
                        <td>${s.username}</td>
                        <td>${s.fullName}</td>
                        <td>
                            <c:choose>
                                <c:when test="${s.status == 'active'}"><span class="badge bg-success">Hoạt động</span></c:when>
                                <c:otherwise><span class="badge bg-danger">Vô hiệu hóa</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/manager/users/update?id=${s.id}" class="btn btn-sm btn-outline-secondary">Sửa</a>
                            <form action="${pageContext.request.contextPath}/manager/users/delete" method="POST" class="d-inline" onsubmit="return confirm('Chắc chắn xóa?');">
                                <input type="hidden" name="id" value="${s.id}">
                                <button type="submit" class="btn btn-sm btn-outline-danger">Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty staffList}">
                    <tr><td colspan="5" class="text-center text-muted">Không có dữ liệu</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />