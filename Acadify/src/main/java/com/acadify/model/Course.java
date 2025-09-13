package com.acadify.model;

import java.util.List;

public class Course {
    private int id;
    private String courseCode;
    private String courseName;
    private String schedule;
    private List<Section> sections;
    private int userId;

    public int getUserId() {
        return userId;
    }

    

    // Default constructor
    public Course() {
    }

    // Parameterized constructor
    public Course(int id, String courseCode, String courseName, String instructor, String schedule, List<Section> sections) {
        this.id = id;
        this.courseCode = courseCode;
        this.courseName = courseName;
        this.schedule = schedule;
        this.sections = sections;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getSchedule() {
        return schedule;
    }

    public void setSchedule(String schedule) {
        this.schedule = schedule;
    }

    public List<Section> getSections() {
        return sections;
    }
    
    public void setSections(List<Section> sections) {
        this.sections = sections;
    }

    // Progress calculation
    public int calculateProgress() {
        if (sections == null || sections.isEmpty()) return 0;
        long completed = sections.stream().filter(Section::isCompleted).count();
        return (int) ((completed * 100.0) / sections.size());
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

}
