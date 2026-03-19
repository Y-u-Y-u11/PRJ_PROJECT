<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhân Viên - Parking Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <style>
        .table-action-btn {
            width: 32px; height: 32px; padding: 0;
            display: inline-flex; align-items: center; justify-content: center;
            border-radius: 4px;
        }
        .sort-link {
            color: inherit; text-decoration: none; display: inline-flex;
            align-items: center; gap: 5px; white-space: nowrap; font-weight: 600;
        }
        .sort-link:hover { color: #1a3c6e; }
        .sort-icon { font-size: 0.7rem; opacity: 0.4; }
        .sort-icon.active { opacity: 1; color: #1a3c6e; }
    </style>
</head>
<body>
    <jsp:include page="../header.jsp" />
    <jsp:include page="../sidebar.jsp" />

    <div class="bg-white p-4 rounded shadow-sm">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="mb-0 fw-bold text-dark">Quản Lý Nhân Viên</h4>
        </div>

        <!-- Search + Add toolbar -->
        <div class="d-flex justify-content-between align-items-center mb-3 gap-2">
            <form action="${pageContext.request.contextPath}/admin/staffManagement" method="GET"
                  class="d-flex align-items-center gap-2 flex-grow-1" style="max-width:480px;">
                <input type="hidden" name="sort" value="${sort}">
                <input type="hidden" name="order" value="${order}">
                <div class="input-group">
                    <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                    <input type="text" name="search" class="form-control border-start-0"
                           placeholder="Tìm kiếm theo tên, username, số điện thoại..." value="${searchKeyword}">
                    <c:if test="${not empty searchKeyword}">
                        <a href="${pageContext.request.contextPath}/admin/staffManagement?sort=${sort}&order=${order}"
                           class="btn btn-outline-danger" title="Xóa bộ lọc"><i class="fas fa-times"></i></a>
                    </c:if>
                    <input type="submit" class="btn btn-outline-secondary" value="Tìm kiếm">
                </div>
            </form>
            <a href="${pageContext.request.contextPath}/admin/staffManagement/add"
               class="btn btn-navy shadow-sm flex-shrink-0">
                <i class="fas fa-plus me-1"></i> Thêm Nhân Viên
            </a>
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
                &mdash; <strong>${staffList.size()}</strong> bản ghi.
            </div>
        </c:if>

        <!-- Staff table -->
        <div class="table-responsive border rounded">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light text-muted">
                    <tr>
                        <th class="ps-3">
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/staffManagement?sort=userID&order=${sort == 'userID' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                ID
                                <span class="sort-icon${sort == 'userID' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'userID' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'userID' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <th>
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/staffManagement?sort=fullName&order=${sort == 'fullName' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Họ Tên
                                <span class="sort-icon${sort == 'fullName' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'fullName' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'fullName' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <th>
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/staffManagement?sort=username&order=${sort == 'username' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Tài khoản
                                <span class="sort-icon${sort == 'username' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'username' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'username' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <th>Vai trò</th>
                        <th>
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/staffManagement?sort=phone&order=${sort == 'phone' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Số Điện Thoại
                                <span class="sort-icon${sort == 'phone' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'phone' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'phone' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
                        <th>
                            <a class="sort-link"
                               href="${pageContext.request.contextPath}/admin/staffManagement?sort=status&order=${sort == 'status' ? nextOrder : 'asc'}&search=${searchKeyword}">
                                Trạng Thái
                                <span class="sort-icon${sort == 'status' ? ' active' : ''}">
                                    <c:choose>
                                        <c:when test="${sort == 'status' && order == 'asc'}">▲</c:when>
                                        <c:when test="${sort == 'status' && order == 'desc'}">▼</c:when>
                                        <c:otherwise>⇅</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                        </th>
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
                                        <c:choose>
                                            <c:when test="${staff.status == true}">
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary">Đã khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <form action="${pageContext.request.contextPath}/admin/staffManagement/edit" method="GET" style="display:inline;">
                                            <input type="hidden" name="id" value="${staff.userID}">
                                            <input type="submit" class="btn btn-warning text-white table-action-btn me-1" value="✎" title="Sửa">
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/staffManagement/delete" method="GET" style="display:inline;">
                                            <input type="hidden" name="id" value="${staff.userID}">
                                            <input type="submit" class="btn btn-danger table-action-btn" value="✕" title="Khóa/Xóa">
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-5">
                                    <i class="fas fa-box-open fa-3x mb-3 text-black-50 d-block"></i>
                                    <c:choose>
                                        <c:when test="${not empty searchKeyword}">Không có nhân viên nào khớp với tìm kiếm.</c:when>
                                        <c:otherwise>Chưa có dữ liệu nhân viên.</c:otherwise>
                                    </c:choose>
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