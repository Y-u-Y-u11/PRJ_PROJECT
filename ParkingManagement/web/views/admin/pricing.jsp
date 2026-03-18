<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Bảng Giá - Parking Management</title>
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
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold text-dark">Bảng Giá & Khung Giờ</h4>
            </div>

            <!-- Nút thêm -->
            <div class="d-flex justify-content-end align-items-center mb-3">
                <button type="button" class="btn btn-navy shadow-sm" data-bs-toggle="modal" data-bs-target="#addRuleModal">
                    <i class="fas fa-plus me-1"></i> Thêm Quy Tắc
                </button>
            </div>

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

            <!-- Bảng danh sách quy tắc giá -->
            <div class="table-responsive border rounded">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light text-muted">
                        <tr>
                            <th class="ps-3">Mã Quy Tắc</th>
                            <th>Loại Xe (Type ID)</th>
                            <th>Giờ Bắt Đầu</th>
                            <th>Giờ Kết Thúc</th>
                            <th class="text-end pe-4">Giá Tiền (VNĐ)</th>
                            <th class="text-center">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty rules}">
                                <c:forEach items="${rules}" var="rule">
                                    <tr>
                                        <td class="ps-3 fw-medium text-muted">#${rule.ruleID}</td>
                                        <td>
                                            <!-- Chuyển hiển thị số int thành chữ cho dễ nhìn -->
                                            <c:choose>
                                                <c:when test="${rule.typeID == '1'}">
                                                    <span class="badge bg-primary bg-opacity-10 text-primary border border-primary px-2 py-1">Ô Tô (1)</span>
                                                </c:when>
                                                <c:when test="${rule.typeID == '2'}">
                                                    <span class="badge bg-success bg-opacity-10 text-success border border-success px-2 py-1">Xe Máy (2)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary px-2 py-1">Xe Đạp (3)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="fw-medium text-dark">${rule.startHour} giờ</td>
                                        <td class="fw-medium text-dark">${rule.endHour} giờ</td>
                                        <td class="fw-bold text-success text-end pe-4 fs-6">
                                            <fmt:formatNumber value="${rule.price}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/>
                                        </td>
                                        <td class="text-center">
                                            <button class="btn btn-warning text-white table-action-btn me-1" title="Sửa" 
                                                    onclick="editRule(${rule.ruleID}, '${rule.typeID}', '${rule.startHour}', '${rule.endHour}', ${rule.price})">
                                                <i class="fas fa-pen"></i>
                                            </button>
                                            <form action="${pageContext.request.contextPath}/admin/pricing" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="ruleID" value="${rule.ruleID}">
                                                <button type="submit" class="btn btn-danger table-action-btn" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa quy tắc giá này?');">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-5">
                                        <i class="fas fa-box-open fa-3x mb-3 text-black-50 d-block"></i>
                                        Chưa có bảng giá nào được thiết lập.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal Thêm/Sửa Quy Tắc Giá -->
        <div class="modal fade" id="addRuleModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header pt-4 px-4">
                        <h5 class="modal-title text-dark" id="modalTitle">Thêm Quy Tắc Giá</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <form action="${pageContext.request.contextPath}/admin/pricing" method="POST" id="ruleForm">
                            <input type="hidden" name="action" id="formAction" value="add">
                            <input type="hidden" name="ruleID" id="formRuleID">
                            
                            <div class="mb-3">
                                <label class="form-label fw-medium text-dark">Loại xe (Mã Type) <span class="required-asterisk">*</span></label>
                                <!-- Đổi Value thành 1, 2, 3 (int) cho khớp DB -->
                                <select name="typeID" id="typeID" class="form-select" required>
                                    <option value="1">Ô Tô (1)</option>
                                    <option value="2">Xe Máy (2)</option>
                                    <option value="3">Xe Đạp (3)</option>
                                </select>
                            </div>
                            
                            <div class="row g-3 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-medium text-dark">Từ giờ (0-24) <span class="required-asterisk">*</span></label>
                                    <input type="number" name="startHour" id="startHour" class="form-control" placeholder="VD: 0" min="0" max="24" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-medium text-dark">Đến giờ (0-24) <span class="required-asterisk">*</span></label>
                                    <input type="number" name="endHour" id="endHour" class="form-control" placeholder="VD: 24" min="0" max="24" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-medium text-dark">Giá tiền (VNĐ) <span class="required-asterisk">*</span></label>
                                <div class="input-group">
                                    <input type="number" name="price" id="price" class="form-control" placeholder="VD: 15000" min="0" required>
                                    <span class="input-group-text bg-light fw-bold text-muted">VNĐ</span>
                                </div>
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

    </div> 
</div> 
</div> 

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editRule(ruleID, typeID, startHour, endHour, price) {
        document.getElementById('modalTitle').innerText = 'Cập Nhật Quy Tắc Giá';
        document.getElementById('formAction').value = 'update';
        document.getElementById('formRuleID').value = ruleID;
        
        document.getElementById('typeID').value = typeID;
        document.getElementById('startHour').value = startHour;
        document.getElementById('endHour').value = endHour;
        document.getElementById('price').value = price;
        
        document.getElementById('btnSubmit').innerText = 'Lưu thay đổi';
        
        var myModalEl = document.getElementById('addRuleModal');
        var modal = bootstrap.Modal.getOrCreateInstance(myModalEl);
        modal.show();
    }

    document.getElementById('addRuleModal').addEventListener('hidden.bs.modal', function () {
        document.getElementById('ruleForm').reset();
        document.getElementById('modalTitle').innerText = 'Thêm Quy Tắc Giá';
        document.getElementById('formAction').value = 'add';
        document.getElementById('formRuleID').value = '';
        document.getElementById('btnSubmit').innerText = 'Lưu';
    });
</script>
</body>
</html>