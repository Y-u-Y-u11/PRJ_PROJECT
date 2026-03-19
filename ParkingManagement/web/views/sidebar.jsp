<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="currentPage" value="${pageContext.request.requestURI}" />

<div class="d-flex">

    <!-- SIDEBAR -->
    <div class="sidebar p-3 d-flex flex-column"
         style="width:280px; position:sticky; top:0; height:100vh; overflow-y:auto;">

        <!-- Logo -->
        <h4 class="text-white fw-bold mb-4 d-flex align-items-center mt-2">
            <span class="bg-light text-primary rounded px-2 py-1 me-2">
                <i class="fa-solid fa-p"></i>
            </span>
            Parking Pro
        </h4>

        <hr class="border-secondary opacity-25">

        <!-- MENU -->
        <ul class="nav flex-column mb-auto">

            <!-- ADMIN -->
            <c:if test="${sessionScope.user.role == 'admin'}">

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                       class="nav-link ${currentPage.contains('dashboard') ? 'active' : ''}">
                        <i class="fa-solid fa-chart-pie me-2"></i>
                        Dashboard
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/staffManagement"
                       class="nav-link ${currentPage.contains('staffManagement') ? 'active' : ''}">
                        <i class="fa-solid fa-users-gear me-2"></i>
                        Quản lý nhân viên
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/pricing"
                       class="nav-link ${currentPage.contains('pricing') ? 'active' : ''}">
                        <i class="fa-solid fa-tags me-2"></i>
                        Bảng giá
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/reports"
                       class="nav-link ${currentPage.contains('reports') ? 'active' : ''}">
                        <i class="fa-solid fa-file-invoice-dollar me-2"></i>
                        Báo cáo doanh thu
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/violations"
                       class="nav-link ${currentPage.contains('violations') ? 'active' : ''}">
                        <i class="fa-solid fa-clipboard-check me-2"></i>
                        Quản lý vi phạm
                    </a>
                </li>

            </c:if>


            <!-- STAFF -->
            <c:if test="${sessionScope.user.role == 'staff'}">

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/staff/dashboard"
                       class="nav-link ${currentPage.contains('dashboard') ? 'active' : ''}">
                        <i class="fa-solid fa-car me-2"></i>
                        Sơ đồ bãi xe
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/staff/subscriptions"
                       class="nav-link ${currentPage.contains('subscriptions') ? 'active' : ''}">
                        <i class="fa-solid fa-id-card me-2"></i>
                        Vé tháng
                    </a>
                </li>

            </c:if>

        </ul>

        <!-- FOOTER -->
        <hr class="border-secondary opacity-25 mt-auto">

        <a href="${pageContext.request.contextPath}/logout"
           class="nav-link text-white">
            <i class="fa-solid fa-right-from-bracket me-2 text-danger"></i>
            Đăng xuất
        </a>

    </div>


    <!-- MAIN CONTENT WRAPPER -->
    <div class="flex-grow-1 bg-body"
         style="height:100vh; overflow-y:auto;">

        <!-- TOP NAVBAR -->
        <nav class="navbar px-4 py-3 d-flex justify-content-between mb-4 top-navbar">

            <h5 class="mb-0 fw-bold text-dark">
                Xin chào,
                ${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'Khách'}
            </h5>

            <span class="badge bg-primary px-3 py-2 rounded-pill shadow-sm">
                Vai trò:
                ${sessionScope.user.role != null ? sessionScope.user.role : 'GUEST'}
            </span>

        </nav>

        <!-- CONTENT -->
        <div class="container-fluid px-4">