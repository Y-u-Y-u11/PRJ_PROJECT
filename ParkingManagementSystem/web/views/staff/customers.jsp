<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Tra cứu Khách hàng (Staff)</h2>
</div>

<div class="card shadow-sm mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/staff/customers" method="GET" class="d-flex w-50">
            <input type="text" name="keyword" class="form-control me-2" placeholder="Tên hoặc Số điện thoại" value="${keyword}" required>
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            <a href="${pageContext.request.contextPath}/staff/customers" class="btn btn-outline-secondary ms-2">Bỏ lọc</a>
        </form>
    </div>
</div>

<c:if test="${not empty keyword || not empty customers}">
    <div class="card shadow-sm border-info mt-3">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0">Kết quả</h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty customers}">
                    <table class="table table-bordered mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Họ tên</th>
                                <th>Số ĐT</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${customers}">
                                <tr>
                                    <td>${c.id}</td>
                                    <td>${c.name}</td>
                                    <td>${c.phone}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p class="text-danger mb-0">Không tìm thấy khách hàng nào.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</c:if>

<jsp:include page="/views/layout/footer.jsp" />