<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Quản lý bãi đỗ xe</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100vh;
            }
            .login-card {
                max-width: 400px;
                width: 100%;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                background: #fff;
            }
        </style>
    </head>
    <body>
        <div class="login-card">
            <h3 class="text-center mb-4">Hệ thống bãi đỗ xe</h3>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${error}"/>
                </div>
            </c:if>
            <c:if test="${param.error == 'unauthorized'}">
                <div class="alert alert-warning" role="alert">
                    Vui lòng đăng nhập để tiếp tục.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/login" method="POST">
                <div class="mb-3">
                    <label for="username" class="form-label">Tài khoản</label>
                    <input type="text" class="form-control" id="username" name="username" required autofocus>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
            </form>
        </div>
    </body>
</html>
