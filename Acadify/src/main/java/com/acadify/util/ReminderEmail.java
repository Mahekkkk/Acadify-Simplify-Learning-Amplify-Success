package com.acadify.util;

import com.acadify.dao.AssignmentDAO;
import com.acadify.dao.UserDao;
import com.acadify.model.Assignment;
import com.acadify.model.User;

import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class ReminderEmail {

    public static void send() {
        try (Connection conn = DatabaseUtil.getConnection()) {
            UserDao userDAO = new UserDao(conn);
            List<User> verifiedUsers = userDAO.getVerifiedUsers();

            // Prepare tomorrow’s date string
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_YEAR, 1);
            Date tomorrow = cal.getTime();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String tomorrowStr = sdf.format(tomorrow);

            System.out.println("📧 Sending reminders for assignments due on: " + tomorrowStr);
            System.out.println("👥 Verified users count: " + verifiedUsers.size());

            for (User user : verifiedUsers) {
                List<Assignment> assignments = AssignmentDAO.getAssignmentsDueTomorrow(user.getId());

                if (!assignments.isEmpty()) {
                    System.out.println(" → Sending to " + user.getEmail() + ": " + assignments.size() + " due tomorrow");

                    for (Assignment a : assignments) {
                        String subject = "📌 Reminder: Assignment due tomorrow!";
                        String body = "Hi " + user.getUsername() + ",\n\n"
                                + "This is a reminder that your assignment:\n\n"
                                + "📝 " + a.getName() + "\n"
                                + "📅 Due Date: " + sdf.format(a.getDueDate()) + "\n\n"
                                + "Please complete and submit it on time.\n\n"
                                + "– Team Acadify";

                        try {
                            EmailUtil.sendEmail(user.getEmail(), subject, body);
                            System.out.println("     ✉️ Email sent to: " + user.getEmail());
                        } catch (Exception e) {
                            System.out.println("     ❌ Failed to send email to: " + user.getEmail());
                            e.printStackTrace();
                        }
                    }
                }
            }

            System.out.println("✅ Reminder emails processed.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
