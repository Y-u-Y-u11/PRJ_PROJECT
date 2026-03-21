<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Quản lý Ô đỗ xe</h2>
    <a href="${pageContext.request.contextPath}/manager/slots/create" class="btn btn-primary">Thêm Ô đỗ</a>
</div>

<div class="card shadow-sm">
    <div class="card-body">
        <table class="table table-hover table-bordered">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Mã Ô (Code)</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="s" items="${slots}">
                    <tr>
                        <td>${s.id}</td>
                        <td><strong>${s.code}</strong></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/manager/slots/update?id=${s.id}" class="btn btn-sm btn-outline-secondary">Sửa</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty slots}">
                    <tr><td colspan="3" class="text-center text-muted">Không có dữ liệu</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />