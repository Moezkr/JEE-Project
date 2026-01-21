package com.projetjee.dao;

import com.projetjee.model.Formation;
import com.projetjee.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FormationDAO {

    private static final String INSERT_FORMATION =
            "INSERT INTO formations (nom, description, prix, duree_mois) VALUES (?, ?, ?, ?)";

    private static final String SELECT_ALL_FORMATIONS =
            "SELECT id, nom, description, prix, duree_mois FROM formations";

    private static final String SELECT_FORMATION_BY_ID =
            "SELECT id, nom, description, prix, duree_mois FROM formations WHERE id = ?";

    private static final String UPDATE_FORMATION =
            "UPDATE formations SET nom = ?, description = ?, prix = ?, duree_mois = ? WHERE id = ?";

    private static final String DELETE_FORMATION =
            "DELETE FROM formations WHERE id = ?";

    public void addFormation(Formation formation) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(INSERT_FORMATION)) {

            ps.setString(1, formation.getNom());
            ps.setString(2, formation.getDescription());
            ps.setBigDecimal(3, formation.getPrix());
            ps.setInt(4, formation.getDureeMois());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Formation> getAllFormations() {
        List<Formation> formations = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ALL_FORMATIONS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                formations.add(new Formation(
                        rs.getInt("id"),
                        rs.getString("nom"),
                        rs.getString("description"),
                        rs.getBigDecimal("prix"),
                        rs.getInt("duree_mois")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return formations;
    }

    public Formation getFormationById(int id) {
        Formation f = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_FORMATION_BY_ID)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                f = new Formation(
                        rs.getInt("id"),
                        rs.getString("nom"),
                        rs.getString("description"),
                        rs.getBigDecimal("prix"),
                        rs.getInt("duree_mois")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return f;
    }

    public boolean updateFormation(Formation formation) {
        boolean updated = false;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_FORMATION)) {

            ps.setString(1, formation.getNom());
            ps.setString(2, formation.getDescription());
            ps.setBigDecimal(3, formation.getPrix());
            ps.setInt(4, formation.getDureeMois());
            ps.setInt(5, formation.getId());

            updated = ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return updated;
    }

    public boolean deleteFormation(int id) {
        boolean deleted = false;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_FORMATION)) {

            ps.setInt(1, id);
            deleted = ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return deleted;
    }

    public int getLastInsertedId() {
        String sql = "SELECT MAX(id) FROM formations";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    public List<Formation> getFormationsByFormateur(int trainerId) {
        List<Formation> formations = new ArrayList<>();
        String sql = "SELECT f.* FROM formations f " +
                "JOIN formateur_formation ff ON f.id = ff.formation_id " +
                "WHERE ff.formateur_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, trainerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                formations.add(new Formation(
                        rs.getInt("id"),
                        rs.getString("nom"),
                        rs.getString("description"),
                        rs.getBigDecimal("prix"),
                        rs.getInt("duree_mois")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return formations;
    }

}