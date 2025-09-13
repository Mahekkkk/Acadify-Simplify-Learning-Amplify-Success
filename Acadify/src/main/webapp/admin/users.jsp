<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="page" value="users" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management | Acadify</title>
    <style>
        .user-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        .user-table th {
            background-color: #6a1b9a;
            color: white;
            padding: 12px;
            text-align: left;
        }
        .user-table td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        .action-btn {
            padding: 6px 12px;
            margin-right: 5px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .edit-btn { background-color: #4a6fa5; color: white; }
        .delete-btn { background-color: #e74c3c; color: white; }
    </style>
</head>
<body>
    <jsp:include page="../includes/header.jsp">
        <jsp:param name="title" value="User Management"/>
    </jsp:include>

    <div class="dashboard-container">
        <jsp:include page="../includes/admin-sidebar.jsp"/>
        
        <div class="main-content">
            <div class="card">
                <h2>User Management</h2>
                <table class="user-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${users}" var="user">
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.username}</td>
                            <td>${user.email}</td>
                            <td>${user.role}</td>
                            <td>
                                <a href="edit-user?id=${user.id}" class="action-btn edit-btn">Edit</a>
                                <form action="delete-user" method="post" style="display:inline;">
                                    <input type="hidden" name="userId" value="${user.id}">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <button type="submit" class="action-btn delete-btn">Delete</button>
                                </form>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="../includes/footer.jsp"/>
</body>
</html>