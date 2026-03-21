<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống Quản lý Bãi đỗ xe</title>
    <!-- Google Fonts: Be Vietnam Pro -->
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        :root {
            --primary: #8b5cf6;
            --primary-soft: #a78bfa;
            --secondary: #ec4899;
            --secondary-soft: #f472b6;
            --accent: #10b981;
            --body-bg: #fdfcfd;
            --card-bg: #ffffff;
            --glass: rgba(255, 255, 255, 0.7);
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --radius: 1rem;
        }

        body {
            font-family: 'Be Vietnam Pro', -apple-system, sans-serif;
            background-color: var(--body-bg);
            color: #334155;
            line-height: 1.6;
        }

        .navbar {
            background: rgba(255, 255, 255, 0.8) !important;
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            box-shadow: var(--shadow-sm);
            padding: 1rem 0;
            z-index: 1000;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--primary) !important;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .nav-link {
            color: #64748b !important;
            font-weight: 500;
            margin: 0 0.5rem;
            border-radius: 0.5rem;
            transition: all 0.2s ease;
        }

        .nav-link:hover {
            color: var(--primary) !important;
            background: rgba(139, 92, 246, 0.05);
        }

        .nav-link.active {
            color: var(--primary) !important;
            font-weight: 600;
        }

        /* Global Component Styling */
        .card {
            border: none;
            border-radius: var(--radius);
            background: var(--card-bg);
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
            margin-bottom: 2rem;
        }

        .card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-2px);
        }

        .table {
            border-collapse: separate;
            border-spacing: 0 0.5rem;
        }

        .table thead th {
            border: none;
            background-color: transparent;
            color: #94a3b8;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
            padding: 1rem;
        }

        .table tbody tr {
            background-color: #fff;
            border-radius: 0.75rem;
            box-shadow: var(--shadow-sm);
            transition: transform 0.2s ease;
        }

        .table tbody tr:hover {
            transform: scale(1.01);
            background-color: #faf9ff;
        }

        .table tbody td {
            padding: 1rem;
            border: none;
            vertical-align: middle;
        }

        /* Modern Form Inputs Globally */
        .form-control, .form-select {
            border-radius: 0.75rem;
            border: 1px solid #e2e8f0;
            padding: 0.6rem 1rem;
            transition: all 0.2s ease;
            background-color: #f8fafc;
        }

        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 4px rgba(139, 92, 246, 0.1);
            border-color: var(--primary-soft);
            background-color: #fff;
        }

        .btn-primary {
            background-color: var(--primary);
            border: none;
            border-radius: 0.75rem;
            padding: 0.6rem 1.75rem;
            font-weight: 600;
            box-shadow: 0 4px 6px rgba(139, 92, 246, 0.2);
            transition: all 0.2s ease;
        }

        .btn-primary:hover {
            background-color: var(--primary-soft);
            transform: translateY(-1px);
            box-shadow: 0 7px 14px rgba(139, 92, 246, 0.3);
        }

        .badge {
            padding: 0.4rem 0.75rem;
            border-radius: 2rem;
            font-weight: 600;
            font-size: 0.75rem;
        }

        .bg-primary { background-color: rgba(139, 92, 246, 0.1) !important; color: var(--primary) !important; }
        .bg-success { background-color: rgba(16, 185, 129, 0.1) !important; color: var(--accent) !important; }
        .bg-danger { background-color: rgba(244, 63, 94, 0.1) !important; color: #f43f5e !important; }
        .bg-warning { background-color: rgba(245, 158, 11, 0.1) !important; color: #f59e0b !important; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-fade-in {
            animation: fadeIn 0.5s ease-out forwards;
        }

        h2 {
            font-weight: 700;
            letter-spacing: -0.025em;
            color: #1e293b;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">ParkingSystem</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <c:if test="${sessionScope.LOGIN_USER.role == 'manager'}">
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/dashboard">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/users">Nhân viên</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/slots">Ô đỗ xe</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/vehicle-types">Loại xe</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/tickets">Vé xe</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/payments">Thanh toán</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/violations">Vi phạm</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/customers">Khách hàng</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/reports">Báo cáo</a></li>
                    </c:if>
                    <c:if test="${sessionScope.LOGIN_USER.role == 'staff'}">
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/dashboard">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/tickets">Danh sách Vé</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/tickets/checkin">Check-in</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/tickets/checkout">Check-out</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/violations">Vi phạm</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/monthlycard">Thẻ tháng</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/customers">Khách hàng</a></li>
                    </c:if>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            Xin chào, <c:out value="${sessionScope.LOGIN_USER.fullName}"/>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/common/profile">Hồ sơ</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/common/change-password">Đổi mật khẩu</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/auth/logout">Đăng xuất</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <!-- Main Content Container (Closed in footer.jsp) -->
    <div class="container pb-5">
