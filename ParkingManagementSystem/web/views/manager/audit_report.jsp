<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <div>
        <h2>Nhật ký hoạt động hệ thống (Audit Log)</h2>
        <p class="text-muted small">Quyền: Chỉ đọc (Read-Only)</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/audit" class="btn btn-success shadow-sm">
        Xuất Báo Cáo (CSV)
    </a>
</div>

<div class="card shadow-sm border-0">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover table-bordered table-striped align-middle text-center" style="font-size: 0.9rem;">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Staff ID</th>
                        <th>Action</th>
                        <th>Table</th>
                        <th>Record ID</th>
                        <th>Column</th>
                        <th>Old Value</th>
                        <th>New Value</th>
                        <th>Reason</th>
                        <th>Thời gian</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="log" items="${auditLogs}">
                        <tr>
                            <td><strong>#${log.id}</strong></td>
                            <td><span class="badge bg-secondary border">NV-${log.staffID}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${log.actionType == 'INSERT'}"><span class="badge bg-success">INSERT</span></c:when>
                                    <c:when test="${log.actionType == 'UPDATE'}"><span class="badge bg-warning text-dark">UPDATE</span></c:when>
                                    <c:when test="${log.actionType == 'DELETE'}"><span class="badge bg-danger">DELETE</span></c:when>
                                    <c:otherwise><span class="badge bg-info text-dark">${log.actionType}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="fw-semibold">${log.tableName}</td>
                            <td>${log.recordID}</td>
                            <td>${log.columnName != null ? log.columnName : '-'}</td>
                            <td class="text-muted text-start" style="max-width: 150px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;" title="${log.oldValue}">${log.oldValue != null ? log.oldValue : '-'}</td>
                            <td class="text-primary text-start fw-medium" style="max-width: 150px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;" title="${log.newValue}">${log.newValue != null ? log.newValue : '-'}</td>
                            <td>${log.reason != null ? log.reason : '-'}</td>
                            <td class="text-nowrap"><small>${log.createdAt}</small></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty auditLogs}">
                        <tr><td colspan="10" class="text-center text-muted py-4">Hệ thống chưa ghi nhận dữ liệu nhật ký nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />