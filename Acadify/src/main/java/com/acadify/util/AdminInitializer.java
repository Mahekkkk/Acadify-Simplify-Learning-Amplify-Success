package com.acadify.util;

import com.acadify.dao.UserDao;
import com.acadify.model.User;

import java.sql.Connection;

public class AdminInitializer {
    public static void ensureAdminExists() {
        try (Connection conn = DatabaseUtil.getConnection()) {
            UserDao userDao = new UserDao(conn);

            String adminEmail = "admin@acadify.com";

            User existingAdmin = userDao.getUserByEmail(adminEmail);
            if (existingAdmin == null) {
                User admin = new User();
                admin.setUsername("admin");
                admin.setEmail(adminEmail);
                admin.setPassword(PasswordHashing.hashPassword("Admin@123"));
                admin.setRole("admin");

                if (userDao.addUser(admin)) {
                    System.out.println("[SUCCESS] Default admin account created");
                } else {
                    System.err.println("[ERROR] Failed to create admin account");
                }
            } else {
                System.out.println("[INFO] Admin account already exists");
            }
        } catch (Exception e) {
            System.err.println("[CRITICAL] Admin initialization failed:");
            e.printStackTrace();
        }
    }
}
