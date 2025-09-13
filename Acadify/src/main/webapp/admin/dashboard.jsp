<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="page" value="dashboard" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Acadify - Admin Dashboard</title>
    <!-- Add jQuery for AJAX -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* Your existing styles here */
    </style>
</head>
<body>
    <jsp:include page="/includes/spinner.jsp">
        <jsp:param name="color" value="#d32f2f" />
        <jsp:param name="bgColor" value="#ffcdd2" />
    </jsp:include>

    <div class="header">
        <h1>Acadify Admin Portal</h1>
        <div>
            <span>Welcome, ${user.username}!</span>
            <a href="../logout" style="color: white; margin-left: 1rem;">Logout</a>
        </div>
    </div>
<jsp:include page="../includes/admin-sidebar.jsp" />

            <!-- Rest of your content -->
        </main>
    </div>

    <script>
    $(document).ready(function() {
        // Function to fetch and update dashboard data
        function updateDashboardData() {
            $.ajax({
                url: 'dashboard-data',
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    // Update the stats cards
                    $('#total-users').text(data.totalUsers.toLocaleString());
                    $('#active-courses').text(data.activeCourses);
                    $('#new-signups').text(data.newSignups);
                    $('#system-health').text(data.systemHealth + '%');
                    
                    // Add animation to show update
                    $('.stat-card').css('background-color', '#e1f5fe');
                    setTimeout(function() {
                        $('.stat-card').css('background-color', '');
                    }, 500);
                },
                error: function() {
                    console.error('Error fetching dashboard data');
                }
            });
        }
        
        // Initial load
        updateDashboardData();
        
        // Update every 30 seconds
        setInterval(updateDashboardData, 30000);
        
        // You can add similar AJAX calls for the Recent Activity and Pending Actions sections
    });
    </script>
</body>
</html>