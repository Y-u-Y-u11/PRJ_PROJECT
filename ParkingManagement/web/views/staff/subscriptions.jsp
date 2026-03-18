<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý nhân viên - Parking Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    </head>
    <body>
        <jsp:include page="/views/header.jsp" />
        <jsp:include page="/views/sidebar.jsp" />

        <div class="row mb-4 align-items-center mt-4">
            <div class="col-md-8">
                <h3 class="fw-bold" style="color: var(--navy-dark);"><i class="fa-solid fa-id-card text-primary me-2"></i> Quản lý Thẻ Tháng</h3>
                <p class="text-muted mb-0">Đăng ký và gia hạn vé tháng cho khách hàng.</p>
            </div>
            <div class="col-md-4 text-md-end mt-3 mt-md-0">
                <button class="btn btn-success fw-bold py-2 px-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#addSubscriptionModal">
                    <i class="fa-solid fa-plus me-1"></i> Đăng ký thẻ mới
                </button>
            </div>
        </div>

        <div class="card border-0 shadow-sm rounded-4 bg-white">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="py-3 px-4 text-secondary">Mã Thẻ</th>
                                <th class="py-3 text-secondary">Khách hàng</th>
                                <th class="py-3 text-secondary">Biển số xe</th>
                                <th class="py-3 text-secondary">Ngày bắt đầu</th>
                                <th class="py-3 text-secondary">Ngày hết hạn</th>
                                <th class="py-3 text-secondary">Trạng thái</th>
                                <th class="py-3 text-secondary text-center pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty subscriptions}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-folder-open fs-1 mb-2 opacity-50 d-block"></i>
                                        Chưa có dữ liệu thẻ tháng.
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach items="${subscriptions}" var="sub">
                                <tr>
                                    <td class="px-4 fw-bold text-secondary">#${sub.cardID}</td>
                                    <td class="fw-bold">${sub.customerName}</td>
                                    <td><span class="badge bg-light text-dark border px-2 py-1">${sub.vehicleID}</span></td>
                                    <td><fmt:formatDate value="${sub.startDate}" pattern="dd/MM/yyyy" /></td>
                                    <td class="fw-bold"><fmt:formatDate value="${sub.endDate}" pattern="dd/MM/yyyy" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${sub.status == 'Active'}">
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success px-2 py-1">Đang hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-2 py-1">Hết hạn</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center pe-4">
                                        <a href="renewSubscription?id=${sub.cardID}" class="btn btn-sm btn-outline-primary shadow-sm">Gia hạn</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Modal Đăng Ký Thẻ (Basic) -->
        <div class="modal fade" id="addSubscriptionModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow">
                    <form action="${pageContext.request.contextPath}/staff/subscriptions" method="POST">
                        <div class="modal-header bg-light border-0">
                            <h5 class="modal-title fw-bold" style="color: var(--navy-dark);">Đăng ký thẻ tháng</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-4">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Tên khách hàng</label>
                                <input type="text" name="customerName" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Biển số xe</label>
                                <input type="text" name="licensePlate" class="form-control text-uppercase" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Số tháng đăng ký</label>
                                <input type="number" name="months" class="form-control" value="1" min="1" required>
                            </div>
                        </div>
                        <div class="modal-footer border-0 bg-light">
                            <button type="button" class="btn btn-light fw-bold" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success fw-bold">Tạo thẻ</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </div> <!-- Đóng Container -->
</div> <!-- Đóng Main Content -->
</div> <!-- Đóng Wrapper -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>