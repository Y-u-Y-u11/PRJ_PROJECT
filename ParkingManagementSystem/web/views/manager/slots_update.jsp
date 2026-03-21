<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row w-100 justify-content-center">
    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Cập nhật Ô đỗ xe</h5>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/manager/slots/update" method="POST">
                    <input type="hidden" name="id" value="${slot.id}">
                    <div class="mb-3">
                        <label class="form-label">Mã Ô đỗ mới</label>
                        <input type="text" class="form-control" name="code" value="${slot.code}" required autofocus>
                    </div>
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    <a href="${pageContext.request.contextPath}/manager/slots" class="btn btn-secondary">Hủy</a>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />
