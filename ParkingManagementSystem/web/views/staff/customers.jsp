<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="animate-fade-in">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0">Khách hàng</h2>
            <p class="text-muted small mb-0">Quản lý và tra cứu thông tin khách hàng.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/staff/customers/create" class="btn btn-primary shadow-sm d-flex align-items-center gap-2 px-4 py-2" style="border-radius: 0.75rem;">
                <i class="bi bi-person-plus-fill"></i>
                <span class="fw-bold">Thêm khách hàng</span>
            </a>
            <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill d-flex align-items-center">Staff Portal</span>
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
            <form action="${pageContext.request.contextPath}/staff/customers" method="GET" class="row g-3">
                <div class="col-md-8">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0 text-muted">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text" name="keyword" class="form-control border-start-0 ps-0" placeholder="Tìm kiếm theo tên hoặc số điện thoại..." value="${keyword}" required>
                    </div>
                </div>
                <div class="col-md-4 d-flex gap-2">
                    <button type="submit" class="btn btn-primary w-100 shadow-sm">Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/staff/customers" class="btn btn-light border w-100">Xóa lọc</a>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${not empty keyword || not empty customers}">
        <div class="animate-fade-in" style="animation-delay: 0.2s;">
            <div class="d-flex align-items-center mb-3">
                <div class="bg-primary rounded-circle p-1 me-2" style="width: 12px; height: 12px;"></div>
                <h5 class="mb-0 fw-bold">Kết quả tra cứu</h5>
            </div>
            
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
                                        <p class="text-muted mb-0 d-flex align-items-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-telephone me-2 text-primary" viewBox="0 0 16 16">
                                              <path d="M3.654 1.328a.678.678 0 0 0-1.015-.063L1.605 2.3c-.483.484-.661 1.169-.45 1.77a17.568 17.568 0 0 0 4.168 6.608 17.569 17.569 0 0 0 6.608 4.168c.601.211 1.286.033 1.77-.45l1.034-1.034a.678.678 0 0 0-.063-1.015l-2.307-1.794a.678.678 0 0 0-.58-.122l-2.19.547a1.745 1.745 0 0 1-1.657-.459L5.482 8.062a1.745 1.745 0 0 1-.46-1.657l.548-2.19a.678.678 0 0 0-.122-.58L3.654 1.328zM1.884.511a1.745 1.745 0 0 1 2.612.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.678.678 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>
                                            </svg>
                                            ${c.phone}
                                        </p>
                                    </div>
                                    <div class="card-footer bg-white border-0 pt-0 pb-4 px-4 d-flex justify-content-end gap-2">
                                        <a href="${pageContext.request.contextPath}/staff/customers/edit?id=${c.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                            <i class="bi bi-pencil-square me-1"></i>Sửa
                                        </a>
                                        <a href="${pageContext.request.contextPath}/staff/customers/delete?id=${c.id}" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                            <i class="bi bi-trash me-1"></i>Xóa
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card text-center p-5 border-0 shadow-sm bg-white animate-fade-in">
                        <div class="text-danger mb-3">
                            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" class="bi bi-person-x" viewBox="0 0 16 16">
                              <path d="M11 5a3 3 0 1 1-6 0 3 3 0 0 1 6 0ZM8 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4Zm.006 8c.003 0 .005 0 .007-.002.052-.002.12-.006.202-.012.168-.012.414-.033.717-.069 1.103-.13 2.452-.398 3.334-1.218.423-.393.634-.863.737-1.34.103-.48.1-.908.089-1.246l-.044-.287c-.036-.202-.051-.347-.353-.448a.56.56 0 0 0-.256-.007c-.43.048-1.205.158-2.022.251-.715.082-1.442.146-2.053.18-.544.032-1.087.05-1.52.05-.44 0-.98-.018-1.522-.05-.61-.034-1.338-.098-2.052-.18-.818-.093-1.593-.203-2.022-.251a.56.56 0 0 0-.256.007c-.302.101-.317.246-.353.448l-.044.287c-.011.338-.014.766.089 1.246.103.477.314.947.737 1.34.882.82 2.231 1.087 3.334 1.218.303.036.55.057.717.069a2.09 2.09 0 0 0 .202.012H8.006ZM1.333 13c0-1.111.458-2.035 1.135-2.424a1.745 1.745 0 0 1-1.272.108c-.74.74-1.065 1.846-.702 2.877.363 1.03 1.42 1.954 2.877 2.317a2.09 2.09 0 0 0 .202.012H1.333ZM16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0ZM8 1a7 7 0 1 0 0 14A7 7 0 0 0 8 1Zm3.5 6.5a.5.5 0 0 1 0 1H4.5a.5.5 0 0 1 0-1h7Z"/>
                            </svg>
                        </div>
                        <h4 class="text-muted fw-bold">Rất tiếc!</h4>
                        <p class="text-muted">Không tìm thấy khách hàng nào khớp với tên hoặc số điện thoại <strong>"${keyword}"</strong>.</p>
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/staff/customers" class="btn btn-primary px-4">Quay lại danh sách</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>
</div>

<style>
    .avatar {
        transition: transform 0.3s ease;
    }
    .customer-card:hover .avatar {
        transform: rotate(10deg);
    }
    .bg-soft-primary {
        background-color: rgba(139, 92, 246, 0.1);
    }
</style>

<jsp:include page="/views/layout/footer.jsp" />