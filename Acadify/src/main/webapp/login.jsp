<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Acadify</title>
    <style>
        :root {
            --primary: #2C3D73;
            --secondary: #7CAADC;
            --accent: #FFD372;
            --accent-hover: #F15B42;
            --background: #FDF6FA;
            --text-color: #2C3D73;
            --quote-pink: #F49CC4;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--background);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: var(--text-color);
        }

        .form-card {
            background: white;
            padding: 2.5rem;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 420px;
            border-top: 10px solid var(--accent);
        }

        .form-card h1 {
            color: var(--primary);
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--primary);
        }

        input[type="email"],
        input[type="password"],
        select {
            width: 100%;
            padding: 10px 12px;
            border: 2px solid var(--secondary);
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        input:focus,
        select:focus {
            border-color: var(--accent);
            outline: none;
        }

        button {
            width: 100%;
            padding: 12px;
            background: var(--primary);
            color: white;
            font-weight: bold;
            font-size: 1rem;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.2s ease;
            box-shadow: 0 8px 20px rgba(255, 211, 114, 0.4);
        }

        button:hover {
            background: var(--accent-hover);
            transform: scale(1.03);
        }

        .switch-link {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.95rem;
        }

        .switch-link a {
            color: var(--secondary);
            font-weight: 600;
            text-decoration: none;
        }

        .switch-link a:hover {
            text-decoration: underline;
            color: var(--accent-hover);
        }

        .error {
            color: red;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            text-align: center;
        }

        @media (max-width: 500px) {
            .form-card {
                padding: 2rem;
                margin: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="form-card">
        <h1>Login to Acadify</h1>
        <% 
    String flash = (String) session.getAttribute("flashMessage");
    if (flash != null) {
%>
    <div class="error" style="color: green;"><%= flash %></div>
<%
    session.removeAttribute("flashMessage");
    }
%>
        

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error"><%= request.getAttribute("errorMessage") %></div>
        <% } else if (request.getAttribute("errorType") != null) {
            String errorType = (String) request.getAttribute("errorType");
            if ("empty".equals(errorType)) { %>
                <div class="error">Please fill all fields.</div>
            <% } else if ("credentials".equals(errorType)) { %>
                <div class="error">Invalid email, password, or role.</div>
            <% } else if ("notVerified".equals(errorType)) { %>
                <div class="error">Please verify your email before logging in.</div>
            <% }
        } %>

        <%
            String csrfToken = (String) session.getAttribute("csrfToken");
            if (csrfToken == null) {
                csrfToken = java.util.UUID.randomUUID().toString();
                session.setAttribute("csrfToken", csrfToken);
            }
        %>

        <form action="${pageContext.request.contextPath}/login" method="post" onsubmit="return validateForm()">
            <!-- CSRF support can be added later -->
            <!-- <input type="hidden" name="csrfToken" value="<%= csrfToken %>"> -->

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" name="email" id="email" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" name="password" id="password" required>
            </div>

            <div class="form-group">
                <label for="role">Login As</label>
                <select name="role" id="role" required>
                    <option value="" disabled selected>Select User Type</option>
                    <option value="admin">Admin</option>
                    <option value="student">Student</option>
                </select>
            </div>

            <button type="submit">Login</button>
        </form>

        <div class="switch-link">
            New user? <a href="register.jsp">Register here</a>
        </div>
    </div>

    <script>
        function validateForm() {
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const role = document.getElementById('role').value;

            if (!email || !password || !role) {
                alert('Please fill all fields');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
