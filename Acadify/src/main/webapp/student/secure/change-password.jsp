<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Change Password | Acadify</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 500px;
            margin: 80px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #444;
        }

        input[type="password"] {
            width: 100%;
            padding: 12px 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 15px;
            transition: border 0.3s;
        }

        input[type="password"]:focus {
            border-color: #007bff;
            outline: none;
        }

        button[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button[type="submit"]:hover {
            background-color: #0056b3;
        }

        p a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #007bff;
        }

        p a:hover {
            text-decoration: underline;
        }

        .error {
            background-color: #ffe0e0;
            color: #a33;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #f5c2c2;
            border-radius: 8px;
            font-weight: bold;
            text-align: center;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
            border-radius: 8px;
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Change Password</h1>

        <%-- Display Error Message --%>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>

        <%-- Display Success Message --%>
        <% if (request.getAttribute("success") != null) { %>
            <p class="success"><%= request.getAttribute("success") %></p>
        <% } %>

<form action="${pageContext.request.contextPath}/changePassword" method="post">
         <div class="form-group">
                <label>Current Password:</label>
                <input type="password" name="currentPassword" required>
            </div>

            <div class="form-group">
                <label>New Password:</label>
                <input type="password" name="newPassword" required>
            </div>

            <div class="form-group">
                <label>Confirm New Password:</label>
                <input type="password" name="confirmPassword" required>
            </div>

            <button type="submit">Update Password</button>
        </form>

        <p><a href="${pageContext.request.contextPath}/student/dashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>
