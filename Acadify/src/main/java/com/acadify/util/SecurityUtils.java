package com.acadify.util;

import com.acadify.model.User;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class SecurityUtils {

    /**
     * Checks if the current user is authenticated as an admin
     */
    public static boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && "admin".equalsIgnoreCase(user.getRole());
    }

    /**
     * Checks if the current user is authenticated as admin with debug logging
     */
    public static boolean isAdminWithLogging(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("[Security] No session found");
            return false;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            System.out.println("[Security] No user in session");
            return false;
        }

        boolean isAdmin = "admin".equalsIgnoreCase(user.getRole());
        if (!isAdmin) {
            System.out.println("[Security] User is not admin. Actual role: " + user.getRole());
        }

        return isAdmin;
    }

    /**
     * Checks if user has the required role
     */
    public static boolean hasRole(HttpServletRequest request, String requiredRole) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && requiredRole.equalsIgnoreCase(user.getRole());
    }

    /**
     * Checks user role and redirects to accessDenied.jsp if not authorized
     */
    public static boolean checkAndRedirect(HttpServletRequest request, HttpServletResponse response, String requiredRole) {
        if (!hasRole(request, requiredRole)) {
            try {
                response.sendRedirect(request.getContextPath() + "/accessDenied.jsp");
            } catch (IOException e) {
                e.printStackTrace();
            }
            return false;
        }
        return true;
    }
}
