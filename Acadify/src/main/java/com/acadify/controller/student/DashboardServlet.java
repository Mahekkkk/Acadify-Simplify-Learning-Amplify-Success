package com.acadify.controller.student;

import com.acadify.dao.AssignmentDAO;
import com.acadify.dao.GradeDAO;
import com.acadify.model.Assignment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        
        // Get assignment stats and set in request
        AssignmentDAO assignmentDAO = new AssignmentDAO();
        Map<String, Integer> stats = assignmentDAO.getAssignmentCompletionStats(userId);
        request.setAttribute("assignmentStats", stats);

        // Calculate counts for dashboard cards
        int completedCount = stats.getOrDefault("Completed", 0);
        int pendingCount = stats.getOrDefault("Pending", 0);
        request.setAttribute("completedAssignmentsCount", completedCount);
        request.setAttribute("pendingAssignmentsCount", pendingCount);

        // Get urgent assignment
        Assignment urgent = AssignmentDAO.getNextUrgentAssignment(userId);
        request.setAttribute("urgentAssignment", urgent);

        // Get all upcoming assignments for this student
        List<Assignment> assignments = AssignmentDAO.getUpcomingAssignments(userId);
        request.setAttribute("assignments", assignments);

        // Get grades data
        GradeDAO gradesDAO = new GradeDAO();
        
        // Get current CGPA (latest semester)
        double currentCgpa = gradesDAO.getCurrentCgpaByUserId(userId);
        request.setAttribute("currentCgpa", currentCgpa);
        
        // Get subject-wise average marks
        Map<String, Float> subjectAvgMarks = gradesDAO.getAverageMarksBySubject(userId);
        request.setAttribute("subjectAverages", subjectAvgMarks);
        
        // Get semester-wise marks (using actual column names from your database)
        Map<String, Float> semesterMarks = gradesDAO.getSemesterAverages(userId);
        request.setAttribute("semesterAverages", semesterMarks);

        // Forward to dashboard JSP
        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }
}