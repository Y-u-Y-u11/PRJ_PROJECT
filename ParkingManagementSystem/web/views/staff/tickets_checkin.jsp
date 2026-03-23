<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/views/layout/header.jsp" />
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row w-100 justify-content-center">
    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">Check-in: Create New Parking Ticket</h5>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/staff/tickets/checkin" method="POST">
                    <div class="mb-3">
                        <label class="form-label d-block fw-bold">Check-in Mode</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="checkInMode" id="modeTransient" value="transient" 
                                   ${(empty checkInMode or checkInMode eq 'transient') ? 'checked' : ''} onchange="this.form.submit()">
                            <label class="form-check-label" for="modeTransient">Transient Ticket</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="checkInMode" id="modeMonthly" value="monthly" 
                                   ${checkInMode eq 'monthly' ? 'checked' : ''} onchange="this.form.submit()">
                            <label class="form-check-label" for="modeMonthly">Monthly Card</label>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${checkInMode eq 'monthly'}">
                            <!-- Fields for Monthly -->
                            <div class="mb-3">
                                <label class="form-label">Monthly Card ID</label>
                                <input type="number" class="form-control" name="cardId" placeholder="Enter Card ID" required autofocus>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Fields for Transient -->
                            <div class="mb-3">
                                <label class="form-label">Plate Number</label>
                                <input type="text" class="form-control" name="plateNumber" autofocus>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Vehicle Type</label>
                                <select name="vehicleTypeId" class="form-select" required>
                                    <option value="">-- Select Type --</option>
                                    <c:forEach var="v" items="${vehicleTypes}">
                                        <option value="${v.id}">${v.name} (${v.currentPrice} VNĐ/h)</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="mb-3">
                        <label class="form-label">Parking Slot (Available)</label>
                        <select name="slotId" class="form-select" required>
                            <option value="">-- Select Slot --</option>
                            <c:forEach var="s" items="${availableSlots}">
                                <option value="${s.id}">${s.code}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <button type="submit" name="submitAction" value="save" class="btn btn-success w-100 py-2">Confirm Check-in</button>
                    <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-secondary w-100 mt-2">Cancel</a>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp" />