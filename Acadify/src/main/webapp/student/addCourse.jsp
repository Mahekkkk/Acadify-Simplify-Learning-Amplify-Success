<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Course | Acadify</title>
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
            --text-light: #5a6a8a;
            --card-bg: #ffffff;
            --card-shadow: 0 2px 8px rgba(44, 61, 115, 0.1);
            --input-border: #bdc3c7;
            --input-focus: #7CAADC;
            --error: #F44336;
        }

        /* Base Styles */
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--background);
            color: var(--text-color);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }

        /* Form Container */
        .form-container {
            width: 100%;
            max-width: 500px;
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            padding: 2.5rem;
            margin: 0 auto;
        }

        /* Header */
        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-title {
            color: var(--primary);
            font-size: 1.8rem;
            font-weight: 700;
            margin: 0 0 0.5rem 0;
        }

        .form-subtitle {
            color: var(--text-light);
            font-size: 1rem;
            margin: 0;
        }

        /* Form Elements */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--primary);
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid var(--input-border);
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--input-focus);
            outline: none;
            box-shadow: 0 0 0 3px rgba(124, 170, 220, 0.2);
        }

        /* Section Inputs */
        .section-container {
            margin-top: 1rem;
        }

        .section-input-group {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
        }

        .section-input {
            flex: 1;
        }

        /* Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            font-size: 1rem;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            transform: translateY(-2px);
        }

        .btn-accent {
            background-color: var(--accent);
            color: var(--primary);
            box-shadow: 0 4px 12px rgba(255, 211, 114, 0.3);
        }

        .btn-accent:hover {
            background-color: var(--accent-hover);
            color: white;
            transform: translateY(-2px);
        }

        .btn-block {
            display: block;
            width: 100%;
        }

        .btn-group {
            display: flex;
            gap: 0.75rem;
            margin-top: 2rem;
        }

        /* Back Link */
        .back-link {
            display: inline-flex;
            align-items: center;
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
            margin-top: 1.5rem;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: var(--secondary);
            text-decoration: underline;
        }

        .back-link svg {
            margin-right: 0.5rem;
        }

        /* Error Message */
        .error-message {
            color: var(--error);
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: flex;
            align-items: center;
        }

        .error-message svg {
            margin-right: 0.25rem;
        }

        /* Responsive */
        @media (max-width: 576px) {
            .form-container {
                padding: 1.5rem;
            }
            
            .btn-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="form-header">
            <h1 class="form-title">Add New Course</h1>
            <p class="form-subtitle">Enter course details and sections</p>
        </div>

        <form action="<%= request.getContextPath() %>/student/addCourse" method="post">
            <!-- Course Name -->
            <div class="form-group">
                <label for="courseName" class="form-label">Course Name</label>
                <input type="text" id="courseName" name="courseName" class="form-control" required 
                       placeholder="e.g. Introduction to Computer Science">
            </div>

            <!-- Sections -->
            <div class="form-group">
                <label class="form-label">Course Sections</label>
                <div id="sectionsContainer" class="section-container">
                    <div class="section-input-group">
                        <input type="text" name="sectionNames" class="form-control section-input" 
                               placeholder="Section name" required>
                    </div>
                </div>
                <button type="button" class="btn btn-primary" onclick="addSectionInput()">
                    + Add Another Section
                </button>
            </div>

            <!-- Form Actions -->
            <div class="btn-group">
                <button type="submit" class="btn btn-accent btn-block">Create Course</button>
            </div>
        </form>

        <a href="<%= request.getContextPath() %>/student/AddCourseServlet" class="back-link">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="19" y1="12" x2="5" y2="12"></line>
                <polyline points="12 19 5 12 12 5"></polyline>
            </svg>
            Back to Courses
        </a>
    </div>

    <script>
        function addSectionInput() {
            const container = document.getElementById('sectionsContainer');
            const div = document.createElement('div');
            div.className = 'section-input-group';
            
            const input = document.createElement('input');
            input.type = 'text';
            input.name = 'sectionNames';
            input.className = 'form-control section-input';
            input.placeholder = 'Section name';
            input.required = true;
            
            div.appendChild(input);
            container.appendChild(div);
            
            // Scroll to the new input
            input.focus();
        }
    </script>
</body>
</html>