package com.acadify.controller.student;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.acadify.dao.AssignmentDAO;
import com.acadify.model.Assignment;

@WebServlet("/assignments")
public class AssignmentsServlet extends HttpServlet {

    private AssignmentDAO assignmentDAO = new AssignmentDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            List<Assignment> allAssignments = assignmentDAO.getAssignmentsByUserId(userId);

            List<Assignment> pendingAssignments = new ArrayList<>();
            List<Assignment> previousAssignments = new ArrayList<>();

            for (Assignment a : allAssignments) {
                if (a.isCompleted() && a.isSubmitted()) {
                    previousAssignments.add(a);
                } else {
                    pendingAssignments.add(a);
                }
            }

            pendingAssignments.sort(Comparator.comparing(Assignment::getDueDate));
            previousAssignments.sort(Comparator.comparing(Assignment::getDueDate).reversed());

            request.setAttribute("pendingAssignments", pendingAssignments);
            request.setAttribute("previousAssignments", previousAssignments);
            request.setAttribute("now", new Date());

            // Forward to JSP with the attributes
            request.getRequestDispatcher("student/assignments.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading assignments.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
