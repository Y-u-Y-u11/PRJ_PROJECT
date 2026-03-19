<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Parking Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #0a192f 0%, #1e3a8a 100%);
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .login-card {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                box-shadow: 0 15px 35px rgba(0,0,0,0.2);
                overflow: hidden;
                width: 100%;
                max-width: 400px;
            }
            .login-header {
                background-color: #0a192f;
                color: white;
                padding: 30px 20px;
                text-align: center;
            }
            .btn-navy {
                background-color: #1e3a8a;
                color: white;
                border: none;
            }
            .btn-navy:hover {
                background-color: #0a192f;
                color: white;
            }
        </style>
    </head>
    <body>

        <div class="login-card">
            <div class="login-header">
                <i class="fa-solid fa-square-parking fa-3x mb-2 text-info"></i>
                <h3 class="fw-bold m-0">PARKING SYSTEM</h3>
            </div>
            <div class="p-4">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 text-center">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="mb-3">
                        <label class="form-label text-secondary fw-bold">Tài khoản</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="fa-solid fa-user"></i></span>
                            <input type="text" name="username" class="form-control" placeholder="Nhập tên đăng nhập" required>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label class="form-label text-secondary fw-bold">Mật khẩu</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="fa-solid fa-lock"></i></span>
                            <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-navy w-100 py-2 fw-bold">ĐĂNG NHẬP</button>
                </form>
            </div>
        </div>

    </body>
</html>
