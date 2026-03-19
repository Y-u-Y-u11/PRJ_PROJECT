<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Vi Phạm - Parking Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <style>
        .required-asterisk { color: red; }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="../header.jsp" />
    <jsp:include page="../sidebar.jsp" />

    <div class="container mt-4 mb-5" style="max-width: 600px;">
        <div class="bg-white p-4 rounded shadow-sm">
            <h4 class="mb-4 fw-bold text-dark border-bottom pb-2">Ghi Nhận Vi Phạm Mới</h4>

            <c:if test="${not empty ticketLoadError}">
                <div class="alert alert-warning small">
                    <i class="fas fa-exclamation-triangle me-1"></i>
                    Không thể tải danh sách thẻ. Vui lòng nhập mã thẻ thủ công.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/violations" method="POST">
                <input type="hidden" name="action" value="add">

                <div class="mb-3">
                    <label class="form-label fw-medium text-dark">
                        Mã Thẻ <span class="required-asterisk">*</span>
                    </label>
                    <c:choose>
                        <c:when test="${not empty tickets}">
                            <select name="ticketID" class="form-select" required>
                                <option value="" selected disabled>-- Chọn Thẻ / Xe --</option>
                                <c:forEach items="${tickets}" var="t">
                                    <option value="${t.ticketID}">
                                        #${t.ticketID} &mdash; Xe: ${t.vehicleID} (${t.status})
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="form-text">Chọn thẻ đỗ xe liên quan đến vi phạm này.</div>
                        </c:when>
                        <c:otherwise>
                            <input type="text" name="ticketID" class="form-control"
                                   placeholder="e.g. T001 or 29A-123.45" required>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-medium text-dark">
                        Lý Do Vi Phạm <span class="required-asterisk">*</span>
                    </label>
                    <textarea name="reason" class="form-control" rows="3" placeholder="Ví dụ: Đỗ sai nơi quy định..." required></textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-medium text-dark">
                        Tiền Phạt (VNĐ) <span class="required-asterisk">*</span>
                    </label>
                    <div class="input-group">
                        <input type="number" name="fineAmount" class="form-control" placeholder="Ví dụ: 50000" min="0" step="1000" required>
                        <span class="input-group-text bg-light fw-bold text-muted">VNĐ</span>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/admin/violations"
                       class="btn btn-light border px-4">Hủy</a>
                    <input type="submit" class="btn btn-navy px-4" value="Lưu Vi Phạm">
                </div>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
