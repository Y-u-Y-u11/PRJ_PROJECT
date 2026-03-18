<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý nhân viên - Parking Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    </head>
    <body>
        <!-- Bao gồm Header -->
        <jsp:include page="../header.jsp" />

        <style>
            .table-action-btn {
                width: 32px;
                height: 32px;
                padding: 0;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 4px;
            }
            .modal-header {
                border-bottom: none;
                padding-bottom: 0;
            }
            .modal-title {
                font-weight: bold;
                font-size: 1.25rem;
            }
            .required-asterisk {
                color: red;
            }
        </style>

        <!-- Bao gồm Sidebar -->
        <jsp:include page="../sidebar.jsp" />

        <!-- ================= NỘI DUNG CHÍNH ================= -->
        <div class="bg-white p-4 rounded shadow-sm">
            <!-- Tiêu đề -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold text-dark">Quản lý nhân viên</h4>
            </div>

            <!-- Thanh tìm kiếm và Nút thêm -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                
                <!-- TÍNH NĂNG MỚI: Form Tìm kiếm -->
                <form action="${pageContext.request.contextPath}/admin/staffManagement" method="GET" class="d-flex m-0">
                    <div class="input-group" style="max-width: 350px;">
                        <input type="text" name="search" class="form-control" placeholder="Tìm tên, username, sđt..." value="${searchKeyword}">
                        <button class="btn btn-outline-secondary" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                        <c:if test="${not empty searchKeyword}">
                            <a href="${pageContext.request.contextPath}/admin/staffManagement" class="btn btn-outline-danger" title="Xóa bộ lọc">
                                <i class="fas fa-times"></i>
                            </a>
                        </c:if>
                    </div>
                </form>

                <button type="button" class="btn btn-navy shadow-sm" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                    <i class="fas fa-plus me-1"></i> Thêm Nhân Viên
                </button>
            </div>

            <!-- Hiển thị thông báo lưu trữ trong Session từ PRG Pattern -->
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-1"></i> ${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-1"></i> ${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <!-- Bảng danh sách nhân viên -->
            <div class="table-responsive border rounded">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light text-muted">
                        <tr>
                            <th class="ps-3">ID</th>
                            <th>Họ & Tên</th>
                            <th>Tên Đăng Nhập</th>
                            <th>Vai Trò</th>
                            <th>Số Điện Thoại</th>
                            <th>Trạng Thái</th>
                            <th class="text-center">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty staffList}">
                                <c:forEach items="${staffList}" var="staff">
                                    <tr>
                                        <td class="ps-3 fw-medium text-muted">#${staff.userID}</td>
                                        <td class="fw-bold text-dark">${staff.fullName}</td>
                                        <td>${staff.username}</td>
                                        <td>
                                            <span class="badge bg-info text-dark">${staff.role}</span>
                                        </td>
                                        <td>${staff.phone}</td>
                                        <td>
                                            <!-- Chuyển đổi logic boolean sang giao diện -->
                                            <c:choose>
                                                <c:when test="${staff.status == true}">
                                                    <span class="badge bg-success bg-opacity-10 text-success border border-success">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary">Ngưng hoạt động</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <!-- Truyền biến boolean status sang text ACTIVE/INACTIVE cho JS -->
                                            <button class="btn btn-warning text-white table-action-btn me-1" title="Sửa" 
                                                    onclick="editStaff(${staff.userID}, '${staff.fullName}', '${staff.username}', '${staff.phone}', '${staff.status ? 'ACTIVE' : 'INACTIVE'}')">
                                                <i class="fas fa-pen"></i>
                                            </button>
                                            <!-- Đồng bộ action URL: /admin/staffManagement -->
                                            <form action="${pageContext.request.contextPath}/admin/staffManagement" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${staff.userID}">
                                                <button type="submit" class="btn btn-danger table-action-btn" title="Xóa/Khóa" onclick="return confirm('Bạn có chắc chắn muốn xóa/vô hiệu hóa nhân viên này?');">
                                                    <i class="fas fa-ban"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-5">
                                        <i class="fas fa-box-open fa-3x mb-3 text-black-50 d-block"></i>
                                        Chưa có dữ liệu nhân viên hoặc không tìm thấy kết quả.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal Thêm/Sửa Nhân Viên -->
        <div class="modal fade" id="addStaffModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header pt-4 px-4">
                        <h5 class="modal-title text-dark" id="modalTitle">Thêm Nhân Viên Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <!-- Đồng bộ action URL: /admin/staffManagement -->
                        <form action="${pageContext.request.contextPath}/admin/staffManagement" method="post" id="staffForm">
                            <input type="hidden" name="action" id="formAction" value="add">
                            <input type="hidden" name="id" id="staffId">

                            <div class="mb-3">
                                <label class="form-label fw-medium text-dark">Họ và Tên <span class="required-asterisk">*</span></label>
                                <input type="text" class="form-control" name="fullName" id="fullName" required placeholder="Nhập họ và tên">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-medium text-dark">Tên đăng nhập <span class="required-asterisk">*</span></label>
                                <input type="text" class="form-control" name="username" id="username" required placeholder="Nhập tên đăng nhập">
                            </div>
                            <div class="mb-3" id="passwordGroup">
                                <label class="form-label fw-medium text-dark">Mật khẩu <span class="required-asterisk">*</span></label>
                                <input type="password" class="form-control" name="password" id="password" required placeholder="Nhập mật khẩu">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-medium text-dark">Số điện thoại <span class="required-asterisk">*</span></label>
                                <!-- Đổi name từ phoneNumber thành phone cho đồng bộ với Controller -->
                                <input type="tel" class="form-control" name="phone" id="phone" required placeholder="Nhập số điện thoại">
                            </div>
                            <div class="mb-4" id="statusGroup" style="display:none;">
                                <label class="form-label fw-medium text-dark">Trạng thái <span class="required-asterisk">*</span></label>
                                <select class="form-select" name="status" id="status">
                                    <option value="ACTIVE">Đang Hoạt Động</option>
                                    <option value="INACTIVE">Ngưng Hoạt Động</option>
                                </select>
                            </div>

                            <div class="d-flex justify-content-end gap-2 mt-4">
                                <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-navy px-4" id="btnSubmit">Lưu</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!-- ================= KẾT THÚC NỘI DUNG CHÍNH ================= -->

    </div> 
</div> 
</div> 

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editStaff(id, fullName, username, phone, status) {
        document.getElementById('modalTitle').innerText = 'Cập Nhật Nhân Viên';
        document.getElementById('formAction').value = 'update';
        document.getElementById('staffId').value = id;

        document.getElementById('fullName').value = fullName;
        document.getElementById('username').value = username;
        document.getElementById('username').readOnly = true;

        document.getElementById('phone').value = phone !== 'null' ? phone : '';

        var statusGroup = document.getElementById('statusGroup');
        var statusSelect = document.getElementById('status');
        statusGroup.style.display = 'block';
        for (var i, j = 0; i = statusSelect.options[j]; j++) {
            if (i.value === status) {
                statusSelect.selectedIndex = j;
                break;
            }
        }

        document.getElementById('password').required = false;
        document.getElementById('passwordGroup').style.display = 'none';

        document.getElementById('btnSubmit').innerText = 'Lưu thay đổi';

        var myModalEl = document.getElementById('addStaffModal');
        var modal = bootstrap.Modal.getOrCreateInstance(myModalEl);
        modal.show();
    }

    document.getElementById('addStaffModal').addEventListener('hidden.bs.modal', function () {
        document.getElementById('staffForm').reset();
        document.getElementById('modalTitle').innerText = 'Thêm Nhân Viên Mới';
        document.getElementById('formAction').value = 'add';
        document.getElementById('staffId').value = '';

        document.getElementById('username').readOnly = false;
        document.getElementById('password').required = true;
        document.getElementById('passwordGroup').style.display = 'block';
        document.getElementById('statusGroup').style.display = 'none';
        document.getElementById('btnSubmit').innerText = 'Lưu';
    });
</script>
</body>
</html>