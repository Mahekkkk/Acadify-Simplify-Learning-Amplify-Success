package com.acadify.controller.student;

import com.acadify.dao.UserDao;
import com.acadify.model.User;
import com.acadify.util.DatabaseUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DatabaseUtil.getConnection()) {
            UserDao userDao = new UserDao(conn);
            User user = userDao.getUserById(userId);

            if (user == null) {
                request.setAttribute("error", "User not found.");
                request.getRequestDispatcher("/student/error.jsp").forward(request, response);
                return;
            }

            request.setAttribute("user", user);
            request.getRequestDispatcher("/student/profile.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error while loading profile.", e);
        }
    }
}
