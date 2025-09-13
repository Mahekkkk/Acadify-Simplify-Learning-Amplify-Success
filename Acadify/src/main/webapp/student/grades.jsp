<%@ page import="java.util.*, com.acadify.model.Grade, com.acadify.util.GradeUtils" %>
<%@ page session="true" %>
<%
    List<Grade> grades = (List<Grade>) request.getAttribute("grades");
    String error = (String) request.getAttribute("error");

    Map<Integer, Float> semesterGrades = new TreeMap<>();
    Map<String, List<Grade>> subjectGrades = new HashMap<>();

    if (grades != null) {
        for (Grade g : grades) {
            if (g.getSemester() != null) {
                semesterGrades.put(g.getSemester(), g.getCgpa() != null ? g.getCgpa() : g.getMarks());
            } else if (g.getSubjectName() != null) {
                subjectGrades.computeIfAbsent(g.getSubjectName(), k -> new ArrayList<>()).add(g);
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Grades & Progress | Acadify</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/grades.css">
    <script>
        function toggleFields() {
            var type = document.getElementById('gradeType').value;
            if (type === 'semester') {
                document.getElementById('semesterField').style.display = 'block';
                document.getElementById('subjectNameField').style.display = 'none';
                document.getElementById('totalMarksField').style.display = 'none';
                document.getElementById('marksLabel').innerText = "CGPA (0.0-10.0):";
                document.getElementById('marks').max = 10;
            } else {
                document.getElementById('semesterField').style.display = 'none';
                document.getElementById('subjectNameField').style.display = 'block';
                document.getElementById('totalMarksField').style.display = 'block';
                document.getElementById('marksLabel').innerText = "Marks Obtained:";
                document.getElementById('marks').removeAttribute('max');
            }
        }

        function showAddGradeForm() {
            var form = document.getElementById('addGradeForm');
            form.style.display = (form.style.display === 'none' || form.style.display === '') ? 'block' : 'none';
        }

        window.onload = function() {
            toggleFields();
        };
    </script>
</head>
<body>
<div class="page-container">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="main-content">
        <h1 class="page-header">Grades & Progress</h1>

        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i><%= error %>
            </div>
        <% } %>

        <div class="action-bar">
            <button onclick="showAddGradeForm()" class="btn btn-accent">
                <i class="fas fa-plus"></i> Add New Grade
            </button>
        </div>

        <div id="addGradeForm" style="display: none;" class="card">
            <form action="${pageContext.request.contextPath}/grades" method="post">
                <div class="form-group">
                    <label for="gradeType">Grade Type</label>
                    <select id="gradeType" name="gradeType" onchange="toggleFields()">
                        <option value="semester">Semester</option>
                        <option value="subject">Subject</option>
                    </select>
                </div>

                <div id="semesterField" class="form-group">
                    <label for="semester">Semester</label>
                    <input type="number" id="semester" name="semester" min="1" max="10" />
                </div>

                <div id="subjectNameField" class="form-group" style="display: none;">
                    <label for="subjectName">Subject Name</label>
                    <input type="text" id="subjectName" name="subjectName" />
                </div>

                <div id="totalMarksField" class="form-group" style="display: none;">
                    <label for="totalMarks">Total Marks</label>
                    <input type="number" id="totalMarks" name="totalMarks" min="1" step="0.01" />
                </div>

                <div class="form-group">
                    <label id="marksLabel" for="marks">Marks</label>
                    <input type="number" id="marks" name="marks" step="0.01" min="0" required />
                </div>

                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Submit Grade
                </button>
            </form>
        </div>

        <div class="card">
            <h2 class="section-title"><i class="fas fa-graduation-cap"></i> Semester-wise CGPA</h2>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Semester</th>
                            <th>CGPA</th>
                            <th>Progress</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        Float prev = null;
                        for (Map.Entry<Integer, Float> entry : semesterGrades.entrySet()) {
                            Integer sem = entry.getKey();
                            Float cgpa = entry.getValue();
                            Float progress = GradeUtils.calcProgress(prev, cgpa);

                            String progressDisplay;
                            String cssClass = "";

                            if (progress == null) {
                                progressDisplay = "N/A (First semester)";
                            } else {
                                if (progress >= 0) {
                                    progressDisplay = String.format("+%.2f%%", progress);
                                    cssClass = "progress-positive";
                                } else {
                                    progressDisplay = String.format("%.2f%%", progress);
                                    cssClass = "progress-negative";
                                }
                            }
                    %>
                        <tr>
                            <td><%= sem %></td>
                            <td><%= String.format("%.2f", cgpa) %></td>
                            <td class="<%= cssClass %>">
                                <i class="fas <%= progress != null && progress >= 0 ? "fa-arrow-up" : "fa-arrow-down" %>"></i>
                                <%= progressDisplay %>
                            </td>
                        </tr>
                    <%
                            prev = cgpa;
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card">
            <h2 class="section-title"><i class="fas fa-book"></i> Subject-wise Grades</h2>
            <%
                for (Map.Entry<String, List<Grade>> subEntry : subjectGrades.entrySet()) {
                    String subject = subEntry.getKey();
                    List<Grade> subGrades = subEntry.getValue();
                    subGrades.sort(Comparator.comparing(Grade::getId));

                    Float prevMark = null;
            %>
                <div class="subject-section">
                    <div class="subject-name">
                        <i class="fas fa-book-reader"></i> <%= subject %>
                    </div>
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Entry ID</th>
                                    <th>Marks (Percentage)</th>
                                    <th>Progress</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Grade g : subGrades) {
                                        float percentage = g.getTotalMarks() != null ? (g.getMarks() / g.getTotalMarks()) * 100 : g.getMarks();
                                        Float progress = GradeUtils.calcProgress(prevMark, percentage);
                                        String pDisplay;
                                        String pClass = "";

                                        if (progress == null) {
                                            pDisplay = "N/A (First entry)";
                                        } else {
                                            if (progress >= 0) {
                                                pDisplay = String.format("+%.2f%%", progress);
                                                pClass = "progress-positive";
                                            } else {
                                                pDisplay = String.format("%.2f%%", progress);
                                                pClass = "progress-negative";
                                            }
                                        }
                                %>
                                    <tr>
                                        <td><%= g.getId() %></td>
                                        <td><%= String.format("%.2f%%", percentage) %></td>
                                        <td class="<%= pClass %>">
                                            <i class="fas <%= progress != null && progress >= 0 ? "fa-arrow-up" : "fa-arrow-down" %>"></i>
                                            <%= pDisplay %>
                                        </td>
                                    </tr>
                                <%
                                        prevMark = percentage;
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <%
                }
            %>
        </div>
    </main>
</div>
</body>
</html>