<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Vi Phạm - Parking Management</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body class="bg-light">

<jsp:include page="../header.jsp"/>
<jsp:include page="../sidebar.jsp"/>

<div class="bg-white p-4 rounded shadow-sm main-content">

    <!-- Title -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0">Quản lý Vi Phạm</h4>
    </div>

    <!-- Search + Add -->
    <div class="d-flex justify-content-between align-items-center mb-3 gap-2">
        <form action="${pageContext.request.contextPath}/admin/violations" method="GET"
              class="d-flex align-items-center gap-2 flex-grow-1" style="max-width:480px;">
            <input type="hidden" name="sort" value="${sort}">
            <input type="hidden" name="order" value="${order}">

            <div class="input-group">
                <span class="input-group-text bg-white">
                    <i class="fas fa-search text-muted"></i>
                </span>

                <input type="text" name="search" class="form-control border-start-0"
                       placeholder="Tìm kiếm..." value="${searchKeyword}">

                <c:if test="${not empty searchKeyword}">
                    <a href="${pageContext.request.contextPath}/admin/violations?sort=${sort}&order=${order}"
                       class="btn btn-outline-danger">
                        <i class="fas fa-times"></i>
                    </a>
                </c:if>

                <button class="btn btn-outline-secondary">Tìm</button>
            </div>
        </form>

        <a href="${pageContext.request.contextPath}/admin/violations/add"
           class="btn btn-navy shadow-sm">
            <i class="fas fa-plus me-1"></i> Thêm
        </a>
    </div>

    <!-- Table -->
    <div class="table-responsive border rounded">
        <table class="table table-hover align-middle mb-0">

            <thead class="table-light text-muted">
            <tr>
                <th class="ps-3">
                    <a class="sort-link"
                       href="?sort=violationID&order=${sort == 'violationID' && order == 'asc' ? 'desc' : 'asc'}">
                        ID
                        <span class="sort-icon ${sort == 'violationID' ? 'active' : ''}">⇅</span>
                    </a>
                </th>

                <th>
                    <a class="sort-link"
                       href="?sort=ticketID&order=${sort == 'ticketID' && order == 'asc' ? 'desc' : 'asc'}">
                        Mã Vé
                        <span class="sort-icon ${sort == 'ticketID' ? 'active' : ''}">⇅</span>
                    </a>
                </th>

                <th>Người Vi Phạm</th>
                <th>Biển Số Xe</th>
                <th>Lý Do</th>

                <th class="text-end pe-4">
                    <a class="sort-link justify-content-end"
                       href="?sort=fineAmount&order=${sort == 'fineAmount' && order == 'asc' ? 'desc' : 'asc'}">
                        Tiền Phạt
                        <span class="sort-icon ${sort == 'fineAmount' ? 'active' : ''}">⇅</span>
                    </a>
                </th>

                <th class="text-center">Hành Động</th>
            </tr>
            </thead>

            <tbody>

            <!-- Empty -->
            <c:if test="${empty violations}">
                <tr>
                    <td colspan="7" class="text-center text-muted py-5">
                        <i class="fas fa-box-open fa-3x mb-3 d-block"></i>
                        Chưa có dữ liệu vi phạm
                    </td>
                </tr>
            </c:if>

            <!-- Data -->
            <c:forEach items="${violations}" var="v">
                <tr>
                    <td class="ps-3 text-muted">#${v.violationID}</td>
                    <td class="fw-bold">${v.ticketID}</td>

                    <td class="fw-bold text-primary">${v.customerName}</td>

                    <td>
                        <span class="badge bg-light text-dark border px-2 py-1 fw-medium">
                            ${v.plateNumber}
                        </span>
                    </td>

                    <td>${v.reason}</td>

                    <td class="text-end text-danger fw-bold pe-4">
                        <fmt:formatNumber value="${v.fineAmount}"
                                          type="currency"
                                          currencySymbol="VNĐ"
                                          maxFractionDigits="0"/>
                    </td>

                    <!-- Action -->
                    <td class="text-center">
                        <div class="d-flex justify-content-center gap-2">

                            <form action="${pageContext.request.contextPath}/admin/violations/edit" method="GET">
                                <input type="hidden" name="id" value="${v.violationID}">
                                <button class="btn-action-custom btn-edit-custom">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </button>
                            </form>

                            <form action="${pageContext.request.contextPath}/admin/violations/delete"
                                  method="GET"
                                  onsubmit="return confirm('Bạn chắc chắn muốn xóa vi phạm này?');">
                                <input type="hidden" name="id" value="${v.violationID}">
                                <button class="btn-action-custom btn-delete-custom">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>
                            </form>

                        </div>
                    </td>
                </tr>
            </c:forEach>

            </tbody>
        </table>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>