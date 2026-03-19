<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sửa Quy Tắc Giá - Parking Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    </head>
    <body>
        <!-- ================= Header + Sidebar ================= -->
        <jsp:include page="../header.jsp" />
        <jsp:include page="../sidebar.jsp" />

        <!-- ================= Main content ================= -->
        <div class="bg-white p-4 rounded shadow-sm">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold text-dark">Cập Nhật Quy Tắc Giá #${rule.ruleID}</h4>
            </div>

            <!-- Flash messages -->
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/pricing/edit" method="POST" id="ruleForm">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="ruleID" value="${rule.ruleID}">

                <div class="mb-3">
                    <label class="form-label fw-medium text-dark">Loại xe (Mã Type) <span class="text-danger">*</span></label>
                    <select name="typeID" class="form-select" required>
                        <option value="1" ${rule.typeID == '1' ? 'selected' : ''}>Ô Tô (1)</option>
                        <option value="2" ${rule.typeID == '2' ? 'selected' : ''}>Xe Máy (2)</option>
                        <option value="3" ${rule.typeID == '3' ? 'selected' : ''}>Xe Đạp (3)</option>
                    </select>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-6">
                        <label class="form-label fw-medium text-dark">Từ giờ (0-24) <span class="text-danger">*</span></label>
                        <input type="number" name="startHour" class="form-control" value="${rule.startHour}" min="0" max="24" required>
                    </div>
                    <div class="col-6">
                        <label class="form-label fw-medium text-dark">Đến giờ (0-24) <span class="text-danger">*</span></label>
                        <input type="number" name="endHour" class="form-control" value="${rule.endHour}" min="0" max="24" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-medium text-dark">Giá tiền (VNĐ) <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <input type="number" name="price" class="form-control" value="<fmt:formatNumber value="${rule.price}" pattern="0" groupingUsed="false" />" min="0" step="1000" required>
                        <span class="input-group-text bg-light fw-bold text-muted">VNĐ</span>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
                    <a href="${pageContext.request.contextPath}/admin/pricing" class="btn btn-light border">Hủy</a>
                    <input type="submit" class="btn btn-navy px-4" value="Lưu thay đổi">
                </div>
            </form>
        </div>
        <!-- ================= Main content ================= -->
    </div> 
</div> 
</div> 

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
