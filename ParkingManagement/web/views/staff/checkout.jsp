<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check-Out Vehicle</title>
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
                        <div class="text-center mb-4">
                            <i class="fa-solid fa-car-side text-danger fs-1 mb-3"></i>
                            <h3 class="fw-bold mb-1" style="color: var(--navy-dark);">Release Slot <span class="text-danger">${slotCode}</span></h3>
                            <p class="text-muted">Process vehicle check-out and payment</p>
                        </div>
                        
                        <c:if test="${error != null}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/staff/check-out" method="POST">
                            <input type="hidden" name="slotCode" value="${slotCode}">
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold text-secondary">Enter Ticket ID</label>
                                <input type="number" name="ticketID" class="form-control form-control-lg" required>
                            </div>

                            <div class="d-flex gap-2 mt-4">
                                <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-light w-50 fw-bold py-2">Cancel</a>
                                <button type="submit" class="btn btn-danger w-50 fw-bold py-2">Pay & Checkout</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
