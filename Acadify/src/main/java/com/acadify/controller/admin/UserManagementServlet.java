package com.acadify.controller.admin;

import com.acadify.dao.UserDao;
import com.acadify.model.User;
import com.acadify.util.SecurityUtils;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import com.acadify.util.DatabaseUtil;


@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    if (!SecurityUtils.isAdmin(request)) {
	        response.sendRedirect(request.getContextPath() + "/login.jsp");
	        return;
	    }

	    try (Connection conn = DatabaseUtil.getConnection()) {
	        UserDao userDao = new UserDao(conn);
	        List<User> users = userDao.getAllUsers();
	        request.setAttribute("users", users);
	        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);

	    } catch (SQLException e) {
	        e.printStackTrace();
	        request.setAttribute("error", "Database error: " + e.getMessage());
	        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
	    }
	}

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Verify admin role
        if (!SecurityUtils.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            // 2. Handle different actions
            if ("delete".equals(action)) {
                handleDeleteUser(request);
            } else if ("updateRole".equals(action)) {
                handleUpdateRole(request);
            } else if ("toggleStatus".equals(action)) {
                handleToggleStatus(request);
            }

            // 3. Refresh user list
            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void handleDeleteUser(HttpServletRequest request) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));

        try (Connection conn = DatabaseUtil.getConnection()) {
            UserDao userDao = new UserDao(conn);
            if (userDao.deleteUser(userId)) {
                request.setAttribute("success", "User deleted successfully");
            } else {
                request.setAttribute("error", "Failed to delete user");
            }
        }
    }

    private void handleUpdateRole(HttpServletRequest request) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newRole = request.getParameter("newRole");

        try (Connection conn = DatabaseUtil.getConnection()) {
            UserDao userDao = new UserDao(conn);
            if (userDao.updateUserRole(userId, newRole)) {
                request.setAttribute("success", "User role updated successfully");
            } else {
                request.setAttribute("error", "Failed to update user role");
            }
        }
    }

    private void handleToggleStatus(HttpServletRequest request) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        boolean enabled = Boolean.parseBoolean(request.getParameter("enabled"));

        try (Connection conn = DatabaseUtil.getConnection()) {
            UserDao userDao = new UserDao(conn);
            if (userDao.setUserEnabled(userId, enabled)) {
                request.setAttribute("success", "User status updated successfully");
            } else {
                request.setAttribute("error", "Failed to update user status");
            }
        }
    }
}

