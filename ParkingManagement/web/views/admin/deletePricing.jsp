<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận xóa quy tắc giá</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
</head>
<body class="bg-light">
    <jsp:include page="../header.jsp" />
    <jsp:include page="../sidebar.jsp" />
    <div class="container mt-4 mb-5" style="max-width: 600px;">
        <div class="bg-white p-4 rounded shadow-sm">
            <h4 class="mb-3 fw-bold text-dark border-bottom pb-2">Xác nhận thao tác</h4>
            
            <c:if test="${empty rule}">
                <div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> Không tìm thấy quy tắc giá.</div>
                <div class="mt-4 pt-3 border-top text-end">
                    <a href="${pageContext.request.contextPath}/admin/pricing" class="btn btn-secondary">Quay lại</a>
                </div>
            </c:if>
            
            <c:if test="${not empty rule}">
                <p class="fs-5 mt-4">
                    Bạn có chắc chắn muốn xóa quy tắc giá 
                    <strong class="text-danger">#${rule.ruleID}</strong>?
                </p>
                
                <div class="card bg-light mb-4 text-start">
                    <div class="card-body py-2">
                        <ul class="list-unstyled mb-0">
                            <li><strong>Loại xe:</strong> 
                                <c:choose>
                                    <c:when test="${rule.typeID == '1'}">Ô Tô (1)</c:when>
                                    <c:when test="${rule.typeID == '2'}">Xe Máy (2)</c:when>
                                    <c:otherwise>Xe Đạp (3)</c:otherwise>
                                </c:choose>
                            </li>
                            <li><strong>Khung giờ:</strong> ${rule.startHour}h — ${rule.endHour}h</li>
                            <li><strong>Giá tiền:</strong> <span class="text-success fw-bold"><fmt:formatNumber value="${rule.price}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/></span></li>
                        </ul>
                    </div>
                </div>
                
                <div class="alert alert-warning small">
                    <i class="fas fa-info-circle"></i> Hành động này không thể hoàn tác. Các giao dịch cũ sử dụng quy tắc này sẽ không bị ảnh hưởng, nhưng thẻ mới phát sinh trong khung giờ này sẽ không được tính giá theo quy tắc này nữa.
                </div>
                
                <form action="${pageContext.request.contextPath}/admin/pricing/delete" method="post" class="mt-4 pt-3 border-top text-end">
                    <input type="hidden" name="id" value="${rule.ruleID}" />
                    <a href="${pageContext.request.contextPath}/admin/pricing" class="btn btn-light border me-2">Hủy bỏ</a>
                    <input type="submit" class="btn btn-danger fw-bold" value="Có, Xóa quy tắc">
                </form>
            </c:if>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
