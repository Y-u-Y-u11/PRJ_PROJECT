<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parking Ticket</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/web/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100">

    <div class="card border-0 shadow-lg" style="width: 350px;">
        <div class="card-header bg-primary text-white text-center border-0 py-3">
            <h5 class="fw-bold mb-0"><i class="fa-solid fa-receipt me-2"></i> PARKING TICKET</h5>
        </div>
        <div class="card-body p-4 bg-light m-3 border border-secondary border-dashed rounded" style="border-style: dashed !important; border-width: 2px !important;">
            <div class="text-center mb-4">
                <h4 class="fw-bold mb-0 text-uppercase" style="color: var(--navy-dark);">Parking System</h4>
                <small class="text-muted">Valid for today only</small>
            </div>
            
            <div class="d-flex justify-content-between mb-2 border-bottom pb-2">
                <span class="text-muted fw-bold">Ticket ID:</span>
                <span class="fw-bold text-primary">#Auto Created</span>
            </div>
            <div class="d-flex justify-content-between mb-2 border-bottom pb-2">
                <span class="text-muted fw-bold">Plate/ID:</span>
                <span class="fw-bold fs-5 text-uppercase">${not empty plate ? plate : 'N/A'}</span>
            </div>
            <div class="d-flex justify-content-between mb-2 border-bottom pb-2">
                <span class="text-muted fw-bold">Time in:</span>
                <span class="fw-bold">Just now</span>
            </div>
            <div class="d-flex justify-content-between mt-3">
                <span class="text-muted fw-bold">Estimated Fee:</span>
                <span class="fw-bold text-danger fs-5">Basic VND</span>
            </div>
            
            <div class="text-center mt-4">
                <i class="fa-solid fa-barcode fs-1 w-100"></i>
            </div>
        </div>
        <div class="card-footer bg-white border-0 d-flex gap-2 p-3">
            <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-light fw-bold w-50">Close</a>
            <a href="${pageContext.request.contextPath}/staff/dashboard?success=checkin" class="btn btn-primary fw-bold w-50">Done</a>
        </div>
    </div>

</body>
</html>
