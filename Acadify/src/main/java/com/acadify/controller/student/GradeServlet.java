package com.acadify.controller.student;

import com.acadify.dao.GradeDAO;
import com.acadify.model.Grade;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/grades")
public class GradeServlet extends HttpServlet {
    private GradeDAO gradeDAO;

    @Override
    public void init() throws ServletException {
        gradeDAO = new GradeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        
        try {
            request.setAttribute("grades", gradeDAO.getGradesByUser(userId));
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to fetch grades. Please try again later.");
        }
        
        request.getRequestDispatcher("/student/grades.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String type = request.getParameter("gradeType");
        Grade grade = new Grade();
        grade.setUserId(userId);

        try {
            if ("semester".equals(type)) {
                handleSemesterGrade(request, grade);
            } else if ("subject".equals(type)) {
                handleSubjectGrade(request, grade);
            } else {
                throw new IllegalArgumentException("Invalid grade type");
            }

            boolean success = gradeDAO.addGrade(grade);
            if (!success) {
                request.setAttribute("error", "Failed to add grade. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
        }
        
        doGet(request, response);
    }

    private void handleSemesterGrade(HttpServletRequest request, Grade grade) {
        String semesterStr = request.getParameter("semester");
        String cgpaStr = request.getParameter("marks"); // From form field named "marks"
        
        // Validate semester
        int semester;
        try {
            semester = Integer.parseInt(semesterStr);
            if (semester < 1) {
                throw new IllegalArgumentException("Semester must be at least 1");
            }
            grade.setSemester(semester);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid semester number");
        }

        // Validate CGPA
        float cgpa;
        try {
            cgpa = Float.parseFloat(cgpaStr);
            if (cgpa < 0 || cgpa > 10) {
                throw new IllegalArgumentException("CGPA must be between 0.0 and 10.0");
            }
            grade.setCgpa(cgpa); // This also sets entryType and marks
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid CGPA value");
        }
    }

    private void handleSubjectGrade(HttpServletRequest request, Grade grade) {
        String subjectName = request.getParameter("subjectName");
        String marksStr = request.getParameter("marks");
        String totalMarksStr = request.getParameter("totalMarks");
        
        // Validate subject name
        if (subjectName == null || subjectName.trim().isEmpty()) {
            throw new IllegalArgumentException("Subject name is required");
        }
        grade.setSubjectName(subjectName.trim());

        // Validate marks
        float marks, totalMarks;
        try {
            marks = Float.parseFloat(marksStr);
            totalMarks = Float.parseFloat(totalMarksStr);
            
            if (marks < 0 || totalMarks <= 0) {
                throw new IllegalArgumentException("Marks values must be positive");
            }
            if (marks > totalMarks) {
                throw new IllegalArgumentException("Obtained marks cannot exceed total marks");
            }
            
            grade.setMarks(marks);
            grade.setTotalMarks(totalMarks);
            grade.setEntryType("subject");
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid marks values");
        }
    }
}