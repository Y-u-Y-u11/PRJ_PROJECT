<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Quản lý Loại xe & Giá tiền</h2>
    <a href="${pageContext.request.contextPath}/manager/vehicle-types/create" class="btn btn-primary">Thêm Loại xe</a>
</div>

<div class="card shadow-sm">
    <div class="card-body">
        <table class="table table-hover table-bordered">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Tên Loại xe</th>
                    <th>Đơn giá/giờ</th>
                    <th>Cần biển số</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="v" items="${vehicleTypes}">
                    <tr>
                        <td>${v.id}</td>
                        <td>${v.name}</td>
                        <td>${v.currentPrice} VNĐ</td>
                        <td>
                            <c:choose>
                                <c:when test="${v.requiresPlate}"><span class="badge bg-info">Có</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">Không</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/manager/vehicle-types/update?id=${v.id}" class="btn btn-sm btn-outline-secondary">Cập nhật giá</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty vehicleTypes}">
                    <tr><td colspan="5" class="text-center text-muted">Không có dữ liệu</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />