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
                <button class="btn btn-outline-primary btn-sm me-2" data-bs-toggle="modal" data-bs-target="#addZoneModal">+ Thêm Khu Vực</button>
                <button class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#addSlotModal">+ Thêm Chỗ Đỗ</button>
            </div>
        </div>

        <c:if test="${param.success == 'checkin'}"><div class="alert alert-success fw-bold"><i class="fa-solid fa-check"></i> Xe đã vào bãi thành công!</div></c:if>
        <c:if test="${param.success == 'checkout'}"><div class="alert alert-success fw-bold"><i class="fa-solid fa-check"></i> Thanh toán và xe ra thành công!</div></c:if>
        <c:if test="${error != null}"><div class="alert alert-danger shadow-sm">${error}</div></c:if>

        <!-- REPORT SECTION -->
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

        <!-- SƠ ĐỒ BÃI XE -->
        <c:forEach items="${zones}" var="zone">
            <h4 class="zone-header fw-bold d-flex justify-content-between">
                <span><i class="fa-solid fa-layer-group text-primary me-2"></i> Khu vực: ${zone.zoneName}</span>
                <form action="${pageContext.request.contextPath}/staff/zone" method="POST" class="d-inline">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="zoneID" value="${zone.zoneID}">
                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Xóa khu vực này?')"><i class="fa-solid fa-trash"></i></button>
                </form>
            </h4>
            <div class="row g-3">
                <c:forEach items="${slots}" var="slot">
                    <c:if test="${slot.zoneID == zone.zoneID}">
                        <div class="col-6 col-sm-4 col-md-3 col-lg-2 position-relative">
                            
                            <!-- LOGIC RENDER NÚT TRỐNG / ĐÃ CÓ XE -->
                            <c:choose>
                                <c:when test="${slot.status == 'Empty' || slot.status == 'empty'}">
                                    <a href="${pageContext.request.contextPath}/staff/check-in?slotID=${slot.slotID}&slotCode=${slot.slotCode}" class="btn spot-btn btn-outline-success w-100 p-4 rounded-3 d-flex flex-column align-items-center shadow-sm text-decoration-none">
                                        <i class="fa-solid fa-car-side fs-2 mb-2 text-success"></i>
                                        <span class="fw-bold fs-5 text-success">${slot.slotCode}</span>
                                        <span class="small mt-1 fw-bold text-success">TRỐNG</span>
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

                            <!-- NÚT XÓA SLOT GÓC PHẢI -->
                            <form action="${pageContext.request.contextPath}/staff/slot" method="POST" class="position-absolute top-0 end-0 mt-1 me-3">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="slotID" value="${slot.slotID}">
                                <button type="submit" class="btn btn-sm btn-dark opacity-50"><i class="fa-solid fa-xmark"></i></button>
                            </form>
                            
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </c:forEach>
    </div>

    <!-- Modal Thêm Zone -->
    <div class="modal fade" id="addZoneModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="${pageContext.request.contextPath}/staff/zone" method="POST" class="modal-content">
                <div class="modal-header"><h5>Thêm Khu Vực Mới</h5></div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">
                    <input type="text" name="zoneName" class="form-control" placeholder="Tên khu vực (VD: Tầng 1)" required>
                </div>
                <div class="modal-footer"><button type="submit" class="btn btn-primary">Lưu</button></div>
            </form>
        </div>
    </div>

    <!-- Modal Thêm Slot -->
    <div class="modal fade" id="addSlotModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="${pageContext.request.contextPath}/staff/slot" method="POST" class="modal-content">
                <div class="modal-header"><h5>Thêm Chỗ Đỗ Mới</h5></div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">
                    <input type="text" name="slotCode" class="form-control mb-2" placeholder="Mã chỗ (VD: A-01)" required>
                    <select name="zoneID" class="form-control" required>
                        <option value="">Chọn khu vực</option>
                        <c:forEach items="${zones}" var="z"><option value="${z.zoneID}">${z.zoneName}</option></c:forEach>
                    </select>
                </div>
                <div class="modal-footer"><button type="submit" class="btn btn-primary">Lưu</button></div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>