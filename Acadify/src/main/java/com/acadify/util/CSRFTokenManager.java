package com.acadify.util;

import java.security.SecureRandom;
import java.util.Base64;
import javax.servlet.http.HttpSession;
public class CSRFTokenManager {
    private static final int TOKEN_TIMEOUT_MINUTES = 10;
    private static final SecureRandom secureRandom = new SecureRandom();

    
    public static String generateToken(HttpSession session) {
        // Generate token
        byte[] tokenBytes = new byte[32];
        secureRandom.nextBytes(tokenBytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
        
        // Store with timestamp
        session.setAttribute("csrfToken", token);
        session.setAttribute("csrfTokenTime", System.currentTimeMillis());
        
        return token;
    }

    public static boolean validateToken(HttpSession session, String requestToken) {
        // Get stored values
        String sessionToken = (String) session.getAttribute("csrfToken");
        Long tokenTime = (Long) session.getAttribute("csrfTokenTime");
        
        // Basic validation
        if (sessionToken == null || tokenTime == null || !sessionToken.equals(requestToken)) {
            return false;
        }
        
        // Check expiration (10 minutes)
        long elapsedTime = (System.currentTimeMillis() - tokenTime) / (1000 * 60);
        return elapsedTime < TOKEN_TIMEOUT_MINUTES;
    }
}