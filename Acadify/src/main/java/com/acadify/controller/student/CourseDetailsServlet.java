package com.acadify.controller.student;

import com.acadify.dao.CourseDAO;
import com.acadify.model.Course;
import com.acadify.util.DatabaseUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/student/courseDetails")
public class CourseDetailsServlet extends HttpServlet {

    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        try {
            courseDAO = new CourseDAO(DatabaseUtil.getConnection());
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("id"));
            Course course = courseDAO.getCourseWithSections(courseId);
            request.setAttribute("course", course);
            request.getRequestDispatcher("/student/courseDetails.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/courses.jsp");
        }
    }
}
