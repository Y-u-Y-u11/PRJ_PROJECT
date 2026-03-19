<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Thẻ Tháng - Parking Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sort-link {
            color: inherit; text-decoration: none; display: inline-flex;
            align-items: center; gap: 5px; white-space: nowrap; font-weight: 600;
        }
        .sort-link:hover { color: #1a3c6e; }
        .sort-icon { font-size: 0.7rem; opacity: 0.4; }
        .sort-icon.active { opacity: 1; color: #1a3c6e; }
        
        /* Custom Action Buttons based on image */
        .btn-action-custom {
            width: 36px; 
            height: 36px; 
            padding: 0;
            display: inline-flex; 
            align-items: center; 
            justify-content: center;
            border-radius: 10px;
            border: none;
            color: white;
            font-size: 1rem;
            transition: opacity 0.2s ease;
        }
        .btn-action-custom:hover {
            opacity: 0.85;
            color: white;
        }
        .btn-edit-custom {
            background-color: #ffbc05; /* Màu vàng cam */
        }
        .btn-delete-custom {
            background-color: #dc3545; /* Màu đỏ */
        }
    </style>
</head>
<body>
    <jsp:include page="/views/header.jsp" />
    <jsp:include page="/views/sidebar.jsp" />

    <div class="bg-white p-4 rounded shadow-sm mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="mb-0 fw-bold" style="color: var(--navy-dark);"><i class="fa-solid fa-id-card text-primary me-2"></i> Quản Lý Thẻ Tháng</h4>
        </div>

        <!-- Search + Add toolbar -->
        <div class="d-flex justify-content-between align-items-center mb-3 gap-2">
            <form action="${pageContext.request.contextPath}/staff/subscriptions" method="GET"
                  class="d-flex align-items-center gap-2 flex-grow-1" style="max-width:480px;">
                <input type="hidden" name="sort" value="${sort}">
                <input type="hidden" name="order" value="${order}">
                <div class="input-group">
                    <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                    <input type="text" name="search" class="form-control border-start-0"
                           placeholder="Tìm theo mã khách hàng, biển số..." value="${searchKeyword}">
                    <c:if test="${not empty searchKeyword}">
                        <a href="${pageContext.request.contextPath}/staff/subscriptions?sort=${sort}&order=${order}"
                           class="btn btn-outline-danger" title="Xóa bộ lọc"><i class="fas fa-times"></i></a>
                    </c:if>
                    <input type="submit" class="btn btn-outline-secondary" value="Tìm kiếm">
                </div>
            </form>
            <button class="btn btn-success shadow-sm flex-shrink-0" data-bs-toggle="modal" data-bs-target="#addSubscriptionModal">
                <i class="fas fa-plus me-1"></i> Đăng Ký Thẻ Mới
            </button>
        </div>

        <!-- Flash messages -->
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-1"></i> ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-1"></i> ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Results label when searching -->
        <c:if test="${not empty searchKeyword}">
            <div class="text-muted small mb-2">
                Kết quả cho: <strong>"${searchKeyword}"</strong>
                &mdash; <strong>${cards.size()}</strong> bản ghi.
            </div>
        </c:if>

        <!-- Cards table -->
        <div class="table-responsive border rounded">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light text-muted">
                    <tr>
                        <th class="ps-3">
                            <a class="sort-link" href="${pageContext.request.contextPath}/staff/subscriptions?sort=cardID&order=${sort == 'cardID' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Mã Thẻ
                                <span class="sort-icon${sort == 'cardID' ? ' active' : ''}">
                                    <c:choose><c:when test="${sort == 'cardID' && order == 'asc'}">▲</c:when><c:when test="${sort == 'cardID' && order == 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                                </span>
                            </a>
                        </th>
                        <th>
                            <a class="sort-link" href="${pageContext.request.contextPath}/staff/subscriptions?sort=customerID&order=${sort == 'customerID' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Mã KH
                                <span class="sort-icon${sort == 'customerID' ? ' active' : ''}">
                                    <c:choose><c:when test="${sort == 'customerID' && order == 'asc'}">▲</c:when><c:when test="${sort == 'customerID' && order == 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                                </span>
                            </a>
                        </th>
                        <th>
                            <a class="sort-link" href="${pageContext.request.contextPath}/staff/subscriptions?sort=customerName&order=${sort == 'customerName' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Tên Khách Hàng
                                <span class="sort-icon${sort == 'customerName' ? ' active' : ''}">
                                    <c:choose><c:when test="${sort == 'customerName' && order == 'asc'}">▲</c:when><c:when test="${sort == 'customerName' && order == 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                                </span>
                            </a>
                        </th>
                        <th>
                            <a class="sort-link" href="${pageContext.request.contextPath}/staff/subscriptions?sort=plateNumber&order=${sort == 'plateNumber' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Biển Số Xe
                                <span class="sort-icon${sort == 'plateNumber' ? ' active' : ''}">
                                    <c:choose><c:when test="${sort == 'plateNumber' && order == 'asc'}">▲</c:when><c:when test="${sort == 'plateNumber' && order == 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                                </span>
                            </a>
                        </th>
                        <th>
                            <a class="sort-link" href="${pageContext.request.contextPath}/staff/subscriptions?sort=startDate&order=${sort == 'startDate' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Ngày Bắt Đầu
                                <span class="sort-icon${sort == 'startDate' ? ' active' : ''}">
                                    <c:choose><c:when test="${sort == 'startDate' && order == 'asc'}">▲</c:when><c:when test="${sort == 'startDate' && order == 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                                </span>
                            </a>
                        </th>
                        <th>
                            <a class="sort-link" href="${pageContext.request.contextPath}/staff/subscriptions?sort=endDate&order=${sort == 'endDate' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Ngày Hết Hạn
                                <span class="sort-icon${sort == 'endDate' ? ' active' : ''}">
                                    <c:choose><c:when test="${sort == 'endDate' && order == 'asc'}">▲</c:when><c:when test="${sort == 'endDate' && order == 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                                </span>
                            </a>
                        </th>
                        <th>
                            <a class="sort-link" href="${pageContext.request.contextPath}/staff/subscriptions?sort=status&order=${sort == 'status' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Trạng Thái
                                <span class="sort-icon${sort == 'status' ? ' active' : ''}">
                                    <c:choose><c:when test="${sort == 'status' && order == 'asc'}">▲</c:when><c:when test="${sort == 'status' && order == 'desc'}">▼</c:when><c:otherwise>⇅</c:otherwise></c:choose>
                                </span>
                            </a>
                        </th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty cards}">
                            <c:forEach items="${cards}" var="sub">
                                <tr>
                                    <td class="ps-3 fw-medium text-muted">#${sub.cardID}</td>
                                    <td class="fw-bold text-dark">${sub.customerID}</td>
                                    <td class="fw-bold text-primary">${sub.customerName}</td> <!-- Hiển thị Tên Khách Hàng -->
                                    <td><span class="badge bg-light text-dark border px-2 py-1">${sub.plateNumber}</span></td> <!-- Hiển thị Biển số thực tế -->
                                    <td>${sub.startDate}</td>
                                    <td class="fw-bold">${sub.endDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${sub.status == 'Active'}">
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success">Đang hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger">Hết hạn</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <!-- Dùng d-flex để căn chỉnh các nút không bị lệch -->
                                        <div class="d-flex justify-content-center gap-2">
                                            <!-- Edit Button -->
                                            <button type="button" class="btn-action-custom btn-edit-custom" title="Sửa"
                                                    onclick="populateEditModal('${sub.cardID}', '${sub.customerID}', '${sub.vehicleID}', '${sub.startDate}', '${sub.endDate}', '${sub.status}')"
                                                    data-bs-toggle="modal" data-bs-target="#editSubscriptionModal">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </button>
                                            
                                            <!-- Delete Form -->
                                            <form action="${pageContext.request.contextPath}/staff/subscriptions" method="POST" class="m-0" onsubmit="return confirm('Bạn có chắc chắn muốn xóa thẻ này?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="cardID" value="${sub.cardID}">
                                                <button type="submit" class="btn-action-custom btn-delete-custom" title="Xóa">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-5">
                                    <i class="fas fa-folder-open fa-3x mb-3 text-black-50 d-block"></i>
                                    <c:choose>
                                        <c:when test="${not empty searchKeyword}">Không có thẻ tháng nào khớp với tìm kiếm.</c:when>
                                        <c:otherwise>Chưa có dữ liệu thẻ tháng.</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div> <!-- Đóng Main Content Wrapper -->

    <!-- Modal Đăng Ký Thẻ -->
    <div class="modal fade" id="addSubscriptionModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <form action="${pageContext.request.contextPath}/staff/subscriptions" method="POST">
                    <input type="hidden" name="action" value="add">
                    <!-- Trạng thái luôn là Active khi tạo mới -->
                    <input type="hidden" name="status" value="Active">
                    
                    <div class="modal-header bg-light border-0">
                        <h5 class="modal-title fw-bold" style="color: var(--navy-dark);">Đăng ký thẻ tháng mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Khách hàng (Tên hoặc Mã ID)</label>
                            <input type="text" name="customerName" class="form-control" placeholder="VD: Nguyễn Văn A hoặc 12" required>
                        </div>
                        <div class="row mb-3">
                            <div class="col-5">
                                <label class="form-label fw-bold">Loại xe</label>
                                <select name="vehicleType" class="form-select" required>
                                    <option value="1">Ô tô</option>
                                    <option value="2">Xe máy</option>
                                    <option value="3">Xe đạp</option>
                                </select>
                            </div>
                            <div class="col-7">
                                <label class="form-label fw-bold">Biển số xe</label>
                                <input type="text" name="licensePlate" class="form-control text-uppercase" placeholder="VD: 30A-123.45" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-6">
                                <label class="form-label fw-bold">Ngày đăng ký</label>
                                <input type="date" name="startDate" id="add_startDate" class="form-control" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-bold">Số tháng</label>
                                <input type="number" name="months" id="add_months" class="form-control" value="1" min="1" required>
                            </div>
                        </div>
                        <!-- Bỏ hoàn toàn phần hiển thị Ngày hết hạn -->
                    </div>
                    <div class="modal-footer border-0 bg-light">
                        <button type="button" class="btn btn-light fw-bold" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success fw-bold">Tạo thẻ</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Sửa Thẻ -->
    <div class="modal fade" id="editSubscriptionModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <form action="${pageContext.request.contextPath}/staff/subscriptions" method="POST">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="cardID" id="edit_cardID">
                    <div class="modal-header bg-light border-0">
                        <h5 class="modal-title fw-bold" style="color: var(--navy-dark);">Chỉnh sửa thẻ tháng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Khách hàng</label>
                            <input type="text" name="customerID" id="edit_customerID" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Biển số xe</label>
                            <input type="text" name="vehicleID" id="edit_vehicleID" class="form-control text-uppercase" required>
                        </div>
                        <div class="row mb-3">
                            <div class="col-6">
                                <label class="form-label fw-bold">Ngày bắt đầu</label>
                                <input type="date" name="startDate" id="edit_startDate" class="form-control" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-bold">Ngày hết hạn</label>
                                <input type="date" name="endDate" id="edit_endDate" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Trạng thái</label>
                            <select name="status" id="edit_status" class="form-select">
                                <option value="Active">Đang hoạt động</option>
                                <option value="Expired">Hết hạn</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer border-0 bg-light">
                        <button type="button" class="btn btn-light fw-bold" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-warning text-white fw-bold">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hàm đổ dữ liệu vào modal Edit
        function populateEditModal(id, cusId, vehicle, start, end, status) {
            document.getElementById('edit_cardID').value = id;
            document.getElementById('edit_customerID').value = cusId;
            document.getElementById('edit_vehicleID').value = vehicle;
            document.getElementById('edit_startDate').value = start;
            document.getElementById('edit_endDate').value = end;
            document.getElementById('edit_status').value = status;
        }

        // Tự động set Ngày đăng ký = hôm nay khi mở Modal thêm mới
        document.getElementById('addSubscriptionModal').addEventListener('show.bs.modal', function () {
            const today = new Date();
            const yyyy = today.getFullYear();
            const mm = String(today.getMonth() + 1).padStart(2, '0');
            const dd = String(today.getDate()).padStart(2, '0');
            
            document.getElementById('add_startDate').value = `${yyyy}-${mm}-${dd}`;
            document.getElementById('add_months').value = 1;
        });
    </script>
</body>
</html>