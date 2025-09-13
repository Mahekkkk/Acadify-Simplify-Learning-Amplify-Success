<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Assignment</title>
    <style>
        /* Color Variables */
        :root {
            --primary: #2C3D73;
            --primary-hover: #1b2751;
            --secondary: #7CAADC;
            --accent: #FFD372;
            --accent-hover: #F15B42;
            --background: #FDF6FA;
            --text-color: #2C3D73;
            --text-light: #5a6a8a;
            --card-bg: #ffffff;
            --card-shadow: 0 2px 8px rgba(44, 61, 115, 0.1);
            --success: #4CAF50;
            --warning: #FF9800;
            --error: #F44336;
        }

        /* Base Styles */
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--background);
            color: var(--text-color);
            min-height: 100vh;
        }

        /* Layout Structure */
        .page-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 240px;
            background-color: var(--primary);
            color: white;
            padding: 20px;
            box-shadow: 2px 0 8px rgba(0,0,0,0.1);
        }

        .sidebar h2 {
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
        }

        .sidebar a {
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            margin-bottom: 8px;
            border-radius: 6px;
            font-weight: 600;
            display: block;
            transition: all 0.3s ease;
        }

        .sidebar a:hover {
            background-color: var(--accent);
            color: var(--primary);
        }

        .sidebar a.active {
            background-color: var(--accent);
            color: var(--primary);
        }

        .main-content {
            flex: 1;
            padding: 30px 40px;
            max-width: 800px;
            margin: 0 auto;
        }

        /* Header Styles */
        .page-header {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 30px;
            color: var(--primary);
        }

        /* Form Styles */
        .form-container {
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            padding: 2rem;
            margin-top: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--text-color);
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
        }

        .checkbox-group {
            display: flex;
            gap: 1.5rem;
            margin: 1.5rem 0;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
        }

        .checkbox-input {
            width: 18px;
            height: 18px;
            accent-color: var(--primary);
        }

        /* Button Styles */
        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            font-size: 1rem;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
        }

        /* Error Styles */
        .error-message {
            color: var(--error);
            background-color: rgba(244, 67, 54, 0.1);
            padding: 0.75rem 1rem;
            border-radius: 6px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .error-message:before {
            content: "⚠️";
        }

        /* Utility Classes */
        .text-muted {
            color: var(--text-light);
        }

        .mt-3 {
            margin-top: 1.5rem;
        }
    </style>
</head>
<body>

<div class="page-container">
    <!-- Sidebar Navigation -->
    <nav class="sidebar">
        <h2>Acadify</h2>
       <a href="dashboard.jsp" class="nav-link active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/student/AddCourseServlet" class="nav-link">Courses</a>
            <a href="${pageContext.request.contextPath}/assignments" class="nav-link">Assignments</a>
            <a href="grades.jsp" class="nav-link">Grades</a>
            <a href="resources.jsp" class="nav-link">Study Resources</a>
            <a href="profile.jsp" class="nav-link">Profile</a>
            <a href="change-password.jsp" class="nav-link">Change Password</a>

        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </nav>

    <main class="main-content">
        <h1 class="page-header">Add New Assignment</h1>
        
        <c:if test="${not empty param.error}">
            <div class="error-message">
                Error adding assignment. Please try again.
            </div>
        </c:if>
        
        <div class="form-container">
            <form action="${pageContext.request.contextPath}/AddAssignmentServlet" method="post">
                <div class="form-group">
                    <label for="name" class="form-label">Assignment Name</label>
                    <input type="text" id="name" name="name" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="dueDate" class="form-label">Due Date</label>
                    <input type="date" id="dueDate" name="dueDate" class="form-control" required>
                </div>
                
                <div class="checkbox-group">
                    <label class="checkbox-label">
                        <input type="checkbox" class="checkbox-input" name="completed">
                        <span>Completed</span>
                    </label>
                    
                    <label class="checkbox-label">
                        <input type="checkbox" class="checkbox-input" name="submitted">
                        <span>Submitted</span>
                    </label>
                </div>
                
                <button type="submit" class="btn btn-primary">Add Assignment</button>
            </form>
        </div>
    </main>
</div>

</body>
</html>