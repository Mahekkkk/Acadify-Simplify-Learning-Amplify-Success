<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="page" value="courses" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Course Management | Acadify</title>
    <!-- Similar styling to users.jsp -->
</head>
<body>
    <!-- Similar structure to users.jsp with course-specific fields -->
    <table>
        <tr>
            <th>Course Code</th>
            <th>Course Name</th>
            <th>Instructor</th>
            <th>Actions</th>
        </tr>
        <c:forEach items="${courses}" var="course">
        <tr>
            <td>${course.code}</td>
            <td>${course.name}</td>
            <td>${course.instructor}</td>
            <td>
                <!-- Action buttons -->
            </td>
        </tr>
        </c:forEach>
    </table>
</body>
</html>