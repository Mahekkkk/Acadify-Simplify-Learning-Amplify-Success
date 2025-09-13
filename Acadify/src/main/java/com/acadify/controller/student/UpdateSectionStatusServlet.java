package com.acadify.controller.student;

import com.acadify.dao.SectionDAO;
import com.acadify.util.DatabaseUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/student/UpdateSectionStatusServlet")
public class UpdateSectionStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the array of completed section IDs from the form
        String[] completedSectionIds = request.getParameterValues("completedSectionIds");
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            SectionDAO sectionDAO = new SectionDAO(conn);
            
            // Begin transaction
            conn.setAutoCommit(false);
            
            try {
                // First mark all sections as incomplete (in case some were unchecked)
                String courseId = request.getParameter("courseId");
                if (courseId != null && !courseId.isEmpty()) {
                    sectionDAO.markAllSectionsIncomplete(Integer.parseInt(courseId));
                }
                
                // Then mark the checked sections as complete
                if (completedSectionIds != null) {
                    for (String sectionId : completedSectionIds) {
                        sectionDAO.markSectionAsCompleted(Integer.parseInt(sectionId));
                    }
                }
                
                // Commit transaction
                conn.commit();
                
                // Redirect back to course details with success message
                request.getSession().setAttribute("successMessage", "Progress saved successfully!");
                response.sendRedirect(request.getContextPath() + "/student/courseDetails?id=" + courseId);
                
            } catch (SQLException e) {
                // Rollback transaction on error
                conn.rollback();
                throw new ServletException("Database error while updating section status", e);
            }
            
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}