package com.acadify.controller.student;

import com.acadify.dao.SectionDAO;
import com.acadify.model.User;
import com.acadify.util.DatabaseUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/student/UpdateProgressServlet")
public class UpdateProgressServlet extends HttpServlet {

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

        int sectionId;
        try {
            sectionId = Integer.parseInt(request.getParameter("sectionId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/CoursesServlet");
            return;
        }

        boolean completed = request.getParameter("completed") != null;

        try (Connection conn = DatabaseUtil.getConnection()) {
            SectionDAO sectionDAO = new SectionDAO(conn);
            boolean updated = sectionDAO.updateSectionStatus(sectionId, completed);

            if (!updated) {
                throw new ServletException("Failed to update section status");
            }

        } catch (Exception e) {
            throw new ServletException("Database error while updating progress", e);
        }

        response.sendRedirect(request.getContextPath() + "/student/AddCourseServlet");
    }
}
