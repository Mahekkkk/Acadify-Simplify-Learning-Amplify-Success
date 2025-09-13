package com.acadify.dao;

import com.acadify.model.Course;
import com.acadify.model.Section;
import com.acadify.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {
    private Connection conn;
    private SectionDAO sectionDAO;

    public CourseDAO(Connection conn) {
        this.conn = conn;
        this.sectionDAO = new SectionDAO(conn);
    }

    // Get a single course with its sections
    public Course getCourseWithSections(int courseId) throws SQLException {
        String courseQuery = "SELECT * FROM courses WHERE id = ?";
        Course course = null;

        try (PreparedStatement ps = conn.prepareStatement(courseQuery)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setCourseName(rs.getString("course_name"));
                    course.setUserId(rs.getInt("user_id"));
                    course.setSections(sectionDAO.getSectionsByCourseId(courseId));
                }
            }
        }

        return course;
    }

    // Get all courses with their sections for a specific user
    public List<Course> getCoursesWithSectionsByUser(int userId) throws SQLException {
        List<Course> courses = new ArrayList<>();
        String courseQuery = "SELECT * FROM courses WHERE user_id = ? ORDER BY id";

        try (PreparedStatement ps = conn.prepareStatement(courseQuery)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setCourseName(rs.getString("course_name"));
                    course.setUserId(rs.getInt("user_id"));
                    course.setSections(sectionDAO.getSectionsByCourseId(course.getId()));
                    courses.add(course);
                }
            }
        }

        return courses;
    }

    // Add course and its sections (transactional)
    public void addCourseWithSections(int userId, String courseName, String[] sectionNames) throws SQLException {
        String insertCourse = "INSERT INTO courses (course_name, user_id) VALUES (?, ?)";

        try (
            PreparedStatement psCourse = conn.prepareStatement(insertCourse, Statement.RETURN_GENERATED_KEYS)
        ) {
            conn.setAutoCommit(false);

            psCourse.setString(1, courseName);
            psCourse.setInt(2, userId);
            psCourse.executeUpdate();

            try (ResultSet generatedKeys = psCourse.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int courseId = generatedKeys.getInt(1);
                    sectionDAO.addSections(courseId, sectionNames);
                } else {
                    throw new SQLException("Failed to retrieve generated course ID.");
                }
            }

            conn.commit();
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }

    // Get course by ID without sections
    public Course getCourseById(int courseId) throws SQLException {
        String sql = "SELECT * FROM courses WHERE id = ?";
        Course course = null;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setCourseName(rs.getString("course_name"));
                    course.setUserId(rs.getInt("user_id"));
                }
            }
        }

        return course;
    }

    // Get count of active courses
    public int getActiveCourseCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM courses WHERE active = true";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}
