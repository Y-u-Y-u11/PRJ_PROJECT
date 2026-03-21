<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Hệ thống Bãi đỗ xe</title>
        <!-- Google Fonts: Be Vietnam Pro -->
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        
        <style>
            :root {
                --primary: #8b5cf6;
                --primary-soft: #a78bfa;
                --secondary: #ec4899;
                --body-bg: #f8fafc;
                --radius: 1.25rem;
            }

            body {
                font-family: 'Be Vietnam Pro', sans-serif;
                background: linear-gradient(135deg, #f5f3ff 0%, #fdf2f8 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                margin: 0;
            }

            .login-container {
                width: 100%;
                max-width: 420px;
                padding: 20px;
                animation: fadeIn 0.8s ease-out;
            }

            .login-card {
                background: rgba(255, 255, 255, 0.8);
                backdrop-filter: blur(16px);
                border: 1px solid rgba(255, 255, 255, 0.5);
                border-radius: var(--radius);
                padding: 3rem 2.5rem;
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02);
            }

            .brand-logo {
                width: 64px;
                height: 64px;
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                border-radius: 1rem;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1.5rem;
                box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.3);
                color: white;
                font-size: 2rem;
            }

            h3 {
                font-weight: 700;
                color: #1e293b;
                letter-spacing: -0.025em;
                margin-bottom: 0.5rem;
            }

            .form-label {
                font-weight: 600;
                font-size: 0.875rem;
                color: #64748b;
                margin-bottom: 0.5rem;
            }

            .form-control {
                border-radius: 0.75rem;
                border: 1px solid #e2e8f0;
                padding: 0.75rem 1rem;
                transition: all 0.2s ease;
                background-color: rgba(255, 255, 255, 0.5);
            }

            .form-control:focus {
                box-shadow: 0 0 0 4px rgba(139, 92, 246, 0.1);
                border-color: var(--primary-soft);
                background-color: #fff;
            }

            .btn-login {
                background: linear-gradient(to right, var(--primary), var(--primary-soft));
                border: none;
                border-radius: 0.75rem;
                padding: 0.8rem;
                font-weight: 700;
                color: white;
                margin-top: 1.5rem;
                box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.2);
                transition: all 0.3s ease;
            }

            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 20px 25px -5px rgba(139, 92, 246, 0.3);
                opacity: 0.9;
            }

            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .alert {
                border-radius: 0.75rem;
                font-size: 0.875rem;
                border: none;
                padding: 1rem;
            }
        </style>
    </head>
    <body>
        <div class="login-container text-center">
            <div class="brand-logo">
                <i class="bi bi-p-square-fill"></i>
            </div>
            
            <div class="login-card text-start">
                <h3 class="text-center">ParkingSystem</h3>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger bg-danger bg-opacity-10 text-danger mb-4" role="alert">
                        <i class="bi bi-exclamation-circle me-2"></i>
                        <c:out value="${error}"/>
                    </div>
                </c:if>
                <c:if test="${param.error == 'unauthorized'}">
                    <div class="alert alert-warning bg-warning bg-opacity-10 text-warning mb-4" role="alert">
                        <i class="bi bi-shield-lock me-2"></i>
                        Vui lòng đăng nhập để tiếp tục.
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/auth/login" method="POST">
                    <div class="mb-3">
                        <label for="username" class="form-label">Tên tài khoản</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted" style="border-radius: 0.75rem 0 0 0.75rem;">
                                <i class="bi bi-person"></i>
                            </span>
                            <input type="text" class="form-control border-start-0" id="username" name="username" placeholder="Nhập tên tài khoản" required autofocus style="border-radius: 0 0.75rem 0.75rem 0;">
                        </div>
                    </div>
                    <div class="mb-4">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted" style="border-radius: 0.75rem 0 0 0.75rem;">
                                <i class="bi bi-key"></i>
                            </span>
                            <input type="password" class="form-control border-start-0" id="password" name="password" placeholder="Nhập mật khẩu" required style="border-radius: 0 0.75rem 0.75rem 0;">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-login w-100">
                        Đăng nhập <i class="bi bi-arrow-right ms-2"></i>
                    </button>
                </form>
            </div>
        </div>
    </body>
</html>
