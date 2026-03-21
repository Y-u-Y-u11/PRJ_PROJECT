<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống Quản lý Bãi đỗ xe</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
