// [No changes to your existing imports]
package com.acadify.dao;

import com.acadify.model.Assignment;
import com.acadify.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import java.util.HashMap;
import java.util.Map;

public class AssignmentDAO {

    public static List<Assignment> getAssignmentsByUserId(int userId) {
        List<Assignment> assignments = new ArrayList<>();
        String sql = "SELECT * FROM assignments WHERE user_id = ? ORDER BY due_date ASC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Assignment a = new Assignment();
                a.setId(rs.getInt("id"));
                a.setUserId(rs.getInt("user_id"));
                a.setName(rs.getString("name"));
                a.setDueDate(rs.getDate("due_date"));
                a.setCompleted(rs.getBoolean("is_completed"));
                a.setSubmitted(rs.getBoolean("is_submitted"));
                assignments.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return assignments;
    }

    public void addAssignment(Assignment assignment) {
        String sql = "INSERT INTO assignments (user_id, name, due_date, is_completed, is_submitted) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, assignment.getUserId());
            stmt.setString(2, assignment.getName());
            stmt.setDate(3, new java.sql.Date(assignment.getDueDate().getTime()));
            stmt.setBoolean(4, assignment.isCompleted());
            stmt.setBoolean(5, assignment.isSubmitted());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Assignment getAssignmentById(int id) {
        String sql = "SELECT * FROM assignments WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Assignment a = new Assignment();
                a.setId(rs.getInt("id"));
                a.setUserId(rs.getInt("user_id"));
                a.setName(rs.getString("name"));
                a.setDueDate(rs.getDate("due_date"));
                a.setCompleted(rs.getBoolean("is_completed"));
                a.setSubmitted(rs.getBoolean("is_submitted"));
                return a;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateAssignmentStatus(int assignmentId, boolean completed, boolean submitted) throws Exception {
        String sql = "UPDATE assignments SET is_completed = ?, is_submitted = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, completed);
            stmt.setBoolean(2, submitted);
            stmt.setInt(3, assignmentId);
            stmt.executeUpdate();
        }
    }

    public static Assignment getNextUrgentAssignment(int userId) {
        String sql = "SELECT * FROM assignments WHERE user_id = ? AND is_completed = false ORDER BY due_date ASC LIMIT 1";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Assignment a = new Assignment();
                a.setId(rs.getInt("id"));
                a.setUserId(rs.getInt("user_id"));
                a.setName(rs.getString("name"));
                a.setDueDate(rs.getDate("due_date"));
                a.setCompleted(rs.getBoolean("is_completed"));
                a.setSubmitted(rs.getBoolean("is_submitted"));
                return a;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Assignment> getPendingAssignments(int userId) {
        String sql = "SELECT * FROM assignments WHERE user_id = ? AND (is_completed = false OR is_submitted = false) ORDER BY due_date ASC";
        List<Assignment> list = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Assignment a = mapResultSetToAssignment(rs);
                    list.add(a);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Assignment> getPreviousAssignments(int userId) {
        String sql = "SELECT * FROM assignments WHERE user_id = ? AND is_completed = true AND is_submitted = true ORDER BY due_date DESC";
        List<Assignment> list = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Assignment a = mapResultSetToAssignment(rs);
                    list.add(a);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Assignment mapResultSetToAssignment(ResultSet rs) throws SQLException {
        Assignment a = new Assignment();
        a.setId(rs.getInt("id"));
        a.setUserId(rs.getInt("user_id"));
        a.setName(rs.getString("name"));
        a.setDueDate(rs.getDate("due_date"));
        a.setCompleted(rs.getBoolean("is_completed"));
        a.setSubmitted(rs.getBoolean("is_submitted"));
        return a;
    }

    public static List<Assignment> getUpcomingAssignments(int userId) {
        List<Assignment> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT * FROM assignments WHERE user_id = ? ORDER BY due_date ASC"
             )) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Assignment a = new Assignment();
                a.setId(rs.getInt("id"));
                a.setUserId(rs.getInt("user_id"));
                a.setName(rs.getString("name"));
                a.setDueDate(rs.getTimestamp("due_date"));
                a.setCompleted(rs.getBoolean("is_completed"));
                a.setSubmitted(rs.getBoolean("is_submitted"));
                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ NEW METHOD: Get assignments due tomorrow for reminder email
    public static List<Assignment> getAssignmentsDueTomorrow(int userId) {
        List<Assignment> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "SELECT * FROM assignments WHERE user_id = ? AND DATE(due_date) = CURDATE() + INTERVAL 1 DAY AND is_completed = 0 AND is_submitted = 0";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Assignment a = new Assignment();
                a.setId(rs.getInt("id"));
                a.setName(rs.getString("name"));
                a.setDueDate(rs.getDate("due_date"));
                a.setCompleted(rs.getBoolean("is_completed"));
                a.setSubmitted(rs.getBoolean("is_submitted"));
                list.add(a);
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
 //  method to return completed vs pending assignment counts
    public static Map<String, Integer> getAssignmentCompletionStats(int userId) {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT " +
                     "SUM(CASE WHEN is_completed = 1 AND is_submitted = 1 THEN 1 ELSE 0 END) AS completed, " +
                     "SUM(CASE WHEN is_completed = 0 OR is_submitted = 0 THEN 1 ELSE 0 END) AS pending " +
                     "FROM assignments WHERE user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                map.put("Completed", rs.getInt("completed"));
                map.put("Pending", rs.getInt("pending"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }


}
