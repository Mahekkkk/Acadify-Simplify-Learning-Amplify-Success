<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.acadify.model.Course, com.acadify.model.Section"%>
<%@page import="java.util.List"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <title>Acadify - Your Courses</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Sidebar Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <!-- Courses Specific Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/courses.css">
</head>
<body>
    <div class="page-container">
        <jsp:include page="/includes/student-sidebar.jsp" />
        <main class="main-content">
            <!-- Success Notification -->
            <c:if test="${not empty successMessage}">
                <div class="card" style="background-color: rgba(76, 175, 80, 0.1); border-left: 4px solid var(--success);">
                    <div style="display: flex; align-items: center; gap: 1rem;">
                        <i class="fas fa-check-circle" style="color: var(--success); font-size: 1.5rem;"></i>
                        <div>
                            <strong style="color: var(--success);">${successMessage}</strong>
                            <c:if test="${not empty nextSuggestion}">
                                <div style="margin-top: 0.5rem; display: flex; align-items: center; gap: 0.5rem;">
                                    <i class="fas fa-lightbulb" style="color: var(--accent);"></i>
                                    <span>${nextSuggestion}</span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
                <script>
                    setTimeout(function() {
                        document.querySelector('.card[style*="background-color: rgba(76, 175, 80, 0.1)"]').style.display = 'none';
                    }, 5000);
                </script>
            </c:if>

            <!-- Page Header -->
            <div class="action-bar">
                <h1 class="page-header">
                    <i class="fas fa-book"></i> Your Courses
                </h1>
                <a href="${pageContext.request.contextPath}/student/addCourse" class="btn btn-accent">
                    <i class="fas fa-plus"></i> Add New Course
                </a>
            </div>

            <%
            List<Course> courses = (List<Course>) request.getAttribute("courses");
            if (courses != null && !courses.isEmpty()) {
                for (Course course : courses) {
                    List<Section> sections = course.getSections();
                    int total = sections != null ? sections.size() : 0;
                    int completed = 0;

                    if (sections != null) {
                        for (Section s : sections) {
                            if (s.isCompleted())
                                completed++;
                        }
                    }

                    int percent = total > 0 ? (completed * 100 / total) : 0;
            %>
            <div class="card">
                <div class="course-card">
                    <div class="course-info">
                        <h3 class="course-name">
                            <a href="${pageContext.request.contextPath}/student/courseDetails?id=<%= course.getId() %>">
                                <i class="fas fa-book-open"></i> <%=course.getCourseName()%>
                            </a>
                        </h3>
                        <div class="progress">
                            <div class="progress-bar" style="width: <%=percent%>%;">
                                <%=percent%>% Completed
                            </div>
                        </div>
                    </div>
                    <span class="toggle-icon" onclick="toggleSections('<%=course.getId()%>')">
                        <i class="fas fa-chevron-down"></i>
                    </span>
                </div>

                <div class="section-container" id="sections-<%=course.getId()%>">
                    <%
                    if (sections != null && !sections.isEmpty()) {
                    %>
                    <p class="course-progress">
                        <i class="fas fa-check-circle"></i> <%=completed%> of <%=total%> sections completed
                    </p>
                    <ul class="section-list">
                        <%
                        for (Section section : sections) {
                        %>
                        <li class="section-item">
                            <span class="section-status">
                                <%=section.isCompleted() ? "<i class='fas fa-check'></i>" : "<i class='far fa-circle'></i>"%>
                            </span>
                            <%=section.getSectionName()%>
                        </li>
                        <%
                        }
                        %>
                    </ul>
                    <%
                    } else {
                    %>
                    <div style="padding: 1rem; background-color: var(--background); border-radius: 8px;">
                        <i class="fas fa-info-circle"></i> No sections available for this course.
                    </div>
                    <%
                    }
                    %>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="empty-state">
                <p><i class="fas fa-book"></i> You don't have any courses yet.</p>
                <a href="${pageContext.request.contextPath}/student/addCourse" class="btn btn-accent">
                    <i class="fas fa-plus"></i> Add Your First Course
                </a>
            </div>
            <%
            }
            %>
        </main>
    </div>

    <script>
        function toggleSections(courseId) {
            const sections = document.getElementById('sections-' + courseId);
            const toggleIcon = document.querySelector(`[onclick="toggleSections('${courseId}')"] i`);

            if (sections.style.display === 'block') {
                sections.style.display = 'none';
                toggleIcon.classList.remove('fa-chevron-up');
                toggleIcon.classList.add('fa-chevron-down');
            } else {
                sections.style.display = 'block';
                toggleIcon.classList.remove('fa-chevron-down');
                toggleIcon.classList.add('fa-chevron-up');
            }
        }
    </script>
</body>
</html>