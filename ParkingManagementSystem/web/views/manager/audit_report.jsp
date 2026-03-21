<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="animate-fade-in">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0">Nhật ký hệ thống</h2>
            <p class="text-muted small mb-0">Giám sát các hoạt động thay đổi dữ liệu trong thời gian thực</p>
        </div>
    </div>

    <div class="card border-0 shadow-sm overflow-hidden">
        <div class="card-header bg-white border-bottom p-4">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0 fw-bold">Hoạt động gần đây</h5>
                <div class="text-muted small">Real-time monitoring enabled</div>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 custom-audit-table">
                    <thead class="bg-light text-muted small text-uppercase fw-bold">
                        <tr>
                            <th class="ps-4">Thời gian / Nhân viên</th>
                            <th>Hành động</th>
                            <th>Đối tượng</th>
                            <th>Dữ liệu thay đổi</th>
                            <th>Lý do</th>
                            <th class="pe-4 text-end">Mã định danh</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="log" items="${auditLogs}">
                            <tr class="audit-row">
                                <td class="ps-4">
                                    <div class="fw-medium text-dark">${log.createdAt}</div>
                                    <div class="text-muted small">Staff ID: <span class="badge bg-light text-dark border">NV-${log.staffID}</span></div>
                                </td>
                                <td>
                                    <c:set var="badgeClass" value="bg-secondary" />
                                    <c:if test="${log.actionType == 'INSERT' || log.actionType == 'CREATE'}"><c:set var="badgeClass" value="bg-success" /></c:if>
                                    <c:if test="${log.actionType == 'UPDATE'}"><c:set var="badgeClass" value="bg-warning text-dark" /></c:if>
                                    <c:if test="${log.actionType == 'DELETE'}"><c:set var="badgeClass" value="bg-danger" /></c:if>
                                    <span class="badge ${badgeClass} rounded-pill px-3">${log.actionType}</span>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark mb-0">${log.tableName}</div>
                                    <div class="text-muted smaller">Bản ghi #${log.recordID}</div>
                                </td>
                                <td style="max-width: 250px;">
                                    <c:if test="${not empty log.columnName}">
                                        <div class="small fw-medium text-primary mb-1">${log.columnName}</div>
                                        <div class="d-flex align-items-center gap-2 overflow-hidden w-100">
                                            <span class="text-muted text-decoration-line-through smaller text-truncate" style="max-width: 80px;" title="${log.oldValue}">${log.oldValue != null ? log.oldValue : '-'}</span>
                                            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="currentColor" class="bi bi-arrow-right text-muted flex-shrink-0" viewBox="0 0 16 16">
                                              <path fill-rule="evenodd" d="M1 8a.5.5 0 0 1 .5-.5h11.793l-3.147-3.146a.5.5 0 0 1 .708-.708l4 4a.5.5 0 0 1 0 .708l-4 4a.5.5 0 0 1-.708-.708L13.293 8.5H1.5A.5.5 0 0 1 1 8z"/>
                                            </svg>
                                            <span class="fw-bold text-success text-truncate" style="max-width: 120px;" title="${log.newValue}">${log.newValue != null ? log.newValue : '-'}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty log.columnName}">
                                        <span class="text-muted italic small">-</span>
                                    </c:if>
                                </td>
                                <td>
                                    <span class="text-wrap d-inline-block small" style="max-width: 150px;">${log.reason != null ? log.reason : '-'}</span>
                                </td>
                                <td class="pe-4 text-end">
                                    <span class="text-muted fw-mono small">#${log.id}</span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty auditLogs}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted italic">
                                    <i class="bi bi-inbox h3 d-block mb-3"></i>
                                    Không có dữ liệu nhật ký hệ thống.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<style>
    .custom-audit-table thead th {
        border-top: none;
        padding: 1.25rem 0.5rem;
    }
    .audit-row {
        transition: all 0.2s ease;
    }
    .audit-row:hover {
        background-color: rgba(139, 92, 246, 0.03) !important;
        transform: scale(1.002);
    }
    .bg-soft-success {
        background-color: rgba(16, 185, 129, 0.1);
    }
    .fw-mono {
        font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
    }
    .smaller {
        font-size: 0.75rem;
    }
</style>

<jsp:include page="/views/layout/footer.jsp" />