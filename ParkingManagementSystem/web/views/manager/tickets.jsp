<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Danh sách Vé đỗ xe (Parking Tickets)</h2>
</div>

<div class="card shadow-sm mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/manager/tickets" method="GET" class="row gx-3 gy-2 align-items-center">
            <div class="col-sm-4">
                <input type="text" name="keyword" class="form-control" placeholder="Mã vé hoặc biển số" value="${keyword}">
            </div>
            <div class="col-sm-3">
                <select name="status" class="form-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="Parking" <c:if test="${statusFilter == 'Parking'}">selected</c:if>>Parking</option>
                    <option value="Completed" <c:if test="${statusFilter == 'Completed'}">selected</c:if>>Completed</option>
                    <option value="Lost_Ticket" <c:if test="${statusFilter == 'Lost_Ticket'}">selected</c:if>>Lost Ticket</option>
                    <option value="Voided" <c:if test="${statusFilter == 'Voided'}">selected</c:if>>Voided</option>
                </select>
            </div>
            <div class="col-sm-2">
                <button type="submit" class="btn btn-primary w-100">Lọc</button>
            </div>
            <div class="col-sm-2">
                <a href="${pageContext.request.contextPath}/manager/tickets" class="btn btn-outline-secondary w-100">Bỏ lọc</a>
            </div>
        </form>
    </div>
</div>

<div class="card shadow-sm">
    <div class="card-body">
        <table class="table table-hover table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Mã Vé</th>
                    <th>Biển số</th>
                    <th>Trạng thái</th>
                    <th>Thời gian vào</th>
                    <th>Thời gian ra</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="t" items="${tickets}">
                    <tr>
                        <td><strong>${t.ticketCode}</strong></td>
                        <td>${t.plateNumber != null ? t.plateNumber : 'Không có'}</td>
                        <td>
                            <c:choose>
                                <c:when test="${t.status == 'Parking'}"><span class="badge bg-warning text-dark">Đang đỗ</span></c:when>
                                <c:when test="${t.status == 'Completed'}"><span class="badge bg-success">Đã hoàn thành</span></c:when>
                                <c:when test="${t.status == 'Lost_Ticket'}"><span class="badge bg-danger">Mất vé</span></c:when>
                                <c:when test="${t.status == 'Voided'}"><span class="badge bg-secondary">Bị huỷ</span></c:when>
                            </c:choose>
                        </td>
                        <td>${t.checkInTime}</td>
                        <td>${t.checkOutTime != null ? t.checkOutTime : '--'}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/manager/tickets/view?id=${t.id}" class="btn btn-sm btn-outline-info">Chi tiết</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty tickets}">
                    <tr><td colspan="6" class="text-center text-muted">Không có dữ liệu</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
