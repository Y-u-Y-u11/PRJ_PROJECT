<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Lịch sử Thanh toán (All Payments)</h2>
</div>

<div class="card shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Ticket ID</th>
                        <th>Số tiền (VNĐ)</th>
                        <th>Phương thức</th>
                        <th>Trạng thái</th>
                        <th>Mã GD (Ref)</th>
                        <th>Ngày thanh toán</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${payments}">
                        <tr>
                            <td>${p.id}</td>
                            <td><a href="${pageContext.request.contextPath}/manager/tickets/view?id=${p.ticketID}">#${p.ticketID}</a></td>
                            <td class="text-success fw-bold">${p.amount}</td>
                            <td>${p.method}</td>
                            <td>
                                <span class="badge ${p.status == 'Success' ? 'bg-success' : 'bg-secondary'}">${p.status}</span>
                            </td>
                            <td>${p.referenceCode}</td>
                            <td>${p.paidAt}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty payments}">
                        <tr>
                            <td colspan="7" class="text-center text-muted">Không có giao dịch thanh toán nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
