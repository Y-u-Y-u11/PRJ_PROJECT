<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/views/layout/header.jsp" />

<div class="row justify-content-center pt-5">
    <div class="col-md-5">
        <div class="card shadow-sm border-0 rounded-4 overflow-hidden text-center">
            <div class="card-body p-5">
                <div class="mb-4">
                    <i class="bi bi-person-x text-danger opacity-25" style="font-size: 5rem;"></i>
                </div>
                <h3 class="fw-bold mb-3">Xác nhận xóa khách hàng?</h3>
                <p class="text-muted mb-4 fs-5">Bạn có chắc chắn muốn xóa khách hàng <strong>${customer.name}</strong> (${customer.phone})?</p>
                <p class="text-secondary small mb-4">Hành động này sẽ gỡ liên kết thông tin khách hàng khỏi lịch sử các vé và thẻ tháng cũ.</p>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger mb-4" role="alert">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/${sessionScope.LOGIN_USER.role}/customers/delete" method="POST">
                    <input type="hidden" name="id" value="${customer.id}">
                    <div class="d-flex gap-3">
                        <a href="${pageContext.request.contextPath}/${sessionScope.LOGIN_USER.role}/customers" class="btn btn-light rounded-3 py-2 flex-grow-1 fw-semibold">Hủy bỏ</a>
                        <button type="submit" class="btn btn-danger rounded-3 py-2 flex-grow-1 fw-semibold">Xác nhận xóa</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
