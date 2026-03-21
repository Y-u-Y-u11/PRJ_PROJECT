<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row w-100 justify-content-center">
    <div class="col-md-8">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0">Check-out: Xử lý Vé Ra</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/staff/tickets/checkout" method="GET" class="d-flex w-75 mx-auto">
                    <input type="text" name="ticketCode" class="form-control me-2" placeholder="Nhập Mã Vé (Ticket Code)" value="${ticketCode}" required autofocus>
                    <button type="submit" class="btn btn-primary">Tìm Vé</button>
                </form>
            </div>
        </div>

        <c:if test="${ticket != null}">
            <div class="card shadow-sm border-success">
                <div class="card-header bg-light">
                    <h5 class="mb-0 text-success">Thông tin Vé: ${ticket.ticketCode}</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Biển số:</strong> ${ticket.plateNumber}</p>
                            <p><strong>Trạng thái:</strong> ${ticket.status}</p>
                            <p><strong>Giờ vào:</strong> ${ticket.checkInTime}</p>
                        </div>
                        <div class="col-md-6 text-end">
                            <c:choose>
                                <c:when test="${ticket.status == 'Parking'}">
                                    <form action="${pageContext.request.contextPath}/staff/payments/process" method="GET">
                                        <input type="hidden" name="ticketId" value="${ticket.id}">
                                        <button type="submit" class="btn btn-success btn-lg">Tiến hành Thanh toán</button>
                                    </form>
                                    <!-- Nút ghi vi phạm ẩn hoặc hiển thị riêng -->
                                    <a href="${pageContext.request.contextPath}/staff/violations/create?ticketId=${ticket.id}" class="btn btn-outline-danger mt-2">Thêm Vi phạm</a>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-danger fw-bold">Vé này không trong trạng thái đang đỗ.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <c:if test="${ticket == null && not empty ticketCode}">
            <div class="alert alert-danger text-center mt-3">
                Không tìm thấy Vé Đỗ nào khớp với mã "${ticketCode}".
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
