<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Verification Failed - Acadify</title>
    <style>
        :root {
            --primary: #2C3D73;
            --accent: #FFD372;
            --accent-hover: #F15B42;
            --background: #FDF6FA;
            --text-color: #2C3D73;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--background);
            color: var(--text-color);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
        }

        header {
            background-color: var(--primary);
            padding: 1.5rem;
            text-align: center;
            color: white;
        }

        main {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 3rem 2rem;
        }

        h2 {
            color: #cc0000;
            font-size: 2rem;
            margin-bottom: 1rem;
        }

        p {
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }

        a.btn {
            background-color: var(--accent);
            color: var(--primary);
            padding: 0.75rem 1.8rem;
            border: none;
            border-radius: 30px;
            font-weight: 600;
            text-decoration: none;
            box-shadow: 0 6px 15px rgba(255, 211, 114, 0.4);
            transition: all 0.3s ease;
        }

        a.btn:hover {
            background-color: var(--accent-hover);
            color: white;
            transform: scale(1.05);
        }

        footer {
            text-align: center;
            padding: 1rem;
            font-size: 0.9rem;
            background-color: #ffffff;
            border-top: 1px solid #ddd;
        }
    </style>
</head>
<body>
    <header>
        <h1>Acadify Student Portal</h1>
    </header>
    <main>
        <h2>Verification Failed!</h2>
        <p>The verification link is invalid or expired.</p>
        <a class="btn" href="register.jsp">Register Again</a>
    </main>
    <footer>
        &copy; 2025 Acadify &mdash; Made with ❤️ to simplify education by Mahek!
    </footer>
</body>
</html>
