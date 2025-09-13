package com.acadify.controller;

import com.acadify.dao.UserDao;
import com.acadify.util.DatabaseUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/verify")
public class VerifyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            response.sendRedirect("verify-failed.jsp");
            return;
        }

        boolean isVerified = false;

        try (Connection conn = DatabaseUtil.getConnection()) {
            UserDao userDao = new UserDao(conn);
            isVerified = userDao.verifyUser(token);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isVerified) {
            // ✅ Set flash message in session
            HttpSession session = request.getSession();
            session.setAttribute("flashMessage", "✅ Your email has been verified. Please log in now.");
            response.sendRedirect("login.jsp");
        } else {
            response.sendRedirect("verify-failed.jsp");
        }
    }
}
