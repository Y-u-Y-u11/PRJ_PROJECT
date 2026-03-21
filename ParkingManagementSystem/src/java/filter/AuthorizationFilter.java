package filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();

        Users user = (session != null) ? (Users) session.getAttribute("LOGIN_USER") : null;

        // If not logged in, block access to /manager/*, /staff/*, /common/*
        if (user == null) {
            if (uri.contains("/manager/") || uri.contains("/staff/") || uri.contains("/common/")) {
                res.sendRedirect(req.getContextPath() + "/auth/login?error=unauthorized");
                return;
            }
        } else {
            // Already logged in
            String role = user.getRole();
            
            // Manager trying to access Staff
            if ("manager".equals(role) && uri.contains("/staff/")) {
                res.sendRedirect(req.getContextPath() + "/error/403");
                return;
            }
            // Staff trying to access Manager
            if ("staff".equals(role) && uri.contains("/manager/")) {
                res.sendRedirect(req.getContextPath() + "/error/403");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
