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
                                    <button class="btn spot-btn btn-success w-100 p-4 rounded-3 d-flex flex-column align-items-center shadow-sm" onclick="openCheckInModal('${slot.slotID}', '${slot.slotCode}')">
                                        <i class="fa-solid fa-car-side fs-2 mb-2 text-white"></i>
                                        <span class="fw-bold fs-5 text-white">${slot.slotCode}</span>
                                        <span class="small mt-1 fw-bold text-white">TRỐNG</span>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn spot-btn btn-danger w-100 p-4 rounded-3 d-flex flex-column align-items-center shadow-sm" onclick="openCheckOutModal('${slot.slotCode}')">
                                        <i class="fa-solid fa-car-side fs-2 mb-2 text-white"></i>
                                        <span class="fw-bold fs-5 text-white">${slot.slotCode}</span>
                                        <span class="small mt-1 fw-bold text-white">ĐÃ CÓ XE</span>
                                    </button>
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

    <!-- MODAL CHECK-IN -->
    <div class="modal fade" id="bookingModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <form action="${pageContext.request.contextPath}/staff/check-in" method="POST" id="checkInForm">
                    <input type="hidden" name="slotID" id="inputCheckInSlotID">
                    <div class="modal-body p-4">
                        <h4 class="fw-bold mb-4" style="color: var(--navy-dark);">Tiếp nhận xe</h4>
                        <div class="bg-primary bg-opacity-10 p-3 rounded-3 mb-4 d-flex justify-content-between align-items-center border border-primary border-opacity-25">
                            <span class="text-primary fw-bold">Vị trí cấp phát:</span>
                            <span class="fs-3 fw-bolder text-primary" id="modalSpotCode"></span>
                        </div>

                        <!-- Thêm Radio Chọn Loại Xe -->
                        <div class="mb-3">
                            <label class="form-label fw-bold text-secondary">Loại xe</label>
                            <div class="d-flex gap-3 bg-light p-2 rounded-3 border">
                                <div class="form-check">
                                    <input class="form-check-input vehicle-type-radio" type="radio" name="vehicleType" id="typeOTO" value="OTO">
                                    <label class="form-check-label fw-bold" for="typeOTO"><i class="fa-solid fa-car"></i> Ô tô</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input vehicle-type-radio" type="radio" name="vehicleType" id="typeXM" value="XM" checked>
                                    <label class="form-check-label fw-bold" for="typeXM"><i class="fa-solid fa-motorcycle"></i> Xe máy</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input vehicle-type-radio" type="radio" name="vehicleType" id="typeXD" value="XD">
                                    <label class="form-check-label fw-bold" for="typeXD"><i class="fa-solid fa-bicycle"></i> Xe đạp</label>
                                </div>
                            </div>
                        </div>

                        <!-- Container Biển số xe sẽ bị ẩn nếu chọn Xe đạp -->
                        <div class="mb-4" id="plateInputContainer">
                            <label class="form-label fw-bold text-secondary">Biển Số Xe</label>
                            <input type="text" name="vehicleID" id="vehiclePlateInput" class="form-control form-control-lg text-uppercase" placeholder="VD: 29A-123.45" required>
                        </div>
                        
                        <div class="row g-2">
                            <div class="col-6"><button type="button" class="btn btn-light w-100 fw-bold py-2" data-bs-dismiss="modal">Hủy</button></div>
                            <div class="col-6"><button type="submit" class="btn btn-primary w-100 fw-bold py-2">Check-in Ngay</button></div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL IN VÉ (HIỂN THỊ KHI CHECK-IN THÀNH CÔNG) -->
    <c:if test="${param.success == 'checkin'}">
    <div class="modal fade" id="ticketModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white border-0">
                    <h5 class="modal-title fw-bold mx-auto"><i class="fa-solid fa-receipt me-2"></i> VÉ GỬI XE</h5>
                </div>
                <div class="modal-body p-4 ticket-modal-body m-3">
                    <div class="text-center mb-4">
                        <h4 class="fw-bold mb-0 text-uppercase">Parking System</h4>
                        <small class="text-muted">Vé có giá trị sử dụng trong ngày</small>
                    </div>
                    
                    <div class="d-flex justify-content-between mb-2 border-bottom pb-2">
                        <span class="text-muted fw-bold">Ticket ID:</span>
                        <span class="fw-bold text-primary">#${not empty param.ticketID ? param.ticketID : 'Tạo Tự Động'}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2 border-bottom pb-2">
                        <span class="text-muted fw-bold">Biển số/ID:</span>
                        <span class="fw-bold fs-5 text-uppercase">${not empty param.plate ? param.plate : 'N/A'}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2 border-bottom pb-2">
                        <span class="text-muted fw-bold">Giờ vào:</span>
                        <span class="fw-bold">${not empty param.time ? param.time : 'Vừa xong'}</span>
                    </div>
                    <div class="d-flex justify-content-between mt-3">
                        <span class="text-muted fw-bold">Phí dự kiến:</span>
                        <span class="fw-bold text-danger fs-5">${not empty param.fee ? param.fee : 'Cơ bản'} VNĐ</span>
                    </div>
                    
                    <div class="text-center mt-4">
                        <i class="fa-solid fa-barcode fs-1 w-100"></i>
                    </div>
                </div>
                <div class="modal-footer border-0 d-flex justify-content-between">
                    <button type="button" class="btn btn-light fw-bold flex-grow-1 me-2" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-primary fw-bold flex-grow-1" onclick="window.print()"><i class="fa-solid fa-print me-1"></i> In Vé</button>
                </div>
            </div>
        </div>
    </div>
    </c:if>

    <!-- MODAL CHECK-OUT -->
    <div class="modal fade" id="releaseModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <form action="${pageContext.request.contextPath}/staff/check-out" method="POST">
                    <div class="modal-body p-4 text-center">
                        <i class="fa-solid fa-car-side text-danger fs-1 mb-3"></i>
                        <h4 class="fw-bold mb-3" style="color: var(--navy-dark);">Giải Phóng Vị Trí <span id="releaseSpotCode" class="text-danger"></span></h4>
                        <div class="mb-4 text-start">
                            <label class="form-label fw-bold text-secondary">Nhập Mã Vé (Ticket ID)</label>
                            <input type="number" name="ticketID" class="form-control form-control-lg" required>
                        </div>
                        <div class="row g-2">
                            <div class="col-6"><button type="button" class="btn btn-light w-100 fw-bold py-2" data-bs-dismiss="modal">Hủy</button></div>
                            <div class="col-6"><button type="submit" class="btn btn-danger w-100 fw-bold py-2">Thanh toán & Ra</button></div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openCheckInModal(slotId, slotCode) {
            document.getElementById('modalSpotCode').textContent = slotCode;
            document.getElementById('inputCheckInSlotID').value = slotId;
            new bootstrap.Modal(document.getElementById('bookingModal')).show();
        }
        function openCheckOutModal(slotCode) {
            document.getElementById('releaseSpotCode').textContent = slotCode;
            new bootstrap.Modal(document.getElementById('releaseModal')).show();
        }

        // JS: Xử lý ẩn hiện Biển số xe cho Xe đạp
        document.querySelectorAll('.vehicle-type-radio').forEach(radio => {
            radio.addEventListener('change', function() {
                const plateContainer = document.getElementById('plateInputContainer');
                const plateInput = document.getElementById('vehiclePlateInput');
                
                if (this.value === 'XD') {
                    // Nếu là xe đạp -> Ẩn input và sinh mã ngẫu nhiên thay thế biển số
                    plateContainer.style.display = 'none';
                    plateInput.required = false;
                    plateInput.value = 'XD-' + Math.floor(10000 + Math.random() * 90000); 
                } else {
                    // Các xe khác -> Hiện yêu cầu nhập biển số
                    plateContainer.style.display = 'block';
                    plateInput.required = true;
                    plateInput.value = '';
                }
            });
        });

        // Bật popup Ticket tự động nếu có ?success=checkin
        // Đã sửa lỗi "Unexpected token '<'" bằng cách gán param vào chuỗi JS thay vì dùng thẻ JSP trực tiếp.
        const checkinStatus = "${param.success}";
        if (checkinStatus === 'checkin') {
            document.addEventListener("DOMContentLoaded", function() {
                const ticketModalEl = document.getElementById('ticketModal');
                if (ticketModalEl) {
                    new bootstrap.Modal(ticketModalEl).show();
                }
            });
        }
    </script>
</body>
</html>