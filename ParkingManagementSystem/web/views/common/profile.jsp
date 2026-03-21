<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row w-100 justify-content-center mt-5">
    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Thông tin cá nhân</h5>
            </div>
            <div class="card-body">
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${successMessage}</div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/common/profile" method="POST">
                    <div class="mb-3">
                        <label class="form-label">Tài khoản</label>
                        <input type="text" class="form-control" value="${sessionScope.LOGIN_USER.username}" readonly disabled>
                        <div class="form-text">Tài khoản và chức vụ mặc định không thể thay đổi.</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Vai trò</label>
                        <input type="text" class="form-control" value="${sessionScope.LOGIN_USER.role}" readonly disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Họ tên</label>
                        <input type="text" class="form-control" name="fullName" value="${sessionScope.LOGIN_USER.fullName}" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    <a href="javascript:history.back()" class="btn btn-secondary">Quay lại</a>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />