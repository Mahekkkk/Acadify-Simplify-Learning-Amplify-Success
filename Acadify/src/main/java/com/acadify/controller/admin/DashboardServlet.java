package com.acadify.controller.admin;

import com.acadify.dao.CourseDAO;
import com.acadify.dao.UserDao;
import com.acadify.model.User;
import com.acadify.util.DatabaseUtil;
import com.google.gson.Gson;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/dashboard-data")
public class DashboardServlet extends HttpServlet {
    private UserDao userDao;
    private CourseDAO courseDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get current admin user from session
            User admin = (User) request.getSession().getAttribute("user");

            if (admin == null || !admin.getRole().equals("admin")) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            try (Connection conn = DatabaseUtil.getConnection()) {
                userDao = new UserDao(conn);
                courseDAO = new CourseDAO(conn);

                // Fetch data from database
                int totalUsers = userDao.getTotalUsers();
                int activeCourses = courseDAO.getActiveCourseCount();
                int newSignups = userDao.getNewSignupsLastWeek();

                // Prepare response map
                Map<String, Object> data = new HashMap<>();
                data.put("totalUsers", totalUsers);
                data.put("activeCourses", activeCourses);
                data.put("newSignups", newSignups);
                data.put("systemHealth", 100); // Placeholder for system health

                // Convert map to JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(new Gson().toJson(data));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
