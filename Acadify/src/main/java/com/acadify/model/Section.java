package com.acadify.model;

public class Section {
    private int id;
    private int courseId;  // Added this field
    private String sectionName;
    private boolean completed;

    // Parameterized constructor
    public Section(int id, int courseId, String sectionName, boolean completed) {
        this.id = id;
        this.courseId = courseId;
        this.sectionName = sectionName;
        this.completed = completed;
    }

    // Default constructor
    public Section() {
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getSectionName() {
        return sectionName;
    }

    public void setSectionName(String sectionName) {
        this.sectionName = sectionName;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    // Optional: toString() method for debugging
    @Override
    public String toString() {
        return "Section{" +
                "id=" + id +
                ", courseId=" + courseId +
                ", sectionName='" + sectionName + '\'' +
                ", completed=" + completed +
                '}';
    }
}