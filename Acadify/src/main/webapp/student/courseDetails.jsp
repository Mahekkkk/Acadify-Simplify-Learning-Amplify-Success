<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.acadify.model.Course, com.acadify.model.Section"%>
<%@page import="java.util.List"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Course Details - Acadify</title>
    <style>
        :root {
            --primary: #2C3D73;
            --secondary: #7CAADC;
            --accent: #FFD372;
            --accent-hover: #F15B42;
            --background: #FDF6FA;
            --text-color: #2C3D73;
        }

        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--background);
            color: var(--text-color);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        header {
            background-color: var(--primary);
            padding: 1.5rem 2rem;
            text-align: center;
            color: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .main-content {
            flex: 1;
            padding: 2rem;
            max-width: 900px;
            margin: 0 auto;
            width: 100%;
        }

        .action-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 1.8rem;
            color: var(--primary);
            margin: 0;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            padding: 0.6rem 1.2rem;
            border-radius: 30px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-accent {
            background-color: var(--accent);
            color: var(--primary);
            box-shadow: 0 4px 12px rgba(255, 211, 114, 0.3);
        }

        .btn-accent:hover {
            background-color: var(--accent-hover);
            color: white;
        }

        .course-card {
            background-color: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .course-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            cursor: pointer;
        }

        .course-title {
            font-size: 1.5rem;
            color: var(--primary);
            margin: 0;
            font-weight: 700;
        }

        .toggle-icon {
            font-size: 1.25rem;
            color: var(--primary);
            transition: transform 0.3s ease;
        }

        .toggle-icon.rotate {
            transform: rotate(180deg);
        }

        .progress {
            background-color: #eee;
            height: 20px;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, var(--accent), var(--secondary));
            color: white;
            font-size: 0.85rem;
            font-weight: bold;
            line-height: 20px;
            text-align: center;
            transition: width 0.5s ease;
        }

        .section-list {
            list-style: none;
            padding: 0;
            margin: 0 0 1.5rem 0;
        }

        .section-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }

        .section-checkbox {
            margin-right: 1rem;
            width: 18px;
            height: 18px;
            accent-color: var(--primary);
        }

        .save-btn {
            background-color: var(--primary);
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 30px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .save-btn:hover {
            background-color: var(--accent-hover);
        }

        .empty-state {
            text-align: center;
            padding: 2rem;
        }

        footer {
            text-align: center;
            padding: 1.5rem;
            background-color: white;
            border-top: 1px solid #eee;
            color: #666;
        }

        .alert-success {
            color: #4CAF50;
            font-weight: 600;
            text-align: center;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
    <header>
        <h1>Acadify Student Portal</h1>
    </header>

    <div class="main-content">
        <div class="action-buttons">
            <h1 class="page-title">Course Progress</h1>
            <a href="${pageContext.request.contextPath}/student/AddCourseServlet" class="btn btn-accent">
                ← Back to Courses
            </a>
        </div>

        <%-- Success message display --%>
        <%
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
        %>
            <div class="alert-success">
                <%= successMessage %>
            </div>
        <%
            session.removeAttribute("successMessage");
        }
        %>

        <%
        Course course = (Course) request.getAttribute("course");
        if (course != null) {
            List<Section> sections = course.getSections();
            int total = sections != null ? sections.size() : 0;
            int completed = 0;
            if (sections != null) {
                for (Section s : sections) {
                    if (s.isCompleted()) completed++;
                }
            }
            int percent = total > 0 ? (completed * 100 / total) : 0;
        %>
            <div class="course-card">
                <div class="course-header" onclick="toggleSections()">
                    <h2 class="course-title"><%= course.getCourseName() %></h2>
                    <span class="toggle-icon" id="toggleIcon">▼</span>
                </div>

                <div class="progress">
                    <div class="progress-bar" style="width: <%= percent %>%;">
                        <%= percent %>% Completed
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/student/UpdateSectionStatusServlet">
                    <input type="hidden" name="courseId" value="<%= course.getId() %>">
                    <div class="section-container" id="sectionContainer">
                        <%
                        if (sections != null && !sections.isEmpty()) {
                        %>
                            <ul class="section-list">
                                <%
                                for (Section section : sections) {
                                %>
                                <li class="section-item">
                                    <input type="checkbox"
                                           id="section_<%= section.getId() %>"
                                           name="completedSectionIds"
                                           value="<%= section.getId() %>"
                                           class="section-checkbox"
                                           <%= section.isCompleted() ? "checked" : "" %>>
                                    <label for="section_<%= section.getId() %>"><%= section.getSectionName() %></label>
                                </li>
                                <%
                                }
                                %>
                            </ul>
                            <button type="submit" class="save-btn">Save Progress</button>
                        <%
                        } else {
                        %>
                            <p>No sections available for this course.</p>
                        <%
                        }
                        %>
                    </div>
                </form>
            </div>
        <%
        } else {
        %>
            <div class="empty-state">
                <p>Course not found.</p>
                <a href="${pageContext.request.contextPath}/student/AddCourseServlet" class="btn btn-accent">
                    ← Back to Courses
                </a>
            </div>
        <%
        }
        %>
    </div>

    <footer>
        &copy; 2025 Acadify &mdash; Made with ❤️ to simplify education
    </footer>

    <script>
        function toggleSections() {
            const container = document.getElementById('sectionContainer');
            const icon = document.getElementById('toggleIcon');
            
            if (container.style.display === 'none') {
                container.style.display = 'block';
                icon.classList.add('rotate');
            } else {
                container.style.display = 'none';
                icon.classList.remove('rotate');
            }
        }

        // Initialize sections as visible
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('sectionContainer').style.display = 'block';
        });
    </script>
</body>
</html>