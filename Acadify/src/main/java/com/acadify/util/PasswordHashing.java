package com.acadify.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordHashing {
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }

    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // Handle cases where the hashed password is not a valid BCrypt hash
            return false;
        }
    }
}