<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sơ đồ bãi xe - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <style>
        .spot-btn { border-width: 2px !important; transition: all 0.2s; }
        .spot-btn:hover { transform: scale(1.05); }
        .zone-header { border-bottom: 2px solid var(--navy-dark); padding-bottom: 10px; margin-top: 30px; margin-bottom: 20px; color: var(--navy-dark); }
        .status-dot { width: 12px; height: 12px; border-radius: 50%; display: inline-block; }
        /* Style cho vé in */
        .ticket-modal-body { background-color: #f8f9fa; border: 2px dashed #ccc; border-radius: 10px; }
    </style>
</head>
<body>
    <jsp:include page="/views/header.jsp" />
    <jsp:include page="/views/sidebar.jsp" />

    <div class="container mt-4 mb-5">
        
        <!-- Header & Alerts -->
        <div class="row mb-3 align-items-center">
            <div class="col-md-8">
                <h2 class="fw-bold"><i class="fa-solid fa-map-location-dot text-primary me-2"></i> Hệ Thống Bãi Đỗ Xe</h2>
            </div>
            <div class="col-md-4 text-md-end">
                <span class="me-3"><span class="status-dot bg-success"></span> Trống</span>
                <span><span class="status-dot bg-danger"></span> Đã Đặt</span>
            </div>
        </div>

        <c:if test="${param.success == 'checkin'}"><div class="alert alert-success fw-bold d-none"><i class="fa-solid fa-check"></i> Xe đã vào bãi thành công!</div></c:if>
        <c:if test="${param.success == 'checkout'}"><div class="alert alert-success fw-bold"><i class="fa-solid fa-check"></i> Thanh toán và xe ra thành công!</div></c:if>
        <c:if test="${error != null}"><div class="alert alert-danger shadow-sm">${error}</div></c:if>

        <!-- REPORT SECTION (Tính toán trực tiếp bằng JSTL) -->
        <c:set var="totalEmpty" value="0"/>
        <c:set var="totalOccupied" value="0"/>
        <c:forEach items="${slots}" var="s">
            <c:choose>
                <c:when test="${s.status == 'Empty' || s.status == 'empty'}"><c:set var="totalEmpty" value="${totalEmpty + 1}"/></c:when>
                <c:otherwise><c:set var="totalOccupied" value="${totalOccupied + 1}"/></c:otherwise>
            </c:choose>
        </c:forEach>

        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-4 bg-primary text-white"><div class="card-body p-3 fw-bold"><i class="fa-solid fa-list me-2"></i> Tổng số chỗ: ${slots.size()}</div></div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-4 bg-success text-white"><div class="card-body p-3 fw-bold"><i class="fa-solid fa-check-circle me-2"></i> Đang trống: ${totalEmpty}</div></div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-4 bg-danger text-white"><div class="card-body p-3 fw-bold"><i class="fa-solid fa-car me-2"></i> Đã có xe: ${totalOccupied}</div></div>
            </div>
        </div>

        <!-- UI SƠ ĐỒ CHIA THEO ZONE & SLOT -->
        <c:forEach items="${zones}" var="zone">
            <h4 class="zone-header fw-bold"><i class="fa-solid fa-layer-group text-primary me-2"></i> Khu vực: ${zone.zoneName}</h4>
            <div class="row g-3">
                <c:forEach items="${slots}" var="slot">
                    <c:if test="${slot.zoneID == zone.zoneID}">
                        <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                            <c:choose>
                                <c:when test="${slot.status == 'Empty' || slot.status == 'empty'}">
                                    <a href="${pageContext.request.contextPath}/staff/check-in?slotID=${slot.slotID}&slotCode=${slot.slotCode}" class="btn spot-btn btn-success w-100 p-4 rounded-3 d-flex flex-column align-items-center shadow-sm text-decoration-none">
                                        <i class="fa-solid fa-car-side fs-2 mb-2 text-white"></i>
                                        <span class="fw-bold fs-5 text-white">${slot.slotCode}</span>
                                        <span class="small mt-1 fw-bold text-white">TRỐNG</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/staff/check-out?slotCode=${slot.slotCode}" class="btn spot-btn btn-danger w-100 p-4 rounded-3 d-flex flex-column align-items-center shadow-sm text-decoration-none">
                                        <i class="fa-solid fa-car-side fs-2 mb-2 text-white"></i>
                                        <span class="fw-bold fs-5 text-white">${slot.slotCode}</span>
                                        <span class="small mt-1 fw-bold text-white">ĐÃ CÓ XE</span>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </c:forEach>
        <c:if test="${empty zones}"><p class="text-muted text-center py-5">Chưa có dữ liệu khu vực bãi đỗ xe.</p></c:if>

    </div>
    </div></div>

    <!-- No Javascript logic is needed as all Modals have been converted to standalone Views/Servlets -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>