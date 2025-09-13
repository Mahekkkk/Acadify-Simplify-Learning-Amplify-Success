package com.acadify.dao;

import com.acadify.model.Grade;
import com.acadify.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GradeDAO {
    private static final Logger logger = Logger.getLogger(GradeDAO.class.getName());

    // Fetch all grades for a user with proper semester handling
    public List<Grade> getGradesByUser(int userId) throws SQLException {
        List<Grade> grades = new ArrayList<>();
        String sql = "SELECT * FROM grades WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Grade grade = new Grade();
                grade.setId(rs.getInt("id"));
                grade.setUserId(rs.getInt("user_id"));
                grade.setEntryType(rs.getString("entry_type"));
                
                // Handle semester fields with proper NULL and string parsing
                String semesterStr = rs.getString("semester");
                if (semesterStr != null && !semesterStr.trim().isEmpty()) {
                    try {
                        // Clean string values like "1 NULL" to just "1"
                        String cleanSemester = semesterStr.replaceAll("[^0-9]", "");
                        if (!cleanSemester.isEmpty()) {
                            grade.setSemester(Integer.parseInt(cleanSemester));
                        }
                    } catch (NumberFormatException e) {
                        logger.log(Level.WARNING, "Invalid semester format: " + semesterStr, e);
                        grade.setSemester(null);
                    }
                }
                
                // Handle subject fields
                grade.setSubjectName(rs.getString("subject_name"));
                grade.setMarks(rs.getFloat("marks_obtained"));
                
                // Handle optional fields
                if (rs.getObject("total_marks") != null) {
                    grade.setTotalMarks(rs.getFloat("total_marks"));
                }
                if (rs.getObject("cgpa") != null) {
                    grade.setCgpa(rs.getFloat("cgpa"));
                }
                
                grade.setCreatedAt(rs.getTimestamp("created_at"));
                grades.add(grade);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching grades for user: " + userId, e);
            throw e;
        }
        return grades;
    }

    // Add a new grade record with validation
    public boolean addGrade(Grade grade) throws SQLException, IllegalArgumentException {
        // Validate semester entries
        if ("semester".equals(grade.getEntryType())) {
            if (grade.getSemester() == null) {
                throw new IllegalArgumentException("Semester cannot be null for semester entries");
            }
            if (grade.getSemester() <= 0) {
                throw new IllegalArgumentException("Semester must be a positive number");
            }
        } else {
            // For non-semester entries, ensure semester is null
            grade.setSemester(null);
        }

        String sql = "INSERT INTO grades (user_id, entry_type, semester, subject_name, " +
                   "marks_obtained, total_marks, cgpa, created_at) " +
                   "VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Common fields
            ps.setInt(1, grade.getUserId());
            ps.setString(2, grade.getEntryType());
            
            // Semester fields
            if (grade.getSemester() != null) {
                ps.setInt(3, grade.getSemester());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            
            // Subject fields
            if (grade.getSubjectName() != null && !grade.getSubjectName().trim().isEmpty()) {
                ps.setString(4, grade.getSubjectName());
            } else {
                ps.setNull(4, Types.VARCHAR);
            }
            
            // Marks/CGPA handling
            ps.setFloat(5, grade.getMarks());
            
            if ("subject".equals(grade.getEntryType()) && grade.getTotalMarks() != null) {
                ps.setFloat(6, grade.getTotalMarks());
            } else {
                ps.setNull(6, Types.FLOAT);
            }
            
            if ("semester".equals(grade.getEntryType()) && grade.getCgpa() != null) {
                ps.setFloat(7, grade.getCgpa());
            } else {
                ps.setNull(7, Types.FLOAT);
            }
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding grade for user: " + grade.getUserId(), e);
            throw e;
        }
    }

    // Get average marks/percentage for each subject
    public Map<String, Float> getAverageMarksBySubject(int userId) {
        Map<String, Float> subjectAverages = new HashMap<>();
        String sql = "SELECT subject_name, " +
                   "AVG(CASE WHEN total_marks IS NOT NULL " +
                   "THEN (marks_obtained/total_marks)*100 " +
                   "ELSE marks_obtained END) as average " +
                   "FROM grades WHERE user_id = ? AND subject_name IS NOT NULL " +
                   "GROUP BY subject_name";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                subjectAverages.put(rs.getString("subject_name"), 
                                  rs.getFloat("average"));
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error calculating subject averages for user: " + userId, e);
        }
        return subjectAverages;
    }

    // Get semester averages with proper filtering
    public Map<String, Float> getSemesterAverages(int userId) {
        Map<String, Float> semesterAverages = new LinkedHashMap<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT semester, AVG(cgpa) as avg_cgpa " +
                 "FROM grades WHERE user_id = ? " +
                 "AND semester IS NOT NULL " +
                 "AND semester REGEXP '^[0-9]+$' " +
                 "GROUP BY semester ORDER BY semester")) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String semester = "Semester " + rs.getString("semester");
                float avgCgpa = rs.getFloat("avg_cgpa");
                // Ensure CGPA is within 0-10 range
                avgCgpa = Math.min(10, Math.max(0, avgCgpa));
                semesterAverages.put(semester, avgCgpa);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error calculating semester averages for user: " + userId, e);
        }
        
        return semesterAverages;
    }

    // Calculate current CGPA properly
    public double getCurrentCgpaByUserId(int userId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT AVG(cgpa) as avg_cgpa " +
                 "FROM grades WHERE user_id = ? " +
                 "AND entry_type = 'semester' " +
                 "AND cgpa IS NOT NULL")) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("avg_cgpa");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error calculating CGPA for user: " + userId, e);
        }
        return 0.0;
    }

    // Additional method to clean up existing bad semester data
    public int cleanInvalidSemesterData() throws SQLException {
        String sql = "UPDATE grades " +
                   "SET semester = REGEXP_REPLACE(semester, '[^0-9]', '') " +
                   "WHERE semester REGEXP '[^0-9]'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            return stmt.executeUpdate();
        }
    }
}