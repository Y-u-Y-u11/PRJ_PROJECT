<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Nhân Viên Mới - Parking Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <style>
        .required-asterisk { color: red; }
    </style>
</head>
<body class="bg-light">
    <!-- Header + Sidebar -->
    <jsp:include page="../header.jsp" />
    <jsp:include page="../sidebar.jsp" />

    <!-- Main content -->
    <div class="container mt-4 mb-5" style="max-width: 600px;">
        <div class="bg-white p-4 rounded shadow-sm">
            <h4 class="mb-4 fw-bold text-dark border-bottom pb-2">Thêm Nhân Viên Mới</h4>

            <form action="${pageContext.request.contextPath}/admin/staffManagement" method="POST">
                <input type="hidden" name="action" value="add">

                <div class="mb-3">
                    <label class="form-label fw-medium text-dark">Họ và Tên <span class="required-asterisk">*</span></label>
                    <input type="text" class="form-control" name="fullName" required placeholder="Nhập họ và tên">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-medium text-dark">Tên đăng nhập <span class="required-asterisk">*</span></label>
                    <input type="text" class="form-control" name="username" required placeholder="Nhập tên đăng nhập">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-medium text-dark">Mật khẩu <span class="required-asterisk">*</span></label>
                    <input type="password" class="form-control" name="password" required placeholder="Nhập mật khẩu">
                </div>
                <div class="mb-4">
                    <label class="form-label fw-medium text-dark">Số điện thoại <span class="required-asterisk">*</span></label>
                    <input type="tel" class="form-control" name="phone" required placeholder="Nhập số điện thoại">
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/admin/staffManagement" class="btn btn-light border px-4">Hủy</a>
                    <input type="submit" class="btn btn-navy px-4" value="Lưu">
                </div>
            </form>
        </div>
    </div>
</body>
</html>
