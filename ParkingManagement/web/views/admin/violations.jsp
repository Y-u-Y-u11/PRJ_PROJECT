<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Vi Phạm - Parking Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <style>
        .table-action-btn {
            width: 32px; height: 32px; padding: 0;
            display: inline-flex; align-items: center; justify-content: center;
            border-radius: 4px;
        }
        /* Sortable column headers */
        .sort-link {
            color: inherit; text-decoration: none; display: inline-flex;
            align-items: center; gap: 5px; white-space: nowrap; font-weight: 600;
        }
        .sort-link:hover { color: #1a3c6e; }
        .sort-icon { font-size: 0.7rem; opacity: 0.4; }
        .sort-icon.active { opacity: 1; color: #1a3c6e; }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="../header.jsp" />
    <jsp:include page="../sidebar.jsp" />

    <!-- Main content -->
    <div class="bg-white p-4 rounded shadow-sm">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="mb-0 fw-bold text-dark">Quản lý Vi Phạm</h4>
        </div>

        <!-- Toolbar: Search + Add button -->
        <div class="d-flex justify-content-between align-items-center mb-3 gap-2">
            <form action="${pageContext.request.contextPath}/admin/violations" method="GET"
                  class="d-flex align-items-center gap-2 flex-grow-1" style="max-width:480px;">
                <input type="hidden" name="sort" value="${sort}">
                <input type="hidden" name="order" value="${order}">
                <div class="input-group">
                    <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                    <input type="text" name="search" class="form-control border-start-0"
                           placeholder="Tìm kiếm theo mã thẻ hoặc lý do..." value="${searchKeyword}">
                    <c:if test="${not empty searchKeyword}">
                        <a href="${pageContext.request.contextPath}/admin/violations?sort=${sort}&order=${order}"
                           class="btn btn-outline-danger" title="Xóa bộ lọc"><i class="fas fa-times"></i></a>
                    </c:if>
                    <input type="submit" class="btn btn-outline-secondary" value="Tìm kiếm">
                </div>
            </form>

            <a href="${pageContext.request.contextPath}/admin/violations/add" class="btn btn-navy shadow-sm flex-shrink-0">
                <i class="fas fa-plus me-1"></i> Ghi nhận Vi Phạm
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

        <!-- Results count -->
        <c:if test="${not empty searchKeyword}">
            <div class="text-muted small mb-2">
                Kết quả cho: <strong>"${searchKeyword}"</strong>
                &mdash; <strong>${violations.size()}</strong> bản ghi được tìm thấy.
            </div>
        </c:if>

        <!-- Table -->
        <div class="table-responsive border rounded">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light text-muted">
                    <tr>
                        <!-- Sortable: Violation ID -->
                        <th class="ps-3">
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/violations?sort=violationID&order=${sort == 'violationID' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                ID Vi Phạm
                                <span class="sort-icon${sort == 'violationID' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'violationID' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'violationID' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <!-- Sortable: Ticket ID -->
                        <th>
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/violations?sort=ticketID&order=${sort == 'ticketID' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Mã Thẻ / Số Xe ID
                                <span class="sort-icon${sort == 'ticketID' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'ticketID' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'ticketID' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <!-- Sortable: Reason -->
                        <th>
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/violations?sort=reason&order=${sort == 'reason' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Lý Do Vi Phạm
                                <span class="sort-icon${sort == 'reason' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'reason' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'reason' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <!-- Sortable: Fine Amount -->
                        <th class="text-end pe-4">
                            <a class="sort-link justify-content-end"
                               href="${pageContext.request.contextPath}/admin/violations?sort=fineAmount&order=${sort == 'fineAmount' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Tiền Phạt (VNĐ)
                                <span class="sort-icon${sort == 'fineAmount' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'fineAmount' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'fineAmount' && order == 'desc'}">▼</c:when>
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
                        <c:when test="${not empty violations}">
                            <c:forEach items="${violations}" var="v">
                                <tr>
                                    <td class="ps-3 fw-medium text-muted">#${v.violationID}</td>
                                    <td class="fw-bold text-dark">${v.ticketID}</td>
                                    <td>${v.reason}</td>
                                    <td class="fw-bold text-danger text-end pe-4 fs-6">
                                        <fmt:formatNumber value="${v.fineAmount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/>
                                    </td>
                                    <td class="text-center">
                                        <form action="${pageContext.request.contextPath}/admin/violations/edit" method="GET" style="display:inline;">
                                            <input type="hidden" name="id" value="${v.violationID}">
                                            <input type="submit" class="btn btn-warning text-white table-action-btn me-1" value="✎" title="Sửa">
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/violations/delete" method="GET" style="display:inline;">
                                            <input type="hidden" name="id" value="${v.violationID}">
                                            <input type="submit" class="btn btn-danger table-action-btn" value="✕" title="Xóa">
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-5">
                                    <i class="fas fa-box-open fa-3x mb-3 text-black-50 d-block"></i>
                                    <c:choose>
                                        <c:when test="${not empty searchKeyword}">Không tìm thấy vi phạm nào khớp với tìm kiếm.</c:when>
                                        <c:otherwise>Chưa có dữ liệu vi phạm.</c:otherwise>
                                    </c:choose>
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
