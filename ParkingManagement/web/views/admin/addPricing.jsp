<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Quy Tắc Giá - Parking Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
        <style>
            .required-asterisk {
                color: red;
            }
        </style>
    </head>
    <body class="bg-light">
        <!-- Header + Sidebar -->
        <jsp:include page="../header.jsp" />
        <jsp:include page="../sidebar.jsp" />

        <!-- Main content -->
        <div class="container mt-4 mb-5" style="max-width: 600px;">
            <div class="bg-white p-4 rounded shadow-sm">
                <h4 class="mb-4 fw-bold text-dark border-bottom pb-2">Thêm Quy Tắc Giá Mới</h4>

                <!-- Flash messages -->
                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="message" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/pricing/add" method="POST">
                    <input type="hidden" name="action" value="add">

                    <div class="mb-3">
                        <label class="form-label fw-medium text-dark">Loại xe (Mã Type) <span class="required-asterisk">*</span></label>
                        <select name="typeID" class="form-select" required>
                            <option value="1">Ô Tô (1)</option>
                            <option value="2">Xe Máy (2)</option>
                            <option value="3">Xe Đạp (3)</option>
                        </select>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label fw-medium text-dark">Từ giờ (0-24) <span class="required-asterisk">*</span></label>
                            <input type="number" name="startHour" class="form-control" placeholder="VD: 0" min="0" max="24" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-medium text-dark">Đến giờ (0-24) <span class="required-asterisk">*</span></label>
                            <input type="number" name="endHour" class="form-control" placeholder="VD: 24" min="0" max="24" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-medium text-dark">Giá tiền (VNĐ) <span class="required-asterisk">*</span></label>
                        <div class="input-group">
                            <input type="number" name="price" class="form-control" placeholder="VD: 15000" min="0" step="1000" required>
                            <span class="input-group-text bg-light fw-bold text-muted">VNĐ</span>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/admin/pricing" class="btn btn-light border px-4">Hủy</a>
                        <input type="submit" class="btn btn-navy px-4" value="Lưu">
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
