<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Acadify - Home</title>
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
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--background);
            color: var(--text-color);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        header {
            background-color: var(--primary);
            padding: 1.5rem 2rem;
            text-align: center;
            color: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        main {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 3rem 2rem;
            max-width: 1100px;
            width: 100%;
            margin: auto;
            flex-wrap: wrap;
        }

        .quote-section {
            max-width: 500px;
        }

        .quote {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            line-height: 1.4;
            position: relative;
            padding-left: 1rem;
            color: var(--primary);
        }

        .quote::before {
            content: "❝";
            font-size: 2.5rem;
            color: var(--quote-pink);
            position: absolute;
            left: -0.5rem;
            top: -0.5rem;
        }

        .get-started-btn {
            background-color: var(--accent);
            color: var(--primary);
            padding: 0.75rem 2rem;
            border: none;
            font-size: 1.2rem;
            font-weight: 600;
            border-radius: 30px;
            cursor: pointer;
            transition: transform 0.3s ease, background-color 0.3s ease;
            text-decoration: none;
            display: inline-block;
            box-shadow: 0 8px 20px rgba(255, 211, 114, 0.4);
        }

        .get-started-btn:hover {
            background-color: var(--accent-hover);
            color: white;
            transform: scale(1.05);
        }

        .illustration {
            flex: 1;
            min-width: 300px;
            text-align: center;
        }

        .illustration img {
            max-width: 100%;
            height: auto;
        }

        footer {
            text-align: center;
            padding: 1rem;
            font-size: 0.9rem;
            color: #555;
            background-color: #ffffff;
            margin-top: auto;
            border-top: 1px solid #ddd;
        }

        @media (max-width: 768px) {
            main {
                flex-direction: column;
                text-align: center;
                gap: 2rem;
            }

            .quote-section {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1>Acadify Student Portal</h1>
    </header>
    <main>
        <div class="quote-section">
            <div class="quote">Simplify Learning, Amplify Success</div>
            <a href="register.jsp" class="get-started-btn">Get Started</a>
        </div>
        <div class="illustration">
            <img src="https://cdn-icons-png.flaticon.com/512/3659/3659894.png" alt="Student Illustration" />
        </div>
    </main>
    <footer>
        &copy; 2025 Acadify &mdash; Made with ❤️ to simplify education by Mahek! 
    </footer>
</body>
</html>
