package com.acadify.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.acadify.model.User;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                String role = user.getRole();
                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("admin/dashboard.jsp");
                    return;
                } else if ("student".equalsIgnoreCase(role)) {
                    response.sendRedirect("student/dashboard.jsp");
                    return;
                }
                // Add other roles here if needed
            }
        }
        // If no user or role found, redirect to login
        response.sendRedirect("login.jsp");
    }
}
