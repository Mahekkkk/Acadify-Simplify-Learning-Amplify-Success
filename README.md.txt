# Acadify – Student Academic Performance Tracker

Acadify is a JSP/Servlet-based web application designed to help students manage their academic progress efficiently.  
It provides a dashboard for tracking courses, grades, and assignments, along with smart reminders and email notifications.

---

## ✨ Features
- 📊 **Dashboard** – Track ongoing courses and overall performance.
- 📝 **Assignments Manager** – Add, view, and prioritize assignments.
- 🔔 **Reminders** – Alerts for upcoming and urgent assignments.
- 📧 **Email Notifications** – Automated reminders via email (JavaMail API).
- 👤 **User Management** – Secure registration, login, and email verification.
- 📈 **Visual Insights** – Performance charts and progress tracking.

---

## 🛠️ Tech Stack
- **Frontend**: JSP, HTML, CSS, JSTL
- **Backend**: Java Servlets
- **Database**: MySQL
- **Email Service**: JavaMail API
- **IDE**: Eclipse
- **Server**: Apache Tomcat

---

## 🚀 Installation & Setup

Follow these steps to run the project on your local machine:

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/Acadify-Simplify-Learning-And-Performance.git
   cd Acadify-Simplify-Learning-And-Performance
Import into Eclipse

Open Eclipse IDE

Go to File > Import > Existing Projects into Workspace

Select the cloned project folder

Finish import

Configure Tomcat Server

Download & install Apache Tomcat 9+

In Eclipse: Window > Preferences > Server > Runtime Environments → Add Tomcat installation path

Setup Database

Open MySQL

Create a database named acadify

Run the SQL script:

source database/schema.sql;


Update Database Credentials
In your DB connection file (e.g., DBConnection.java):

String url = "jdbc:mysql://localhost:3306/acadify";
String user = "root";
String password = "your_password";


Run the Application

Right-click the project → Run As > Run on Server

Open browser → http://localhost:8080/Acadify

📸 Screenshots
Dashboard

Assignments Manager

Email Reminder

📂 Project Structure