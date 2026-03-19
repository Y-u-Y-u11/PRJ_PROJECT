<%@ page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bảng Điều Khiển - Parking Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
        <style>
            .hover-opacity-100:hover {
                opacity: 1 !important;
            }
        </style>
    </head>
    <body>
        <!-- ================= Header + Sidebar ================= -->
        <jsp:include page="../header.jsp" />
        <jsp:include page="../sidebar.jsp" />

        <!-- ================= Main content ================= -->
        <!-- Utility bars -->
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-4 border-bottom">
            <div>
                <h1 class="h3 fw-bold text-dark mb-0">Bảng Điều Khiển Tổng Quan</h1>
            </div>
            <div class="btn-toolbar mb-2 mb-md-0 gap-2">
                <a href="${pageContext.request.contextPath}/admin/pricing" class="btn btn-sm btn-outline-secondary shadow-sm">
                    <i class="fas fa-tags me-1"></i> Bảng Giá
                </a>
                <a href="${pageContext.request.contextPath}/admin/staffManagement" class="btn btn-sm btn-outline-secondary shadow-sm">
                    <i class="fas fa-user-plus me-1"></i> Nhân Sự
                </a>
                <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET" style="display:inline;">
                    <input type="hidden" name="action" value="export">
                    <input type="submit" class="btn btn-sm btn-navy shadow-sm" value="Xuất Báo Cáo Cuối Ngày">
                </form>
            </div>
        </div>

        <!-- Summary Cards -->
        <div class="row mb-4">
            <!-- Income -->
            <div class="col-md-3">
                <div class="card text-white bg-primary mb-3 shadow-sm border-0 h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="card-title mb-1 text-white-50 fw-medium">Doanh Thu Trong Ngày</p>
                                <h3 class="mb-0 fw-bold"><fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/></h3>
                            </div>
                            <div class="p-2 bg-white bg-opacity-25 rounded">
                                <i class="fas fa-wallet fa-lg"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-0 pt-0">
                        <a href="${pageContext.request.contextPath}/admin/reports" class="text-white text-decoration-none small d-flex align-items-center justify-content-between opacity-75 hover-opacity-100">
                            Xem báo cáo chi tiết <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Lượt Xe -->
            <div class="col-md-3">
                <div class="card text-white bg-success mb-3 shadow-sm border-0 h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="card-title mb-1 text-white-50 fw-medium">Tổng Lượt Xe Ra/Vào</p>
                                <h3 class="mb-0 fw-bold">${todayCars != null ? todayCars : 0} <span class="fs-6 fw-normal text-white-50">lượt</span></h3>
                            </div>
                            <div class="p-2 bg-white bg-opacity-25 rounded">
                                <i class="fas fa-car fa-lg"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-0 pt-0">
                        <span class="text-white small opacity-75"><i class="fas fa-clock me-1"></i> Cập nhật liên tục</span>
                    </div>
                </div>
            </div>

            <!-- Capacity) -->
            <div class="col-md-3">
                <div class="card text-white bg-warning mb-3 shadow-sm border-0 h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div>
                                <p class="card-title mb-1 text-dark text-opacity-75 fw-medium">Chỗ Trống / Tổng Số</p>
                                <h3 class="mb-0 fw-bold text-dark">${emptySlots != null ? emptySlots : 0} <span class="fs-5 text-dark text-opacity-50">/ ${totalSlots != null ? totalSlots : 0}</span></h3>
                            </div>
                            <div class="p-2 bg-dark bg-opacity-10 rounded">
                                <i class="fas fa-parking fa-lg text-dark opacity-75"></i>
                            </div>
                        </div>

                        <c:set var="occupied" value="${(totalSlots != null and totalSlots > 0) ? (totalSlots - emptySlots) : 0}" />
                        <c:set var="occupancyRate" value="${(totalSlots != null and totalSlots > 0) ? (occupied * 100.0 / totalSlots) : 0}" />

                        <div class="progress mt-2" style="height: 6px; background-color: rgba(0,0,0,0.1);">
                            <div class="progress-bar bg-dark" role="progressbar" style="width: ${occupancyRate}%;" aria-valuenow="${occupancyRate}" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <p class="text-dark text-opacity-75 small mt-1 mb-0 text-end">Đã lấp đầy <fmt:formatNumber value="${occupancyRate}" maxFractionDigits="1"/>%</p>
                    </div>
                </div>
            </div>

            <!-- Violation / Alert -->
            <div class="col-md-3">
                <div class="card text-white bg-danger mb-3 shadow-sm border-0 h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="card-title mb-1 text-white-50 fw-medium">Cảnh Báo / Vi Phạm</p>
                                <h3 class="mb-0 fw-bold">${activeViolations != null ? activeViolations : 0}</h3>
                            </div>
                            <div class="p-2 bg-white bg-opacity-25 rounded">
                                <i class="fas fa-exclamation-triangle fa-lg"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-0 pt-0">
                        <a href="${pageContext.request.contextPath}/admin/violations" class="text-white text-decoration-none small d-flex align-items-center justify-content-between opacity-75 hover-opacity-100">
                            Xử lý ngay <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- History / Notification -->
        <div class="row g-4">
            <!-- Recent activities -->
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 mb-4 h-100">
                    <div class="card-header bg-white border-bottom py-3 d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 fw-bold text-dark"><i class="fas fa-history text-primary me-2"></i>Lịch Sử Xe Ra Vào Gần Đây</h5>
                        <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET" style="display:inline;">
                            <input type="hidden" name="action" value="refresh">
                            <input type="submit" class="btn btn-sm btn-light border" value="↻">
                        </form>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light text-muted">
                                    <tr>
                                        <th class="ps-4">Mã Vé</th>
                                        <th>Biển Số/Xe ID</th>
                                        <th>Vị Trí Đỗ</th>
                                        <th>Giờ Vào</th>
                                        <th>Giờ Ra</th>
                                        <th>Trạng Thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty recentHistories}">
                                            <!-- Duyệt qua tối đa 7 dòng lịch sử gần nhất -->
                                            <c:forEach items="${recentHistories}" var="history" begin="0" end="6">
                                                <tr>
                                                    <!-- Đã sửa .id thành .ticketID để map với Model ParkingTicket -->
                                                    <td class="ps-4 text-muted fw-medium">#${history.ticketID}</td>
                                                    <td class="fw-bold text-dark">
                                                        <!-- Đã sửa .licensePlate thành .vehicleID -->
                                                        <span class="border border-dark rounded px-2 py-1 bg-light">${history.vehicleID}</span>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary">${not empty history.slotID ? history.slotID : 'Khu chung'}</span>
                                                    </td>
                                                    <td class="text-muted"><fmt:formatDate value="${history.checkInTime}" pattern="HH:mm dd/MM" /></td>
                                                    <td class="text-muted">
                                                        <c:choose>
                                                            <c:when test="${not empty history.checkOutTime}">
                                                                <fmt:formatDate value="${history.checkOutTime}" pattern="HH:mm dd/MM" />
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${empty history.checkOutTime or history.status == 'Parking'}">
                                                            <span class="badge bg-warning text-dark"><i class="fas fa-parking me-1"></i> Đang Đỗ</span>
                                                        </c:if>
                                                        <c:if test="${not empty history.checkOutTime and history.status == 'Completed'}">
                                                            <span class="badge bg-success bg-opacity-10 text-success border border-success"><i class="fas fa-check me-1"></i> Đã Ra</span>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-5">
                                                    <i class="fas fa-folder-open fa-2x mb-2 text-black-50 d-block"></i>
                                                    Chưa có dữ liệu hoạt động.
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Panel thông tin hệ thống (Cột phải 4/12) -->
            <div class="col-lg-4">
                <div class="card shadow-sm border-0 mb-4 h-100">
                    <div class="card-header bg-white border-bottom py-3">
                        <h5 class="mb-0 fw-bold text-dark"><i class="fas fa-bell text-warning me-2"></i>Thông Báo Hệ Thống</h5>
                    </div>
                    <div class="card-body p-3">
                        <ul class="list-group list-group-flush">
                            <!-- Dữ liệu thông báo được render động từ Controller -->
                            <c:choose>
                                <c:when test="${not empty systemNotifications}">
                                    <c:forEach items="${systemNotifications}" var="notif">
                                        <li class="list-group-item px-0 py-3 border-bottom">
                                            <div class="d-flex w-100 justify-content-between">
                                                <!-- Màu sắc (type) thay đổi tùy theo mức độ thông báo (danger, warning, primary) -->
                                                <h6 class="mb-1 fw-bold text-${notif.type}">${notif.title}</h6>
                                                <small class="text-muted">${notif.time}</small>
                                            </div>
                                            <p class="mb-0 small text-muted">${notif.message}</p>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li class="list-group-item px-0 py-4 text-center text-muted border-0">
                                        <i class="fas fa-check-circle fs-3 text-success opacity-50 mb-2 d-block"></i>
                                        Hệ thống đang hoạt động ổn định.
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <!-- ================= Main content ================= -->

    </div> 
</div> 
</div> 

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>