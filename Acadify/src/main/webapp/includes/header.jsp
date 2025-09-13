<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${param.title != null ? param.title : "Dashboard"} | Acadify</title>

    <!-- Global CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">

    <!-- Sidebar / Layout specific CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css" />

    <!-- Spinner if needed -->
    <jsp:include page="/includes/spinner.jsp" />
</head>
<body>

<header class="site-header">
    <div class="container">
        <h1 class="logo">Acadify</h1>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard.jsp">Dashboard</a>
            <a href="${pageContext.request.contextPath}/student/courses">Courses</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </div>
</header>

<main class="main-content">
