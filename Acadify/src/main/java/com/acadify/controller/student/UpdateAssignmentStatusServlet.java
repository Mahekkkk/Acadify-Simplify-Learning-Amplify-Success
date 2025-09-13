package com.acadify.controller.student;

import com.acadify.dao.AssignmentDAO;
import com.acadify.model.Assignment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/UpdateAssignmentStatusServlet")
public class UpdateAssignmentStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
            boolean completed = request.getParameter("completed") != null;
            boolean submitted = request.getParameter("submitted") != null;

            AssignmentDAO dao = new AssignmentDAO();
            dao.updateAssignmentStatus(assignmentId, completed, submitted);

            // Prepare success message
            String message;
            if (completed && submitted) {
                message = "✅ Done with this assignment!";
            } else if (completed) {
                message = "📌 Submission pending!";
            } else {
                message = "📋 Assignment updated.";
            }

            // Get next urgent assignment
            Assignment nextUrgent = dao.getNextUrgentAssignment(userId);
            String nextSuggestion = (nextUrgent != null)
                ? "Next, work on: " + nextUrgent.getName()
                : "";

            // Reload assignments lists for display
            List<Assignment> pendingAssignments = dao.getPendingAssignments(userId);
            List<Assignment> previousAssignments = dao.getPreviousAssignments(userId);

            // Set all attributes
            request.setAttribute("successMessage", message);
            request.setAttribute("nextSuggestion", nextSuggestion);
            request.setAttribute("pendingAssignments", pendingAssignments);
            request.setAttribute("previousAssignments", previousAssignments);

            // Forward back to assignments.jsp
            request.getRequestDispatcher("/student/assignments.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating assignment status");
            try {
                // Try to reload assignments even if there was an error
                AssignmentDAO dao = new AssignmentDAO();
                List<Assignment> pendingAssignments = dao.getPendingAssignments(userId);
                List<Assignment> previousAssignments = dao.getPreviousAssignments(userId);
                request.setAttribute("pendingAssignments", pendingAssignments);
                request.setAttribute("previousAssignments", previousAssignments);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            request.getRequestDispatcher("/student/assignments.jsp").forward(request, response);
        }
    }
}