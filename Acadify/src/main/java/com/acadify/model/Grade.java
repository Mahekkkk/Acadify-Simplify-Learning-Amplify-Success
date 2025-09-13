package com.acadify.model;

import java.sql.Timestamp;
import java.util.LinkedHashMap;
import java.util.Map;
import java.sql.*;
import com.acadify.util.DatabaseUtil;

public class Grade {
    private int id;
    private int userId;
    private Integer semester; // Nullable
    private String subjectName; // Nullable
    private float marks;
    private Float totalMarks; // For subject entries
    private Float cgpa; // NEW: For semester entries (0.0-10.0)
    private Timestamp createdAt;
    private String entryType; // "subject" or "semester"

    // Constructors
    public Grade() {}

    public Grade(int id, int userId, Integer semester, String subjectName, 
                float marks, Float totalMarks, Float cgpa, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.semester = semester;
        this.subjectName = subjectName;
        this.marks = marks;
        this.totalMarks = totalMarks;
        this.cgpa = cgpa;
        this.createdAt = createdAt;
        this.entryType = computeEntryType();
    }

    // Getters and setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getSemester() {
        return semester;
    }
    public void setSemester(Integer semester) {
        this.semester = semester;
        this.entryType = computeEntryType();
    }

    public String getSubjectName() {
        return subjectName;
    }
    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
        this.entryType = computeEntryType();
    }

    public float getMarks() {
        return marks;
    }
    public void setMarks(float marks) {
        this.marks = marks;
    }

    public Float getTotalMarks() {
        return totalMarks;
    }
    public void setTotalMarks(Float totalMarks) {
        this.totalMarks = totalMarks;
    }

    // NEW CGPA handling
    public Float getCgpa() {
        return "semester".equals(entryType) ? cgpa : null;
    }

    public void setCgpa(Float cgpa) {
        if (cgpa != null) {
            if (cgpa < 0 || cgpa > 10) {
                throw new IllegalArgumentException("CGPA must be between 0.0 and 10.0");
            }
            this.cgpa = cgpa;
            this.marks = cgpa; // Maintain backward compatibility
            this.entryType = "semester";
        }
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getEntryType() {
        return entryType;
    }
    public void setEntryType(String entryType) {
        this.entryType = entryType;
    }

    // Auto-determine type
    private String computeEntryType() {
        if (subjectName != null && !subjectName.trim().isEmpty()) {
            return "subject";
        } else if (semester != null || cgpa != null) {
            return "semester";
        }
        return "unknown";
    }

    // Utility method for subject percentage
    public Float getPercentage() {
        if (totalMarks != null && totalMarks > 0) {
            return (marks / totalMarks) * 100;
        }
        return null;
    }

    // Semester progress tracking (unchanged)
    public Map<String, Float> getGradeProgressBySemester(int userId) {
        Map<String, Float> progressMap = new LinkedHashMap<>();
        String sql = "SELECT semester, AVG(cgpa) as avg_cgpa " +
                     "FROM grades " +
                     "WHERE user_id = ? AND entry_type = 'semester' " +
                     "GROUP BY semester " +
                     "ORDER BY semester";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int sem = rs.getInt("semester");
                float avg = rs.getFloat("avg_cgpa");
                progressMap.put("Sem " + sem, avg);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return progressMap;
    }
}