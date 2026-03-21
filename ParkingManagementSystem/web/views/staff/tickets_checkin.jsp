<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row w-100 justify-content-center">
    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">Check-in: Tạo Vé Đỗ Xe Mới</h5>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/staff/tickets/checkin" method="POST">
                    <div class="mb-3">
                        <label class="form-label">Biển số xe (nếu có)</label>
                        <input type="text" class="form-control" name="plateNumber" autofocus>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Loại xe</label>
                        <select name="vehicleTypeId" class="form-select" required>
                            <option value="">-- Chọn Loại Xe --</option>
                            <c:forEach var="v" items="${vehicleTypes}">
                                <option value="${v.id}">${v.name} (${v.currentPrice} VNĐ/h) - ${v.requiresPlate ? 'Cần biển số' : 'Không cần biển số'}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Chọn ô đỗ (Trống)</label>
                        <select name="slotId" class="form-select" required>
                            <option value="">-- Chọn ô đỗ --</option>
                            <c:forEach var="s" items="${availableSlots}">
                                <option value="${s.id}">${s.code}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-success w-100 py-2">Xác nhận Check-in</button>
                    <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-secondary w-100 mt-2">Hủy</a>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />