package com.acadify.dao;

import com.acadify.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {
    private Connection conn;

    public UserDao(Connection conn) {
        this.conn = conn;
    }

    private static final String INSERT_SQL =
        "INSERT INTO users (username, email, password, is_verified, verification_token) VALUES (?, ?, ?, ?, ?)";

    private static final String SELECT_BY_EMAIL_SQL =
        "SELECT id, username, email, password, role, is_verified FROM users WHERE email = ?";

    public boolean addUser(User user) throws SQLException {
        if (!validateUserForRegistration(user)) {
            return false;
        }

        conn.setAutoCommit(false);

        try (PreparedStatement stmt = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getUsername().trim());
            stmt.setString(2, user.getEmail().trim().toLowerCase());
            stmt.setString(3, user.getPassword());
            stmt.setBoolean(4, user.isVerified());
            stmt.setString(5, user.getVerificationToken());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setId(rs.getInt(1));
                    }
                }
                conn.commit();
                return true;
            }
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        }
        return false;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, email, role, is_verified FROM users";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setIsVerified(rs.getBoolean("is_verified")); // ✅ add this
                users.add(user);
            }
        }
        return users;
    }


    public int getTotalUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getNewSignupsLastWeek() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public boolean setUserEnabled(int userId, boolean enabled) throws SQLException {
        String sql = "UPDATE users SET enabled = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, enabled);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateUserRole(int userId, String newRole) throws SQLException {
        String sql = "UPDATE users SET role = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newRole);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }

        try (PreparedStatement stmt = conn.prepareStatement(SELECT_BY_EMAIL_SQL)) {
            stmt.setString(1, email.trim().toLowerCase());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setIsVerified(rs.getBoolean("is_verified"));
                    return user;
                }
            }
        }
        return null;
    }

    public boolean updatePassword(int userId, String hashedPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, hashedPassword);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT id, username, email, role FROM users WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        }
        return null;
    }

    public boolean verifyUser(String token) throws SQLException {
        String query = "UPDATE users SET is_verified = TRUE, verification_token = NULL WHERE verification_token = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, token);
            int updated = stmt.executeUpdate();
            return updated > 0;
        }
    }

    private boolean validateUserForRegistration(User user) throws SQLException {
        if (user == null) return false;
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) return false;
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) return false;
        if (user.getPassword() == null || !user.getPassword().startsWith("$2a$")) return false;
        if (getUserByEmail(user.getEmail()) != null) return false;
        return true;
    }

    public User loginUser(String email, String password) throws SQLException {
        String sql = "SELECT id, username, email, password, role, is_verified FROM users WHERE email = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email.trim().toLowerCase());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    boolean isVerified = rs.getBoolean("is_verified");
                    String hashedPassword = rs.getString("password");

                    if (!isVerified) {
                        System.out.println("Login failed: user not verified.");
                        return null;
                    }

                    if (BCrypt.checkpw(password, hashedPassword)) {
                        User user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        user.setRole(rs.getString("role"));
                        user.setIsVerified(true);
                        return user;
                    } else {
                        System.out.println("Login failed: incorrect password.");
                        return null;
                    }
                } else {
                    System.out.println("Login failed: email not found.");
                }
            }
        }

        return null;
    }
    
    public List<User> getVerifiedUsers() {
        List<User> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM users WHERE is_verified = 1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setIsVerified(rs.getBoolean("is_verified"));
                list.add(user);
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


}
