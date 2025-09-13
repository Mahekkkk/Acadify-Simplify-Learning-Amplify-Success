package com.acadify.controller.student;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.acadify.dao.CourseDAO;
import com.acadify.model.User;
import com.acadify.util.DatabaseUtil;

@WebServlet("/student/addCourse")
public class AddCoursePageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("/student/addCourse.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = user.getId();
        String courseName = request.getParameter("courseName");
        String[] sectionNames = request.getParameterValues("sectionNames");

        try (Connection conn = DatabaseUtil.getConnection()) {
            CourseDAO dao = new CourseDAO(conn);
            dao.addCourseWithSections(userId, courseName, sectionNames);
            response.sendRedirect(request.getContextPath() + "/student/AddCourseServlet");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
