<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row w-100 justify-content-center">
    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Cập nhật Nhân viên</h5>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/manager/users/update" method="POST">
                    <input type="hidden" name="id" value="${staff.id}">
                    <div class="mb-3">
                        <label class="form-label">Tài khoản</label>
                        <input type="text" class="form-control" value="${staff.username}" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Họ tên</label>
                        <input type="text" class="form-control" name="fullName" value="${staff.fullName}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="active" <c:if test="${staff.status == 'active'}">selected</c:if>>Hoạt động</option>
                            <option value="inactive" <c:if test="${staff.status == 'inactive'}">selected</c:if>>Vô hiệu hóa</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                    <a href="${pageContext.request.contextPath}/manager/users" class="btn btn-secondary">Hủy</a>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
