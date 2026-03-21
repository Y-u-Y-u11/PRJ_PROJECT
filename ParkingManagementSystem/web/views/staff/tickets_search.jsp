<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Tra Cứu Gửi Xe</h2>
    <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-secondary">Quay lại</a>
</div>

<div class="card shadow-sm mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/staff/tickets/search" method="GET" class="d-flex w-50">
            <input type="text" name="keyword" class="form-control me-2" placeholder="Biển số xe hoặc Mã Vé" value="${keyword}" required>
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
        </form>
    </div>
</div>

<c:if test="${not empty keyword}">
    <div class="card shadow-sm border-info mt-3">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0">Kết quả Tìm kiếm cho "${keyword}"</h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty tickets}">
                    <table class="table table-bordered mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Mã Vé</th>
                                <th>Biển số</th>
                                <th>Giờ vào</th>
                                <th>Ô đỗ</th>
                                <th>Khách hàng</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${tickets}">
                                <tr>
                                    <td><a href="${pageContext.request.contextPath}/staff/tickets/checkout?ticketCode=${t.ticketCode}">${t.ticketCode}</a></td>
                                    <td>${t.plateNumber}</td>
                                    <td>${t.checkInTime}</td>
                                    <td>${t.slotID}</td>
                                    <td>${t.customerID}</td>
                                    <td><span class="badge bg-warning text-dark">${t.status}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p class="text-danger mb-0">Không tìm thấy xe đang đỗ nào với từ khóa này.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</c:if>

<jsp:include page="/views/layout/footer.jsp" />
