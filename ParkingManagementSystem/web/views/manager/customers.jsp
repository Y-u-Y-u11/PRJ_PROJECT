<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="animate-fade-in">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0">Danh sách Khách hàng</h2>
            <p class="text-muted small mb-0">Quản lý toàn bộ thông tin khách hàng trong hệ thống.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/manager/customers/create" class="btn btn-primary shadow-sm d-flex align-items-center gap-2 px-4 py-2" style="border-radius: 0.75rem;">
                <i class="bi bi-person-plus-fill"></i>
                <span class="fw-bold">Thêm khách hàng</span>
            </a>
            <span class="badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill d-flex align-items-center">Manager View</span>
        </div>
    </div>

    <c:if test="${param.success == 'created'}">
        <div class="alert alert-success bg-success bg-opacity-10 text-success border-0 mb-4 animate-fade-in" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            Thêm khách hàng thành công!
        </div>
    </c:if>
    <c:if test="${param.success == 'updated'}">
        <div class="alert alert-success bg-success bg-opacity-10 text-success border-0 mb-4 animate-fade-in" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            Cập nhật thông tin khách hàng thành công!
        </div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
        <div class="alert alert-success bg-success bg-opacity-10 text-success border-0 mb-4 animate-fade-in" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            Xóa khách hàng thành công!
        </div>
    </c:if>

    <!-- Modern Search Card -->
    <div class="card shadow-sm mb-5 border-0">
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/manager/customers" method="GET" class="row g-3">
                <div class="col-md-9">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0 text-muted">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text" name="keyword" class="form-control border-start-0 ps-0" placeholder="Tìm kiếm theo tên hoặc số điện thoại..." value="<c:out value='${keyword}'/>">
                    </div>
                </div>
                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary w-100 shadow-sm">Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/manager/customers" class="btn btn-light border w-100">Xóa lọc</a>
                </div>
            </form>
        </div>
    </div>

    <div class="animate-fade-in" style="animation-delay: 0.2s;">
        <c:choose>
            <c:when test="${not empty customers}">
                <div class="row g-4">
                    <c:forEach var="c" items="${customers}">
                        <div class="col-md-6 col-lg-4">
                            <div class="card h-100 border-0 shadow-sm customer-card">
                                <div class="card-body p-4">
                                    <div class="d-flex align-items-start justify-content-between mb-3">
                                        <div class="avatar bg-soft-primary text-primary rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                                            <span class="fw-bold h5 mb-0">${c.name.substring(0, 1).toUpperCase()}</span>
                                        </div>
                                        <span class="badge bg-light text-muted border small">ID: #${c.id}</span>
                                    </div>
                                    <h5 class="card-title fw-bold mb-1">${c.name}</h5>
                                    <p class="text-muted mb-0 d-flex align-items-center smaller">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-telephone me-2 text-primary" viewBox="0 0 16 16">
                                          <path d="M3.654 1.328a.678.678 0 0 0-1.015-.063L1.605 2.3c-.483.484-.661 1.169-.45 1.77a17.568 17.568 0 0 0 4.168 6.608 17.569 17.569 0 0 0 6.608 4.168c.601.211 1.286.033 1.77-.45l1.034-1.034a.678.678 0 0 0-.063-1.015l-2.307-1.794a.678.678 0 0 0-.58-.122l-2.19.547a1.745 1.745 0 0 1-1.657-.459L5.482 8.062a1.745 1.745 0 0 1-.46-1.657l.548-2.19a.678.678 0 0 0-.122-.58L3.654 1.328zM1.884.511a1.745 1.745 0 0 1 2.612.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.678.678 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>
                                        </svg>
                                        ${c.phone}
                                    </p>
                                </div>
                                <div class="card-footer bg-white border-0 pt-0 pb-4 px-4 d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/manager/customers/view?id=${c.id}" class="btn btn-sm btn-outline-primary flex-grow-1 rounded-pill">Chi tiết</a>
                                    <a href="${pageContext.request.contextPath}/manager/customers/edit?id=${c.id}" class="btn btn-sm btn-light border flex-grow-1 rounded-pill"><i class="bi bi-pencil"></i></a>
                                    <a href="${pageContext.request.contextPath}/manager/customers/delete?id=${c.id}" class="btn btn-sm btn-outline-danger flex-grow-1 rounded-pill"><i class="bi bi-trash"></i></a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card text-center p-5 border-0 shadow-sm bg-white animate-fade-in text-muted">
                    <i class="bi bi-people h1 d-block mb-3"></i>
                    <h4>Không tìm thấy khách hàng nào</h4>
                    <p>Thử tìm kiếm với từ khóa khác hoặc xóa lọc.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<style>
    .customer-card:hover {
        border-bottom: 3px solid var(--primary) !important;
    }
    .smaller { font-size: 0.85rem; }
</style>

<jsp:include page="/views/layout/footer.jsp" />