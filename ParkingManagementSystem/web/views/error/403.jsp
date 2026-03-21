<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>403 - Forbidden</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="d-flex align-items-center justify-content-center vh-100 bg-light">
    <div class="text-center">
        <h1 class="display-1 fw-bold text-danger">403</h1>
        <p class="fs-3"> <span class="text-danger">Opps!</span> Quyền truy cập bị từ chối.</p>
        <p class="lead">Bạn không có quyền truy cập vào trang này.</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
    </div>
</body>
</html>
