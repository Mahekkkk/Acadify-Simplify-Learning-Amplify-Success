<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registration Successful</title>
    <style>
        /* Color Variables */
        :root {
            --primary: #2C3D73;
            --primary-hover: #1b2751;
            --secondary: #7CAADC;
            --accent: #FFD372;
            --accent-hover: #F15B42;
            --background: #FDF6FA;
            --text-color: #2C3D73;
            --success: #4CAF50;
        }

        /* Base Styles */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--background);
            color: var(--text-color);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            animation: fadeIn 1.5s ease forwards;
            opacity: 0;
        }

        /* Content Styles */
        .success-container {
            text-align: center;
            padding: 2rem;
            border-radius: 12px;
            background-color: white;
            box-shadow: 0 4px 20px rgba(44, 61, 115, 0.1);
            max-width: 500px;
            width: 90%;
        }

        h1 {
            font-size: 2.2rem;
            margin-bottom: 1.5rem;
            color: var(--primary);
            animation: bounce 2s infinite alternate;
        }

        p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            color: var(--text-color);
        }

        /* Button/Link Styles */
        .success-link {
            display: inline-block;
            background-color: var(--primary);
            color: white;
            text-decoration: none;
            font-weight: 600;
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            transition: all 0.3s ease;
            border: 2px solid var(--primary);
        }

        .success-link:hover {
            background-color: var(--primary-hover);
            border-color: var(--primary-hover);
            transform: translateY(-2px);
        }

        /* Animations */
        @keyframes fadeIn {
            to {
                opacity: 1;
            }
        }

        @keyframes bounce {
            0% { transform: translateY(0); }
            100% { transform: translateY(-8px); }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <h1>Registration Successful!</h1>
        <p>Welcome to Acadify. Your account has been created.</p>
        <a href="login.jsp" class="success-link">Login to Continue</a>
    </div>
</body>
</html>