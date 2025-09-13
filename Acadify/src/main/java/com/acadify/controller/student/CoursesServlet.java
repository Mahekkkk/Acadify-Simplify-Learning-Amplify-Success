package com.acadify.controller.student;

import com.acadify.dao.CourseDAO;
import com.acadify.model.Course;
import com.acadify.model.User;
import com.acadify.util.DatabaseUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/student/AddCourseServlet")
public class CoursesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Retrieve User object from session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = user.getId();

        try (Connection conn = DatabaseUtil.getConnection()) {
            CourseDAO dao = new CourseDAO(conn);
            // Get courses with their sections
            List<Course> courses = dao.getCoursesWithSectionsByUser(userId); // ✅ use the correct method
            request.setAttribute("courses", courses);
            RequestDispatcher rd = request.getRequestDispatcher("/student/courses.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Retrieve User object from session
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