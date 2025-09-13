package com.acadify.filters;

import com.acadify.model.User;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig config) throws ServletException {
        System.out.println("AdminAuthFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);
        
        String loginURI = request.getContextPath() + "/login.jsp";
        
        boolean loggedIn = session != null && session.getAttribute("user") != null;
        boolean isAdmin = loggedIn && 
                         ((User)session.getAttribute("user")).getRole().equals("admin");
        
        if (isAdmin) {
            // User is authenticated as admin - proceed
            chain.doFilter(request, response);
        } else {
            // Redirect to login with error message
            if (session != null) {
                session.setAttribute("error", "Admin access required");
            }
            response.sendRedirect(loginURI);
        }
    }

    @Override
    public void destroy() {
        System.out.println("AdminAuthFilter destroyed");
    }
}