package com.acadify.dao;

import com.acadify.model.Section;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SectionDAO {
    private Connection connection;

    public SectionDAO(Connection connection) {
        this.connection = connection;
    }
 // Add this method to your existing SectionDAO class
    public boolean updateSectionStatus(int sectionId, boolean completed) throws SQLException {
        String sql = "UPDATE sections SET completed = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, completed);
            stmt.setInt(2, sectionId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // While we're here, let's also add this helper method for better transaction handling
    public boolean sectionBelongsToCourse(int sectionId, int courseId) throws SQLException {
        String sql = "SELECT 1 FROM sections WHERE id = ? AND course_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            stmt.setInt(2, courseId);
            
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // Returns true if section belongs to course
        }
    }

    // Marks a single section as completed
    public void markSectionAsCompleted(int sectionId) throws SQLException {
        String sql = "UPDATE sections SET completed = TRUE WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            stmt.executeUpdate();
        }
    }

    // Marks all sections for a course as incomplete
    public void markAllSectionsIncomplete(int courseId) throws SQLException {
        String sql = "UPDATE sections SET completed = FALSE WHERE course_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            stmt.executeUpdate();
        }
    }

    // Gets all sections for a course
    public List<Section> getSectionsByCourseId(int courseId) throws SQLException {
        List<Section> sections = new ArrayList<>();
        String sql = "SELECT * FROM sections WHERE course_id = ? ORDER BY id";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Section section = new Section();
                section.setId(rs.getInt("id"));
                section.setCourseId(rs.getInt("course_id"));
                section.setSectionName(rs.getString("section_name"));
                section.setCompleted(rs.getBoolean("completed"));
                sections.add(section);
            }
        }
        return sections;
    }

    // Adds multiple sections to a course
    public void addSections(int courseId, String[] sectionNames) throws SQLException {
        String sql = "INSERT INTO sections (course_id, section_name, completed) VALUES (?, ?, FALSE)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (String sectionName : sectionNames) {
                if (sectionName != null && !sectionName.trim().isEmpty()) {
                    stmt.setInt(1, courseId);
                    stmt.setString(2, sectionName.trim());
                    stmt.addBatch();
                }
            }
            stmt.executeBatch();
        }
    }
}