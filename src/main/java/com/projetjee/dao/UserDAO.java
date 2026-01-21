package com.projetjee.dao;

import com.projetjee.model.User;
import com.projetjee.model.Formation;
import com.projetjee.util.DBConnection;
import com.projetjee.util.SecurityUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public boolean isEmailOrPhoneTaken(String email, String phone) {
        String sql = "SELECT count(*) FROM users WHERE email = ? OR phone_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, phone);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailOrPhoneTaken(String email, String phone, int excludeId) {
        String sql = "SELECT count(*) FROM users WHERE (email = ? OR phone_number = ?) AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, phone);
            ps.setInt(3, excludeId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addUser(User user) {
        String sql = "INSERT INTO users (email, password, first_name, last_name, phone_number, role) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFirstName());
            ps.setString(4, user.getLastName());
            ps.setString(5, user.getPhoneNumber());
            ps.setString(6, user.getRole());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) return false;

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    user.setId(rs.getInt(1));
                }
            }

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getLastInsertedId() {
        int id = -1;
        String sql = "SELECT LAST_INSERT_ID()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) id = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return id;
    }

    public boolean addFormateurFormations(int userId, String[] formationIds) {
        String sql = "INSERT INTO formateur_formation(formateur_id, formation_id) VALUES(?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (String fId : formationIds) {
                ps.setInt(1, userId);
                ps.setInt(2, Integer.parseInt(fId));
                ps.addBatch();
            }
            ps.executeBatch();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public User checkLogin(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, SecurityUtils.hashPassword(password));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE users SET first_name=?, last_name=?, email=?, phone_number=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhoneNumber());
            ps.setInt(5, user.getId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }



    private User mapUser(ResultSet rs) throws Exception {
        return new User(
                rs.getInt("id"),
                rs.getString("email"),
                rs.getString("first_name"),
                rs.getString("last_name"),
                rs.getString("phone_number"),
                rs.getString("role")
        );
    }

    public List<Integer> getFormateurFormationIds(int formateurId) {
        List<Integer> formationIds = new ArrayList<>();
        String sql = "SELECT formation_id FROM formateur_formation WHERE formateur_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, formateurId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                formationIds.add(rs.getInt("formation_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return formationIds;
    }


    public int countTodayHoursByTrainer(int formateurId) {
        int totalHours = 0;

        String sql =
                "SELECT SUM(TIMESTAMPDIFF(HOUR, r.heure_debut, r.heure_fin)) AS hours " +
                        "FROM reservation r " +
                        "JOIN formateur_formation ff ON r.formation_id = ff.formation_id " +
                        "WHERE ff.formateur_id = ? " +
                        "AND DATE(r.date_reservation) = CURDATE()";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, formateurId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                totalHours = rs.getInt("hours");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return totalHours;
    }

    public int countFormationsByTrainer(int formateurId) {
        return getFormateurFormationIds(formateurId).size();
    }
    public int countTodayReservations(int formateurId) {
        int totalReservations = 0;
        String sql = "SELECT COUNT(*) AS total " +
                "FROM reservations r " +
                "JOIN formateur_formation ff ON r.formation_id = ff.formation_id " +
                "WHERE ff.formateur_id = ? AND DATE(r.reservation_date) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, formateurId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalReservations = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalReservations;
    }



    public void deleteFormateurFormations(int formateurId) {
        String sql = "DELETE FROM formateur_formation WHERE formateur_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, formateurId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}