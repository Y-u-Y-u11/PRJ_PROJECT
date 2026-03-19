<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhân Viên - Parking Management</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

    <jsp:include page="../header.jsp" />
    <jsp:include page="../sidebar.jsp" />

    <div class="bg-white p-4 rounded shadow-sm main-content">

        <!-- Title -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="mb-0 fw-bold text-dark">Quản Lý Nhân Viên</h4>
        </div>

        <!-- Search + Add -->
        <div class="d-flex justify-content-between align-items-center mb-3 gap-2">
            <form action="${pageContext.request.contextPath}/admin/staffManagement" method="GET"
                  class="d-flex align-items-center gap-2 flex-grow-1" style="max-width:480px;">
                <input type="hidden" name="sort" value="${sort}">
                <input type="hidden" name="order" value="${order}">
                <div class="input-group">
                    <span class="input-group-text bg-white">
                        <i class="fas fa-search text-muted"></i>
                    </span>
                    <input type="text" name="search" class="form-control border-start-0"
                           placeholder="Tìm kiếm..." value="${searchKeyword}">
                    
                    <c:if test="${not empty searchKeyword}">
                        <a href="${pageContext.request.contextPath}/admin/staffManagement?sort=${sort}&order=${order}"
                           class="btn btn-outline-danger">
                            <i class="fas fa-times"></i>
                        </a>
                    </c:if>

                    <button class="btn btn-outline-secondary">Tìm</button>
                </div>
            </form>

            <a href="${pageContext.request.contextPath}/admin/staffManagement/add"
               class="btn btn-navy shadow-sm">
                <i class="fas fa-plus me-1"></i> Thêm
            </a>
        </div>

        <!-- Flash -->
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success alert-dismissible fade show">
                ${sessionScope.message}
                <button class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show">
                ${sessionScope.error}
                <button class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Table -->
        <div class="table-responsive border rounded">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light text-muted">
                    <tr>
                        <th class="ps-3">
                            <a class="sort-link"
                               href="?sort=userID&order=${sort == 'userID' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                ID
                                <span class="sort-icon${sort == 'userID' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${order == 'asc'}">▲</c:when>
                                        <c:when test="${order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>

                        <th>Họ Tên</th>
                        <th>Tài khoản</th>
                        <th>Vai trò</th>
                        <th>SĐT</th>
                        <th>Trạng Thái</th>
                        <th class="text-center">Hành Động</th>
                    </tr>
                </thead>

                <tbody>
                    <c:choose>

                        <c:when test="${not empty staffList}">
                            <c:forEach items="${staffList}" var="staff">
                                <tr>
                                    <td class="ps-3 text-muted">#${staff.userID}</td>
                                    <td class="fw-bold">${staff.fullName}</td>
                                    <td>${staff.username}</td>

                                    <td>
                                        <span class="badge bg-info text-dark">${staff.role}</span>
                                    </td>

                                    <td>${staff.phone}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${staff.status}">
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success">
                                                    Hoạt động
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary">
                                                    Đã khóa
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- Action (GỘP CHUẨN) -->
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">

                                            <!-- Edit -->
                                            <form action="${pageContext.request.contextPath}/admin/staffManagement/edit" method="GET">
                                                <input type="hidden" name="id" value="${staff.userID}">
                                                <button class="btn-action-custom btn-edit-custom" title="Sửa">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </button>
                                            </form>

                                            <!-- Delete -->
                                            <form action="${pageContext.request.contextPath}/admin/staffManagement/delete"
                                                  method="GET"
                                                  onsubmit="return confirm('Bạn chắc chắn muốn khóa/xóa nhân viên này?');">
                                                <input type="hidden" name="id" value="${staff.userID}">
                                                <button class="btn-action-custom btn-delete-custom" title="Xóa">
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
                                    <i class="fas fa-box-open fa-3x mb-3 d-block"></i>
                                    Không có dữ liệu
                                </td>
                            </tr>
                        </c:otherwise>

                    </c:choose>
                </tbody>
            </table>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>