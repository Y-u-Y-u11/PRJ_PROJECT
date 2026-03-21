<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    model.Users user = (model.Users) session.getAttribute("LOGIN_USER");
    if (user != null) {
        if ("manager".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
        }
    } else {
        response.sendRedirect(request.getContextPath() + "/auth/login");
    }
%>
