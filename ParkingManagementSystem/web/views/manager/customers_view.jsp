<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row">
    <div class="col-md-4">
        <div class="card shadow-sm">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">Hồ sơ khách hàng</h5>
            </div>
            <div class="card-body">
                <p><strong>ID:</strong> ${customer.id}</p>
                <p><strong>Họ tên:</strong> ${customer.name}</p>
                <p><strong>Số ĐT:</strong> ${customer.phone}</p>
            </div>
        </div>
    </div>
    
    <div class="col-md-8">
        <div class="card shadow-sm">
            <div class="card-header bg-danger text-white">
                <h5 class="mb-0">Lịch sử vi phạm</h5>
            </div>
            <div class="card-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Mã Vi phạm</th>
                            <th>Lý do</th>
                            <th>Số tiền</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="v" items="${violations}">
                            <tr>
                                <td>${v.id}</td>
                                <td>${v.reason}</td>
                                <td>${v.fine}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.status == 'Unpaid'}"><span class="badge bg-warning text-dark">Chưa thanh toán</span></c:when>
                                        <c:when test="${v.status == 'Paid'}"><span class="badge bg-success">Đã thanh toán</span></c:when>
                                        <c:when test="${v.status == 'Voided'}"><span class="badge bg-secondary">Hủy bỏ</span></c:when>
                                    </c:choose>
                                </td>
                                <td>${v.createdAt}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty violations}">
                            <tr><td colspan="5" class="text-center">Khách hàng không có vi phạm nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
                <a href="${pageContext.request.contextPath}/manager/customers" class="btn btn-secondary mt-2">Đóng</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
