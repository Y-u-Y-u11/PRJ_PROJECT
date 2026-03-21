<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/views/layout/header.jsp" />

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card shadow-sm border-0 rounded-4 overflow-hidden">
            <div class="card-header bg-white py-3 border-bottom-0">
                <h4 class="mb-0 fw-bold text-gradient">Sửa thông tin khách hàng</h4>
            </div>
            <div class="card-body p-4">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger rounded-3" role="alert">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/${sessionScope.LOGIN_USER.role}/customers/edit" method="POST">
                    <input type="hidden" name="id" value="${customer.id}">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Họ và tên</label>
                        <input type="text" name="name" class="form-control rounded-3 py-2" value="${customer.name}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Số điện thoại</label>
                        <input type="text" name="phone" class="form-control rounded-3 py-2" value="${customer.phone}" required>
                    </div>
                    
                    <div class="d-flex gap-2 mt-4">
                        <a href="${pageContext.request.contextPath}/${sessionScope.LOGIN_USER.role}/customers" class="btn btn-light rounded-3 px-4 flex-grow-1">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary rounded-3 px-4 flex-grow-1">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
