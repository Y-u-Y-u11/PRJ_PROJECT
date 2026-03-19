<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check-In Vehicle</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">
    <jsp:include page="/views/header.jsp" />
    <jsp:include page="/views/sidebar.jsp" />

    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card border-0 shadow-sm rounded-4">
                    <div class="card-body p-5">
                        <h3 class="fw-bold mb-4 text-center" style="color: var(--navy-dark);">Vehicle Check-In</h3>
                        
                        <div class="bg-primary bg-opacity-10 p-3 rounded-3 mb-4 d-flex justify-content-between align-items-center border border-primary border-opacity-25">
                            <span class="text-primary fw-bold">Allocated Slot:</span>
                            <span class="fs-3 fw-bolder text-primary">${slotCode}</span>
                        </div>

                        <c:if test="${error != null}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/staff/check-in" method="POST">
                            <input type="hidden" name="slotID" value="${slotID}">
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold text-secondary">Vehicle Type</label>
                                <div class="d-flex gap-3 bg-light p-2 rounded-3 border">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="vehicleType" id="typeOTO" value="OTO">
                                        <label class="form-check-label fw-bold" for="typeOTO"><i class="fa-solid fa-car"></i> Car</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="vehicleType" id="typeXM" value="XM" checked>
                                        <label class="form-check-label fw-bold" for="typeXM"><i class="fa-solid fa-motorcycle"></i> Motorbike</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="vehicleType" id="typeXD" value="XD">
                                        <label class="form-check-label fw-bold" for="typeXD"><i class="fa-solid fa-bicycle"></i> Bicycle</label>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold text-secondary">License Plate (Leave empty for Bicycle)</label>
                                <input type="text" name="vehiclePlate" class="form-control form-control-lg text-uppercase" placeholder="E.g.: 29A-123.45">
                            </div>

                            <div class="d-flex gap-2 mt-4">
                                <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-light w-50 fw-bold py-2">Cancel</a>
                                <button type="submit" class="btn btn-primary w-50 fw-bold py-2">Check-in</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
