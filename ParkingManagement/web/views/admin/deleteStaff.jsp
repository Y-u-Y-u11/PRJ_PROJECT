<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận khóa nhân viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
</head>
<body class="bg-light">
    <jsp:include page="../header.jsp" />
    <jsp:include page="../sidebar.jsp" />
    <div class="container mt-4 mb-5" style="max-width: 600px;">
        <div class="bg-white p-4 rounded shadow-sm">
            <h4 class="mb-3 fw-bold text-dark border-bottom pb-2">Xác nhận thao tác</h4>
            
            <c:if test="${empty staff}">
                <div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> Không tìm thấy nhân viên.</div>
                <div class="mt-4 pt-3 border-top text-end">
                    <a href="${pageContext.request.contextPath}/admin/staffManagement" class="btn btn-secondary">Quay lại</a>
                </div>
            </c:if>
            
            <c:if test="${not empty staff}">
                <p class="fs-5 mt-4">
                    Bạn có chắc chắn muốn vô hiệu hóa / xóa nhân viên 
                    <strong class="text-danger">${staff.fullName}</strong> 
                    (Tài khoản: <strong>${staff.username}</strong>)?
                </p>
                <div class="alert alert-warning small">
                    <i class="fas fa-info-circle"></i> Hành động này sẽ khiến nhân viên không thể đăng nhập vào hệ thống.
                </div>
                
                <form action="${pageContext.request.contextPath}/admin/staffManagement/delete" method="post" class="mt-4 pt-3 border-top text-end">
                    <input type="hidden" name="id" value="${staff.userID}" />
                    <a href="${pageContext.request.contextPath}/admin/staffManagement" class="btn btn-light border me-2">Hủy bỏ</a>
                    <input type="submit" class="btn btn-danger fw-bold" value="Có, Khóa nhân viên">
                </form>
            </c:if>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
