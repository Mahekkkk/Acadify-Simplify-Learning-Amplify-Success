//package com.acadify.filters;
//
//import javax.servlet.*;
//import javax.servlet.annotation.WebFilter;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//@WebFilter("/*") // Applies to all URLs in your app
//public class AuthFilter implements Filter {
//
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//
//        String uri = req.getRequestURI();
//        HttpSession session = req.getSession(false);
//
//        boolean isLoggedIn = session != null && session.getAttribute("userId") != null;
//        boolean isLoginPage = uri.endsWith("login.jsp") || uri.endsWith("LoginServlet") || uri.contains("register");
//
//        boolean isStaticResource = uri.contains("/css/") || uri.contains("/js/") || uri.contains("/images/");
//        boolean isPublicPage = uri.endsWith("index.jsp") || uri.endsWith("/") || uri.endsWith("home.jsp");
//
//
//        if (isLoggedIn || isLoginPage || isStaticResource || isPublicPage) {
//            chain.doFilter(request, response); // Proceed normally
//        } else {
//            res.sendRedirect("login.jsp"); // Redirect to login
//        }
//    }
//
//    public void init(FilterConfig filterConfig) {}
//    public void destroy() {}
//}
