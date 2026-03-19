<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quy Tắc Giá - Parking Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<jsp:include page="../header.jsp"/>
<jsp:include page="../sidebar.jsp"/>

<div class="bg-white p-4 rounded shadow-sm main-content">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0">Quy Tắc Giá &amp; Thời Gian</h4>
    </div>

    <div class="d-flex justify-content-end mb-3">
        <a href="${pageContext.request.contextPath}/admin/pricing/add"
           class="btn btn-navy">
            <i class="fas fa-plus"></i> Thêm Quy Tắc
        </a>
    </div>

    <!-- Flash -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">${sessionScope.message}</div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger">${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <div class="table-responsive border rounded">
        <table class="table table-hover align-middle mb-0">

            <thead class="table-light">
            <tr>

                <th>
                    <a class="sort-link"
                       href="?sort=ruleID&order=${sort == 'ruleID' && order == 'asc' ? 'desc' : 'asc'}">
                        Mã
                        <span class="sort-icon ${sort == 'ruleID' ? 'active' : ''}">
                            <c:if test="${sort == 'ruleID'}">
                                <c:out value="${order == 'asc' ? '▲' : '▼'}"/>
                            </c:if>
                            <c:if test="${sort != 'ruleID'}">⇅</c:if>
                        </span>
                    </a>
                </th>

                <th>
                    <a class="sort-link"
                       href="?sort=typeID&order=${sort == 'typeID' && order == 'asc' ? 'desc' : 'asc'}">
                        Loại Xe
                        <span class="sort-icon ${sort == 'typeID' ? 'active' : ''}">
                            <c:if test="${sort == 'typeID'}">
                                <c:out value="${order == 'asc' ? '▲' : '▼'}"/>
                            </c:if>
                            <c:if test="${sort != 'typeID'}">⇅</c:if>
                        </span>
                    </a>
                </th>

                <th>Giờ Bắt Đầu</th>
                <th>Giờ Kết Thúc</th>

                <th class="text-end">
                    <a class="sort-link"
                       href="?sort=price&order=${sort == 'price' && order == 'asc' ? 'desc' : 'asc'}">
                        Giá
                        <span class="sort-icon ${sort == 'price' ? 'active' : ''}">
                            <c:if test="${sort == 'price'}">
                                <c:out value="${order == 'asc' ? '▲' : '▼'}"/>
                            </c:if>
                            <c:if test="${sort != 'price'}">⇅</c:if>
                        </span>
                    </a>
                </th>

                <th class="text-center">Hành Động</th>
            </tr>
            </thead>

            <tbody>

            <c:if test="${empty rules}">
                <tr>
                    <td colspan="6" class="text-center text-muted py-5">
                        <i class="fas fa-box-open fa-2x d-block mb-2"></i>
                        Chưa có quy tắc giá
                    </td>
                </tr>
            </c:if>

            <c:forEach items="${rules}" var="rule">
                <tr>

                    <td>#${rule.ruleID}</td>

                    <td>
                        <c:choose>
                            <c:when test="${rule.typeID == 1}">
                                <span class="badge bg-primary bg-opacity-10 text-primary">Ô Tô</span>
                            </c:when>
                            <c:when test="${rule.typeID == 2}">
                                <span class="badge bg-success bg-opacity-10 text-success">Xe Máy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary bg-opacity-10 text-secondary">Xe Đạp</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>${rule.startHour}h</td>
                    <td>${rule.endHour}h</td>

                    <td class="text-end text-success fw-bold">
                        <fmt:formatNumber value="${rule.price}"
                                          type="currency"
                                          currencySymbol="VNĐ"
                                          maxFractionDigits="0"/>
                    </td>

                    <td class="text-center">
                        <div class="d-flex justify-content-center gap-2">

                            <form action="${pageContext.request.contextPath}/admin/pricing/edit" method="GET">
                                <input type="hidden" name="id" value="${rule.ruleID}">
                                <button class="btn-action-custom btn-edit-custom">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </button>
                            </form>

                            <form action="${pageContext.request.contextPath}/admin/pricing/delete"
                                  method="GET"
                                  onsubmit="return confirm('Bạn chắc chắn muốn xóa quy tắc này?');">
                                <input type="hidden" name="id" value="${rule.ruleID}">
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