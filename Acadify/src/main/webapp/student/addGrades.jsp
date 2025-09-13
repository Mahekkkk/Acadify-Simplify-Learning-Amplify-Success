<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Grades</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background: #f9f9f9; }
        h2 { color: #333; }
        form { background: #fff; padding: 20px; border: 1px solid #ddd; width: 400px; }
        label { display: block; margin-top: 10px; }
        input, select { 
            width: 100%; 
            padding: 8px; 
            margin-top: 5px; 
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        input[type="submit"] { 
            margin-top: 20px; 
            background: #007BFF; 
            color: white; 
            border: none; 
            cursor: pointer;
            padding: 10px;
            font-weight: bold;
        }
        a { 
            display: inline-block; 
            margin-top: 20px; 
            color: #007BFF; 
            text-decoration: none; 
        }
        .error-message {
            color: red;
            margin-top: 5px;
            font-size: 0.9em;
        }
    </style>
    <script>
        function toggleFields() {
            const type = document.getElementById('gradeType').value;
            
            // Reset error messages
            document.getElementById('error-semester').textContent = '';
            document.getElementById('error-subject').textContent = '';
            document.getElementById('error-totalMarks').textContent = '';
            document.getElementById('error-marks').textContent = '';
            
            // Toggle fields
            document.getElementById('semesterField').style.display = 
                (type === 'semester') ? 'block' : 'none';
            document.getElementById('subjectField').style.display = 
                (type === 'subject') ? 'block' : 'none';
            document.getElementById('totalMarksField').style.display = 
                (type === 'subject') ? 'block' : 'none';

            // Update labels
            const marksLabel = document.getElementById('marksLabel');
            if (type === 'semester') {
                marksLabel.textContent = "CGPA (0.0-10.0):";
                document.getElementById('marks').max = 10;
            } else if (type === 'subject') {
                marksLabel.textContent = "Marks Obtained:";
                document.getElementById('marks').removeAttribute('max');
            }
        }

        function validateForm() {
            const type = document.getElementById('gradeType').value;
            let isValid = true;
            
            // Clear previous errors
            document.getElementById('error-semester').textContent = '';
            document.getElementById('error-subject').textContent = '';
            document.getElementById('error-totalMarks').textContent = '';
            document.getElementById('error-marks').textContent = '';
            
            if (type === 'semester') {
                // Validate semester number
                const semester = document.getElementById('semester').value;
                if (!semester || semester < 1 || semester > 12) {
                    document.getElementById('error-semester').textContent = 
                        'Please enter a valid semester (1-12)';
                    isValid = false;
                }
                
                // Validate CGPA
                const cgpa = parseFloat(document.getElementById('marks').value);
                if (isNaN(cgpa) {
                    document.getElementById('error-marks').textContent = 
                        'Please enter a valid CGPA';
                    isValid = false;
                } else if (cgpa < 0 || cgpa > 10) {
                    document.getElementById('error-marks').textContent = 
                        'CGPA must be between 0.0 and 10.0';
                    isValid = false;
                }
                
            } else if (type === 'subject') {
                // Validate subject name
                const subjectName = document.getElementById('subjectName').value;
                if (!subjectName || subjectName.trim() === '') {
                    document.getElementById('error-subject').textContent = 
                        'Please enter a subject name';
                    isValid = false;
                }
                
                // Validate total marks
                const totalMarks = parseFloat(document.getElementById('totalMarks').value);
                if (isNaN(totalMarks)) {
                    document.getElementById('error-totalMarks').textContent = 
                        'Please enter total marks';
                    isValid = false;
                } else if (totalMarks <= 0) {
                    document.getElementById('error-totalMarks').textContent = 
                        'Total marks must be greater than 0';
                    isValid = false;
                }
                
                // Validate obtained marks
                const marks = parseFloat(document.getElementById('marks').value);
                if (isNaN(marks)) {
                    document.getElementById('error-marks').textContent = 
                        'Please enter obtained marks';
                    isValid = false;
                } else if (marks < 0) {
                    document.getElementById('error-marks').textContent = 
                        'Marks cannot be negative';
                    isValid = false;
                } else if (!isNaN(totalMarks) && marks > totalMarks) {
                    document.getElementById('error-marks').textContent = 
                        'Obtained marks cannot exceed total marks';
                    isValid = false;
                }
            }
            
            return isValid;
        }
    </script>
</head>
<body>
    <h2>Add Grades</h2>
    <form method="post" action="${pageContext.request.contextPath}/grades" onsubmit="return validateForm()">
        <div class="form-group">
            <label for="gradeType">Grade Type:</label>
            <select id="gradeType" name="gradeType" onchange="toggleFields()" required>
                <option value="">--Select--</option>
                <option value="semester">Semester-wise (CGPA)</option>
                <option value="subject">Subject-wise</option>
            </select>
        </div>

        <div id="semesterField" style="display:none;">
            <div class="form-group">
                <label for="semester">Semester Number:</label>
                <input type="number" id="semester" name="semester" min="1" max="12">
                <div id="error-semester" class="error-message"></div>
            </div>
        </div>

        <div id="subjectField" style="display:none;">
            <div class="form-group">
                <label for="subjectName">Subject Name:</label>
                <input type="text" id="subjectName" name="subjectName" maxlength="50">
                <div id="error-subject" class="error-message"></div>
            </div>
        </div>

        <div id="totalMarksField" style="display:none;">
            <div class="form-group">
                <label for="totalMarks">Total Marks:</label>
                <input type="number" id="totalMarks" name="totalMarks" min="0.01" step="0.01">
                <div id="error-totalMarks" class="error-message"></div>
            </div>
        </div>

        <div class="form-group">
            <label id="marksLabel" for="marks">Marks / CGPA:</label>
            <input type="number" id="marks" name="marks" min="0" step="0.01">
            <div id="error-marks" class="error-message"></div>
        </div>

        <input type="submit" value="Submit">
    </form>

    <a href="${pageContext.request.contextPath}/grades">← Back to Grades</a>
</body>
</html>