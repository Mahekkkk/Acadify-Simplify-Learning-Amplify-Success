<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Acadify - Student Profile</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Sidebar Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <!-- Profile Specific Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
</head>
<body>
    <div class="page-container">
        <jsp:include page="/includes/student-sidebar.jsp" />
        <main class="main-content">
            <div class="profile-container">
                <div class="profile-card">
                    <div class="profile-header">
                        <h2><i class="fas fa-user"></i> Student Profile</h2>
                    </div>
                    <div class="profile-avatar-container">
                        <div class="profile-avatar">
                            ${user.username.charAt(0)}
                        </div>
                    </div>
                    <div class="profile-details">
                        <div class="detail-row">
                            <div class="detail-label">
                                <i class="fas fa-user-tag"></i> Username
                            </div>
                            <div class="detail-value">${user.username}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">
                                <i class="fas fa-envelope"></i> Email
                            </div>
                            <div class="detail-value">${user.email}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">
                                <i class="fas fa-user-shield"></i> Role
                            </div>
                            <div class="detail-value">${user.role}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">
                                <i class="fas fa-calendar-alt"></i> Member Since
                            </div>
                            <div class="detail-value">${user.createdAt}</div>
                        </div>
                        <a href="#" class="btn btn-accent">
                            <i class="fas fa-edit"></i> Edit Profile
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>