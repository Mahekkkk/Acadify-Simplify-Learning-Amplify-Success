package com.acadify.controller;

import com.acadify.dao.UserDao;
import com.acadify.model.User;
import com.acadify.util.PasswordHashing;
import com.acadify.util.DatabaseUtil;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String requestedRole = request.getParameter("role");

        if (email != null) email = email.trim();
        if (password != null) password = password.trim();
        if (requestedRole != null) requestedRole = requestedRole.trim();

        if (email == null || email.isEmpty() ||
            password == null || password.isEmpty() ||
            requestedRole == null || requestedRole.isEmpty()) {
            request.setAttribute("errorType", "empty");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseUtil.getConnection()) {
            UserDao userDao = new UserDao(conn);
            User user = userDao.loginUser(email, password);

            if (user != null) {
                if (!user.isVerified()) {
                    request.setAttribute("errorType", "notVerified");
                    request.setAttribute("errorMessage", "Please verify your email before logging in.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                // Optional: invalidate old session
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) oldSession.invalidate();

                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("user", user);
                newSession.setMaxInactiveInterval(30 * 60);
                newSession.setAttribute("userId", user.getId());

                if ("admin".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect("admin/dashboard.jsp");
                } else if ("student".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    response.sendRedirect("home.jsp");
                }

            } else {
                // Check if the user exists but is unverified
                User u = userDao.getUserByEmail(email);
                if (u != null && !u.isVerified()) {
                    request.setAttribute("errorType", "notVerified");
                    request.setAttribute("errorMessage", "Please verify your email before logging in.");
                } else {
                    request.setAttribute("errorType", "credentials");
                    request.setAttribute("errorMessage", "Invalid email or password.");
                }
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An internal error occurred. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
