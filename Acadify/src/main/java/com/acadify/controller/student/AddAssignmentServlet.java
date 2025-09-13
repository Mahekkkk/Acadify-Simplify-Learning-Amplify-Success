package com.acadify.controller.student;

import com.acadify.dao.AssignmentDAO;
import com.acadify.model.Assignment;
import com.acadify.util.ReminderEmail; // ✅ Make sure this import is added

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

@WebServlet("/AddAssignmentServlet")
public class AddAssignmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String name = request.getParameter("name");
            String dueDateStr = request.getParameter("dueDate");
            boolean completed = request.getParameter("completed") != null;
            boolean submitted = request.getParameter("submitted") != null;

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dueDate = sdf.parse(dueDateStr);

            Assignment assignment = new Assignment();
            assignment.setUserId(userId);
            assignment.setName(name);
            assignment.setDueDate(dueDate);
            assignment.setCompleted(completed);
            assignment.setSubmitted(submitted);

            AssignmentDAO dao = new AssignmentDAO();
            dao.addAssignment(assignment);

            // ✅ Check if due date is tomorrow
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_YEAR, 1);
            String tomorrowStr = sdf.format(cal.getTime());
            String enteredDueDateStr = sdf.format(dueDate);

            if (tomorrowStr.equals(enteredDueDateStr)) {
                // ✅ Trigger reminder emails for all users
            	System.out.println("📧 Due tomorrow! Triggering ReminderEmail.send()");

                ReminderEmail.send();
            }

            response.sendRedirect(request.getContextPath() + "/assignments");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/addAssignment.jsp?error=1");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/student/addAssignment.jsp");
    }
}
