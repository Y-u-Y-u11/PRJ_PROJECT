<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Doanh Thu - Parking Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
</head>
<body>

<jsp:include page="/views/header.jsp" />
<jsp:include page="/views/sidebar.jsp" />

<div class="row mb-4 mt-4 align-items-end">
    <div class="col-md-6">
        <h3 class="fw-bold" style="color: var(--navy-dark);"><i class="fa-solid fa-file-invoice-dollar text-primary me-2"></i> Báo Cáo Doanh Thu</h3>
        <p class="text-muted mb-0">Tra cứu chi tiết các lượt gửi xe và doanh thu.</p>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger shadow-sm">${error}</div>
</c:if>

<div class="card border-0 shadow-sm rounded-4">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="py-3 px-4 text-secondary">Mã Vé</th>
                        <th class="py-3 text-secondary">Biển số xe</th>
                        <th class="py-3 text-secondary">Giờ vào</th>
                        <th class="py-3 text-secondary">Giờ ra</th>
                        <th class="py-3 text-secondary">Trạng thái</th>
                        <th class="py-3 text-secondary text-end pe-4">Số tiền thu</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Lặp qua biến reportData -->
                    <c:forEach items="${reportData}" var="ticket">
                        <tr>
                            <td class="px-4 fw-bold text-primary">#${ticket.ticketID}</td>
                            
                            <!-- Đồng bộ UI và gọi biến plateNumber -->
                            <td><span class="badge bg-light text-dark border px-2 py-1">${ticket.plateNumber}</span></td>
                            
                            <td><fmt:formatDate value="${ticket.checkInTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                            
                            <td>
                                <c:choose>
                                    <c:when test="${not empty ticket.checkOutTime}">
                                        <fmt:formatDate value="${ticket.checkOutTime}" pattern="dd/MM/yyyy HH:mm" />
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted fst-italic">Chưa ra</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            
                            <td>
                                <c:choose>
                                    <c:when test="${ticket.status == 'Completed'}">
                                        <span class="badge bg-success bg-opacity-10 text-success border border-success px-2 py-1">Đã thu tiền</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning bg-opacity-10 text-warning border border-warning px-2 py-1">${ticket.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            
                            <td class="fw-bold text-danger text-end pe-4 fs-6">
                                <fmt:formatNumber value="${ticket.totalFee}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty reportData}">
                        <tr><td colspan="6" class="text-center py-5 text-muted">Không có dữ liệu báo cáo.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>