package com.acadify.controller;

import com.acadify.dao.UserDao;
import com.acadify.model.User;
import com.acadify.util.PasswordHashing;
import com.acadify.util.DatabaseUtil;
import com.acadify.util.EmailUtil; // ✅ This was missing earlier

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Get form data
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Basic validation of input fields
        if (username == null || username.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setEmail(email.trim());

        // Hash the password before storing
        String hashedPassword = PasswordHashing.hashPassword(password);
        newUser.setPassword(hashedPassword);

        // Generate token and set verification flag
        String token = java.util.UUID.randomUUID().toString();
        newUser.setVerificationToken(token);
        newUser.setIsVerified(false);

        boolean isSuccess = false;

        // Save user to database
        try (Connection conn = DatabaseUtil.getConnection()) {
            UserDao userDao = new UserDao(conn);
            isSuccess = userDao.addUser(newUser);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Registration failed due to an internal error.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // If registered, try sending verification email
        if (isSuccess) {
            try {
            	EmailUtil.sendVerificationEmail(newUser.getEmail(), newUser.getUsername(), newUser.getVerificationToken());
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Registered, but failed to send verification email.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            response.sendRedirect("register-success.jsp");
        } else {
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
