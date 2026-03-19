<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quy Tắc Giá - Parking Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <style>
        .table-action-btn {
            width: 32px; height: 32px; padding: 0;
            display: inline-flex; align-items: center; justify-content: center;
            border-radius: 4px;
        }
        .sort-link {
            color: inherit; text-decoration: none; display: inline-flex;
            align-items: center; gap: 5px; white-space: nowrap; font-weight: 600;
        }
        .sort-link:hover { color: #1a3c6e; }
        .sort-icon { font-size: 0.7rem; opacity: 0.4; }
        .sort-icon.active { opacity: 1; color: #1a3c6e; }
    </style>
</head>
<body>
    <jsp:include page="../header.jsp" />
    <jsp:include page="../sidebar.jsp" />

    <div class="bg-white p-4 rounded shadow-sm">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="mb-0 fw-bold text-dark">Quy Tắc Giá &amp; Thời Gian</h4>
        </div>

        <!-- Add button -->
        <div class="d-flex justify-content-end align-items-center mb-3">
            <a href="${pageContext.request.contextPath}/admin/pricing/add" class="btn btn-navy shadow-sm">
                <i class="fas fa-plus me-1"></i> Thêm Quy Tắc
            </a>
        </div>

        <!-- Flash messages -->
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-1"></i> ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-1"></i> ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Pricing table -->
        <div class="table-responsive border rounded">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light text-muted">
                    <tr>
                        <!-- Sortable: Rule ID -->
                        <th class="ps-3">
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/pricing?sort=ruleID&order=${sort == 'ruleID' ? nextOrder : 'asc'}">
                                Mã Quy Tắc
                                <span class="sort-icon${sort == 'ruleID' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'ruleID' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'ruleID' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <!-- Sortable: Vehicle Type -->
                        <th>
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/pricing?sort=typeID&order=${sort == 'typeID' ? nextOrder : 'asc'}">
                                Loại Xe
                                <span class="sort-icon${sort == 'typeID' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'typeID' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'typeID' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <!-- Sortable: Start Hour -->
                        <th>
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/pricing?sort=startHour&order=${sort == 'startHour' ? nextOrder : 'asc'}">
                                Giờ Bắt Đầu
                                <span class="sort-icon${sort == 'startHour' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'startHour' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'startHour' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <!-- Sortable: End Hour -->
                        <th>
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/pricing?sort=endHour&order=${sort == 'endHour' ? nextOrder : 'asc'}">
                                Giờ Kết Thúc
                                <span class="sort-icon${sort == 'endHour' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'endHour' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'endHour' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <!-- Sortable: Price -->
                        <th class="text-end pe-4">
                            <a class="sort-link justify-content-end"
                               href="${pageContext.request.contextPath}/admin/pricing?sort=price&order=${sort == 'price' ? nextOrder : 'asc'}">
                                Giá Tiền (VNĐ)
                                <span class="sort-icon${sort == 'price' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'price' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'price' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <th class="text-center">Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty rules}">
                            <c:forEach items="${rules}" var="rule">
                                <tr>
                                    <td class="ps-3 fw-medium text-muted">#${rule.ruleID}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${rule.typeID == '1'}">
                                                <span class="badge bg-primary bg-opacity-10 text-primary border border-primary px-2 py-1">Ô Tô (1)</span>
                                            </c:when>
                                            <c:when test="${rule.typeID == '2'}">
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success px-2 py-1">Xe Máy (2)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary px-2 py-1">Xe Đạp (3)</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-medium text-dark">${rule.startHour}h</td>
                                    <td class="fw-medium text-dark">${rule.endHour}h</td>
                                    <td class="fw-bold text-success text-end pe-4 fs-6">
                                        <fmt:formatNumber value="${rule.price}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/>
                                    </td>
                                    <td class="text-center">
                                        <form action="${pageContext.request.contextPath}/admin/pricing/edit" method="GET" style="display:inline;">
                                            <input type="hidden" name="id" value="${rule.ruleID}">
                                            <input type="submit" class="btn btn-warning text-white table-action-btn me-1" value="✎" title="Sửa">
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/pricing/delete" method="GET" style="display:inline;">
                                            <input type="hidden" name="id" value="${rule.ruleID}">
                                            <input type="submit" class="btn btn-danger table-action-btn" value="✕" title="Xóa">
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-5">
                                    <i class="fas fa-box-open fa-3x mb-3 text-black-50 d-block"></i>
                                    Chưa có cấu hình quy tắc giá nào.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>