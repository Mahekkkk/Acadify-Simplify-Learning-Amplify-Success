package com.acadify.controller;

import com.acadify.dao.UserDao;
import com.acadify.model.User;
import com.acadify.util.DatabaseUtil;
import com.acadify.util.PasswordHashing;
import com.acadify.util.PasswordValidator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/changePassword")
public class PasswordChangeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // User not logged in; redirect to login page
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate new password and confirmation match
        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords don't match");
            request.getRequestDispatcher("secure/change-password.jsp").forward(request, response);
            return;
        }

        // Validate new password complexity (using your PasswordValidator util)
        String passwordError = PasswordValidator.validate(newPassword);
        if (passwordError != null) {
            request.setAttribute("error", passwordError);
            request.getRequestDispatcher("secure/change-password.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseUtil.getConnection()) {
            UserDao userDao = new UserDao(conn);

            // Fetch fresh user data from DB to check current password validity
            User dbUser = userDao.getUserByEmail(user.getEmail());
            if (dbUser == null) {
                request.setAttribute("error", "User not found.");
                request.getRequestDispatcher("secure/change-password.jsp").forward(request, response);
                return;
            }

            // Verify current password
            if (!PasswordHashing.checkPassword(currentPassword, dbUser.getPassword())) {
                request.setAttribute("error", "Current password is incorrect");
                request.getRequestDispatcher("secure/change-password.jsp").forward(request, response);
                return;
            }

            // Hash the new password and update
            String newHashedPassword = PasswordHashing.hashPassword(newPassword);
            boolean updated = userDao.updatePassword(user.getId(), newHashedPassword);

            if (updated) {
                // Update password in session user object as well
                user.setPassword(newHashedPassword);
                request.setAttribute("success", "Password updated successfully");
            } else {
                request.setAttribute("error", "Failed to update password");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while changing password. Please try again.");
        }

        // Forward back to the password change page with success/error message
        request.getRequestDispatcher("secure/change-password.jsp").forward(request, response);
    }
}
