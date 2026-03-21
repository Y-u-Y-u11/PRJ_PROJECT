<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Xác nhận xóa ô đỗ - Parking Management</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap">
    <style>
        :root {
            --primary: #8b5cf6;
            --primary-soft: #ede9fe;
            --danger: #ef4444;
            --text-main: #1f2937;
            --bg-main: #f9fafb;
        }
        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background-color: var(--bg-main);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .confirm-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(12px);
            padding: 2.5rem;
            border-radius: 1.5rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        h2 { color: var(--text-main); margin-bottom: 1rem; }
        p { color: #6b7280; font-size: 1.1rem; margin-bottom: 2rem; }
        .slot-code {
            font-weight: 700;
            color: var(--primary);
            background: var(--primary-soft);
            padding: 0.25rem 0.75rem;
            border-radius: 0.5rem;
        }
        .btn-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            border: none;
            font-size: 1rem;
        }
        .btn-danger {
            background-color: var(--danger);
            color: white;
        }
        .btn-danger:hover {
            background-color: #dc2626;
            transform: translateY(-2px);
        }
        .btn-secondary {
            background-color: #e5e7eb;
            color: #4b5563;
        }
        .btn-secondary:hover {
            background-color: #d1d5db;
        }
        .error {
            color: var(--danger);
            background: #fef2f2;
            padding: 0.75rem;
            border-radius: 0.75rem;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="confirm-card">
        <h2>Xác nhận xóa?</h2>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <p>Bạn có chắc chắn muốn xóa ô đỗ <span class="slot-code">${slot.code}</span>?</p>
        <p style="font-size: 0.9rem; color: #9ca3af;">Hành động này không thể hoàn tác và sẽ gỡ liên kết khỏi lịch sử các vé gửi xe.</p>
        
        <form action="${pageContext.request.contextPath}/manager/slots/delete" method="POST">
            <input type="hidden" name="id" value="${slot.id}">
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/manager/slots" class="btn btn-secondary">Hủy bỏ</a>
                <button type="submit" class="btn btn-danger">Xác nhận xóa</button>
            </div>
        </form>
    </div>
</body>
</html>
