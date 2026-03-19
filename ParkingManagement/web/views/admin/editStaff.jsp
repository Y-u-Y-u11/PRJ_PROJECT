<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập Nhật Nhân Viên - Parking Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    </head>
    <body>
        <jsp:include page="../header.jsp" />
        <jsp:include page="../sidebar.jsp" />

        <div class="bg-white p-4 rounded shadow-sm">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold text-dark">Cập Nhật Nhân Viên #${staff.userID}</h4>
            </div>

            <form action="${pageContext.request.contextPath}/admin/staffManagement" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${staff.userID}">

                <div class="mb-3">
                    <label class="form-label fw-medium text-dark">Họ và Tên <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="fullName" value="${staff.fullName}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-medium text-dark">Tên đăng nhập <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="username" value="${staff.username}" readonly>
                </div>
                <!-- Mật khẩu không cần ở form edit, vì controller sẽ giữ lại password cũ -->
                <div class="mb-3">
                    <label class="form-label fw-medium text-dark">Số điện thoại <span class="text-danger">*</span></label>
                    <input type="tel" class="form-control" name="phone" value="${staff.phone}" required>
                </div>
                <div class="mb-4">
                    <label class="form-label fw-medium text-dark">Trạng thái <span class="text-danger">*</span></label>
                    <select class="form-select" name="status">
                        <option value="ACTIVE" ${staff.status ? 'selected' : ''}>Đang Hoạt Động</option>
                        <option value="INACTIVE" ${!staff.status ? 'selected' : ''}>Ngưng Hoạt Động</option>
                    </select>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
                    <a href="${pageContext.request.contextPath}/admin/staffManagement" class="btn btn-light border">Hủy</a>
                    <input type="submit" class="btn btn-navy px-4" value="Lưu thay đổi">
                </div>
            </form>
        </div>
    </div> 
</div> 
</div> 

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
