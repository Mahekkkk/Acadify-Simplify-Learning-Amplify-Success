<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="page" value="dashboard" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Acadify - Student Dashboard</title>
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<!-- Sidebar Styles -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
<!-- Dashboard Specific Styles -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
    <div class="page-container">
        <jsp:include page="/includes/student-sidebar.jsp" />
        <main class="main-content">
            <%
            com.acadify.model.Assignment urgent = (com.acadify.model.Assignment) request.getAttribute("urgentAssignment");
            if (urgent != null) {
            %>
            <div class="urgent-alert">
                <i class="fas fa-exclamation-triangle"></i>
                <div>
                    <strong>Urgent:</strong> "<%=urgent.getName()%>" is due soon! <br>
                    <span>Complete it before <strong><%=urgent.getDueDate()%></strong>.</span>
                </div>
            </div>
            <%
            }
            %>

            <h1 class="page-header"><i class="fas fa-tachometer-alt"></i> Student Dashboard</h1>
            
            <!-- Welcome Message -->
            <div class="card welcome-card">
                <h2 class="section-title">Welcome, ${user.username}!</h2>
                <p>Here's what's happening with your courses and assignments.</p>
            </div>

            <!-- Priority Assignments -->
            <div class="priority-section">
                <h2 class="section-title"><i class="fas fa-tasks"></i> Priority Assignments</h2>
                <div class="assignment-grid">
                    <c:choose>
                        <c:when test="${not empty assignments}">
                            <c:forEach var="assignment" items="${assignments}" varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="assignment-card">
                                        <div class="assignment-icon">
                                            <i class="fas fa-file-alt"></i>
                                        </div>
                                        <h3 class="assignment-name">${assignment.name}</h3>
                                        <p class="assignment-due-date">
                                            <i class="far fa-calendar-alt"></i>
                                            Due: <fmt:formatDate value="${assignment.dueDate}" pattern="MMM d, yyyy" />
                                        </p>
                                        <c:choose>
                                            <c:when test="${assignment.completed}">
                                                <span class="assignment-status status-completed">
                                                    <i class="fas fa-check-circle"></i> Completed
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="assignment-status status-pending">
                                                    <i class="fas fa-exclamation-circle"></i> Pending
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="card empty-state">
                                <i class="far fa-smile"></i>
                                <p>No upcoming assignments found.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Performance Overview -->
            <div class="card performance-card-container">
                <h2 class="section-title"><i class="fas fa-chart-line"></i> Performance Overview</h2>
                <div class="performance-overview">
                    <div class="performance-card">
                        <div class="performance-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <p class="performance-title">Completed</p>
                        <p class="performance-value">${completedAssignmentsCount}</p>
                    </div>
                    <div class="performance-card">
                        <div class="performance-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <p class="performance-title">Pending</p>
                        <p class="performance-value">${pendingAssignmentsCount}</p>
                    </div>
                    <div class="performance-card">
                        <div class="performance-icon">
                            <i class="fas fa-star"></i>
                        </div>
                        <p class="performance-title">CGPA</p>
                        <p class="performance-value">
                            <fmt:formatNumber value="${currentCgpa}" type="number" maxFractionDigits="2" />
                        </p>
                    </div>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="charts-container">
                <!-- Academic Performance Chart -->
                <div class="chart-container">
                    <div class="chart-header">
                        <h3 class="chart-title"><i class="fas fa-chart-bar"></i> Academic Performance</h3>
                        <div class="chart-controls">
                            <select id="chartType" class="chart-select" onchange="updateChart()">
                                <option value="subject">Subject-wise</option>
                                <option value="semester">Semester-wise</option>
                            </select>
                        </div>
                    </div>
                    <canvas id="performanceChart" width="400" height="200"></canvas>
                </div>

                <!-- Assignment Progress Chart -->
                <div class="chart-container">
                    <h3 class="chart-title"><i class="fas fa-chart-pie"></i> Assignment Progress</h3>
                    <canvas id="pieChart"></canvas>
                </div>
            </div>
        </main>
    </div>

    <!-- Load Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<%
Map<String, Float> subjectAverages = (Map<String, Float>) request.getAttribute("subjectAverages");
Map<String, Float> semesterAverages = (Map<String, Float>) request.getAttribute("semesterAverages");
Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("assignmentStats");
int completed = stats != null ? stats.getOrDefault("Completed", 0) : 0;
int pending = stats != null ? stats.getOrDefault("Pending", 0) : 0;
StringBuilder subjectLabels = new StringBuilder();
StringBuilder subjectData = new StringBuilder();
if (subjectAverages != null) {
    for (Map.Entry<String, Float> entry : subjectAverages.entrySet()) {
        subjectLabels.append("'").append(entry.getKey()).append("',");
        subjectData.append(entry.getValue()).append(",");
    }
}
StringBuilder semesterLabels = new StringBuilder();
StringBuilder semesterData = new StringBuilder();
if (semesterAverages != null) {
    for (Map.Entry<String, Float> entry : semesterAverages.entrySet()) {
        semesterLabels.append("'").append(entry.getKey()).append("',");
        semesterData.append(entry.getValue()).append(",");
    }
}
%>

<script>
const chartData = {
    subject : {
        labels : [<%=subjectLabels.toString()%>],
        data : [<%=subjectData.toString()%>],
        label : 'Subject Averages (%)',
        maxValue : 100,
        yAxisTitle : 'Percentage'
    },
    semester : {
        labels : [<%=semesterLabels.toString()%>],
        data : [<%=semesterData.toString()%>],
        label : 'Semester CGPA',
        maxValue : 10,
        yAxisTitle : 'CGPA'
    }
};

const ctx = document.getElementById('performanceChart').getContext('2d');
let performanceChart = new Chart(ctx, {
    type : 'bar',
    data : {
        labels : chartData.subject.labels,
        datasets : [ {
            label : chartData.subject.label,
            data : chartData.subject.data,
            backgroundColor : 'rgba(54, 162, 235, 0.6)',
            borderColor : 'rgba(54, 162, 235, 1)',
            borderWidth : 1
        } ]
    },
    options : {
        responsive : true,
        scales : {
            y : {
                beginAtZero : true,
                max : chartData.subject.maxValue,
                title : {
                    display : true,
                    text : chartData.subject.yAxisTitle
                },
                ticks : {
                    stepSize : chartData.subject.maxValue / 10
                }
            },
            x : {
                title : {
                    display : true,
                    text : 'Subjects'
                }
            }
        }
    }
});

function updateChart() {
    const chartType = document.getElementById('chartType').value;
    const data = chartData[chartType];
    performanceChart.data.labels = data.labels;
    performanceChart.data.datasets[0].data = data.data;
    performanceChart.data.datasets[0].label = data.label;
    performanceChart.options.scales.x.title.text = chartType === 'subject' ? 'Subjects' : 'Semesters';
    performanceChart.options.scales.y.max = data.maxValue;
    performanceChart.options.scales.y.title.text = data.yAxisTitle;
    performanceChart.options.scales.y.ticks.stepSize = data.maxValue / 10;
    performanceChart.update();
}

const pieData = {
    labels : [ 'Completed', 'Pending' ],
    datasets : [ {
        label : 'Assignments',
        data : [ <%=completed%>, <%=pending%> ],
        backgroundColor : [ '#4caf50', '#f44336' ],
        borderColor : [ '#388e3c', '#d32f2f' ],
        borderWidth : 1
    } ]
};

const pieConfig = {
    type : 'doughnut',
    data : pieData,
    options : {
        responsive : true,
        plugins : {
            legend : {
                position : 'bottom'
            }
        }
    }
};

new Chart(document.getElementById('pieChart'), pieConfig);
</script>
</body>
</html>