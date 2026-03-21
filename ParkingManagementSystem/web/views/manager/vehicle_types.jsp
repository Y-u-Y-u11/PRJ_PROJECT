<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="animate-fade-in">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0 fw-bold text-gradient">Loại xe & Giá tiền</h2>
            <p class="text-muted small mb-0">Quản lý các loại phương tiện và thiết lập đơn giá gửi xe.</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/vehicle-types/create" class="btn btn-primary shadow-sm px-4 py-2 rounded-3 fw-bold">
            <i class="bi bi-plus-circle me-1"></i>Thêm Loại xe
        </a>
    </div>

    <c:if test="${param.success == 'updated'}">
        <div class="alert alert-success bg-success bg-opacity-10 text-success border-0 mb-4 animate-fade-in" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            Cập nhật loại xe thành công!
        </div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
        <div class="alert alert-success bg-success bg-opacity-10 text-success border-0 mb-4 animate-fade-in" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            Xóa loại xe thành công!
        </div>
    </c:if>

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
                        <td class="text-center">
                            <div class="d-flex justify-content-center gap-2">
                                <a href="${pageContext.request.contextPath}/manager/vehicle-types/edit?id=${v.id}" class="btn btn-sm btn-outline-primary rounded-3 px-3">
                                    <i class="bi bi-pencil-square me-1"></i>Sửa
                                </a>
                                <a href="${pageContext.request.contextPath}/manager/vehicle-types/delete?id=${v.id}" class="btn btn-sm btn-outline-danger rounded-3 px-3">
                                    <i class="bi bi-trash me-1"></i>Xóa
                                </a>
                            </div>
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