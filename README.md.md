# Acadify

Acadify is a Java web application built with JSP and Servlets for managing courses, assignments, and student performance.

---

## Table of Contents
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Project Structure](#project-structure)
- [Screenshots](#screenshots)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

---

## Features
- Dashboard showing ongoing courses and performance overview
- Assignment management with priority alerts and email reminders
- Registration and login with email verification
- Modular UI with reusable sidebar and components
- Performance comparison and record tracking

---

## Technologies Used
- Java (Servlets, JSP)
- JSTL
- MySQL
- JavaMail API (for email verification & reminders)
- HTML, CSS, JavaScript

---

## Project Structure
```
Acadify/
│-- src/             # Java source files
│-- WebContent/      # JSP pages, CSS, JS
│-- images/          # Screenshots for README
│-- database/        # SQL scripts
│-- README.md
│-- pom.xml / build files
```

---

## Setup Instructions

### 1. Import into Eclipse
1. Open Eclipse IDE  
2. Go to **File → Import → Existing Projects into Workspace**  
3. Select the cloned project folder  
4. Click **Finish**

### 2. Configure Tomcat Server
1. Download & install **Apache Tomcat 9+**  
2. In Eclipse: **Window → Preferences → Server → Runtime Environments → Add**  
3. Set the Tomcat installation path

### 3. Setup Database
1. Open MySQL  
2. Create a database named `acadify`  
3. Run the SQL script:
```sql
source database/schema.sql;
```

### 4. Update Database Credentials
In your DB connection file (e.g., `DBConnection.java`), update:

```java
String url = "jdbc:mysql://localhost:3306/acadify";
String user = "root";
String password = "your_password";
```

### 5. Run the Application
- Right-click the project → **Run As → Run on Server**  
- Open browser → `http://localhost:8080/Acadify`

---

## Screenshots

### Dashboard
![Dashboard](images/dashboard.png)

### Assignments Manager
![Assignments](images/assignments.png)

### Email Reminder
![Email Reminder](images/email_reminder.png)

---

## Usage
- Register as a new user and verify your email  
- Login to view the dashboard  
- Add and manage assignments  
- Get email reminders for priority tasks  
- Track performance across courses

---

## Contributing
1. Fork the repository  
2. Create a new branch  
3. Commit your changes  
4. Push and create a pull request

---

## License
This project is licensed under MIT License.
