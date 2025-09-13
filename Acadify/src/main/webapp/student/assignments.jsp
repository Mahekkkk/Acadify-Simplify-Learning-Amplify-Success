<%@page import="java.util.*, com.acadify.model.Assignment"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <title>Acadify - Your Assignments</title>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Sidebar Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <!-- Assignments Specific Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/assignments.css">
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
                    <i class="fas fa-tasks"></i> Your Assignments
                </h1>
                <a href="${pageContext.request.contextPath}/student/addAssignment.jsp" class="btn btn-accent">
                    <i class="fas fa-plus"></i> Add New Assignment
                </a>
            </div>

            <!-- Priority Assignment Alert -->
            <c:if test="${not empty pendingAssignments}">
                <div class="urgent-alert">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div>
                        <strong>Priority Assignment:</strong>
                        <c:set var="urgentAssignment" value="${null}" />
                        <c:forEach var="a" items="${pendingAssignments}">
                            <c:if test="${empty urgentAssignment or a.dueDate.before(urgentAssignment.dueDate)}">
                                <c:set var="urgentAssignment" value="${a}" />
                            </c:if>
                        </c:forEach>
                        <c:if test="${not empty urgentAssignment}">
                            Focus on: <strong>${urgentAssignment.name}</strong>
                            <br>
                            <span>Due: <strong><fmt:formatDate value="${urgentAssignment.dueDate}" pattern="MMM d, yyyy" /></strong></span>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <!-- Pending Assignments Section -->
            <div class="priority-section">
                <h2 class="section-title">
                    <i class="fas fa-clock"></i> Pending Assignments
                </h2>

                <c:choose>
                    <c:when test="${empty pendingAssignments}">
                        <div class="card empty-state">
                            <i class="far fa-smile"></i>
                            <p>All assignments are completed and submitted!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="assignment-grid">
                            <c:forEach var="a" items="${pendingAssignments}">
                                <div class="card assignment-card">
                                    <form method="post" action="${pageContext.request.contextPath}/UpdateAssignmentStatusServlet">
                                        <div class="assignment-header">
                                            <h3 class="assignment-name">${a.name}</h3>
                                            <p class="assignment-due-date">
                                                <i class="far fa-calendar-alt"></i>
                                                Due: <fmt:formatDate value="${a.dueDate}" pattern="MMM d, yyyy" />
                                                <c:if test="${a.dueDate.time lt now.time}">
                                                    <span class="assignment-status status-pending">
                                                        <i class="fas fa-exclamation-circle"></i> Overdue
                                                    </span>
                                                </c:if>
                                            </p>
                                        </div>
                                        
                                        <div class="assignment-progress">
                                            <input type="hidden" name="assignmentId" value="${a.id}" />
                                            
                                            <div class="progress-checkbox">
                                                <label class="status-label">
                                                    <input type="checkbox" id="completed-${a.id}" name="completed" 
                                                        <c:if test="${a.completed}">checked</c:if> />
                                                    <span class="checkmark"></span>
                                                    <span>Completed</span>
                                                </label>
                                                
                                                <label class="status-label">
                                                    <input type="checkbox" id="submitted-${a.id}" name="submitted" 
                                                        <c:if test="${a.submitted}">checked</c:if> />
                                                    <span class="checkmark"></span>
                                                    <span>Submitted</span>
                                                </label>
                                            </div>
                                            
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-sync-alt"></i> Update
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Completed Assignments Section -->
            <div class="priority-section">
                <h2 class="section-title">
                    <i class="fas fa-check-circle"></i> Completed Assignments
                </h2>

                <c:choose>
                    <c:when test="${empty previousAssignments}">
                        <div class="card empty-state">
                            <i class="far fa-folder-open"></i>
                            <p>No completed assignments yet.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="assignment-grid">
                            <c:forEach var="a" items="${previousAssignments}">
                                <div class="card assignment-card">
                                    <div class="assignment-header">
                                        <h3 class="assignment-name">${a.name}</h3>
                                        <p class="assignment-due-date">
                                            <i class="far fa-calendar-alt"></i>
                                            Due: <fmt:formatDate value="${a.dueDate}" pattern="MMM d, yyyy" />
                                        </p>
                                    </div>
                                    <div class="assignment-status">
                                        <span class="status-completed">
                                            <i class="fas fa-check-circle"></i> Completed
                                        </span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</body>
</html>