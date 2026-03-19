<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận xóa vi phạm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
</head>
<body class="bg-light">
    <jsp:include page="../header.jsp" />
    <jsp:include page="../sidebar.jsp" />
    <div class="bg-white p-4 rounded shadow-sm">
        <h4 class="mb-3 fw-bold">Xác nhận xóa vi phạm</h4>
        <c:if test="${empty violation}">
            <div class="alert alert-danger">Không tìm thấy vi phạm.</div>
            <a href="${pageContext.request.contextPath}/admin/violations" class="btn btn-secondary">Quay lại</a>
        </c:if>
        <c:if test="${not empty violation}">
            <p>Bạn có chắc muốn xóa vi phạm <strong>#${violation.violationID}</strong>?</p>
            <form action="${pageContext.request.contextPath}/admin/violations/delete" method="post">
                <input type="hidden" name="id" value="${violation.violationID}" />
                <input type="submit" value="Xóa" class="btn btn-danger" />
                <a href="${pageContext.request.contextPath}/admin/violations" class="btn btn-secondary ms-2">Hủy</a>
            </form>
        </c:if>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
