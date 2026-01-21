package com.projetjee.dao;

import com.projetjee.model.Inscription;
import com.projetjee.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

public class InscriptionDAO {

    private static final String INSERT_INSCRIPTION = "INSERT INTO inscriptions (etudiant_id, formation_id) VALUES (?, ?)";


    public boolean addInscription(Inscription inscription) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_INSCRIPTION)) {

            preparedStatement.setInt(1, inscription.getEtudiantId());
            preparedStatement.setInt(2, inscription.getFormationId());

            return preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Inscription> getInscriptionsByFormation(int formationId) {
        List<Inscription> list = new ArrayList<>();
        String sql = "SELECT id, etudiant_id, formation_id, date_inscription FROM inscriptions WHERE formation_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, formationId);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                Inscription ins = new Inscription();
                ins.setId(rs.getInt("id"));
                ins.setEtudiantId(rs.getInt("etudiant_id"));
                ins.setFormationId(rs.getInt("formation_id"));
                ins.setDateInscription(rs.getTimestamp("date_inscription"));

                list.add(ins);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    public List<Inscription> getAllStudentInscriptions() {
        List<Inscription> list = new ArrayList<>();
        String sql = "SELECT i.id, i.etudiant_id, i.formation_id, i.date_inscription, " +
                "u.first_name, u.last_name, u.email, " +
                "f.nom AS formation_name " +
                "FROM inscriptions i " +
                "JOIN users u ON i.etudiant_id = u.id " +
                "JOIN formations f ON i.formation_id = f.id " +
                "ORDER BY i.date_inscription DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Inscription ins = new Inscription();
                ins.setId(rs.getInt("id"));
                ins.setEtudiantId(rs.getInt("etudiant_id"));
                ins.setFormationId(rs.getInt("formation_id"));
                ins.setDateInscription(rs.getTimestamp("date_inscription"));

                String fullName = rs.getString("first_name") + " " + rs.getString("last_name");
                ins.setStudentName(fullName);
                ins.setStudentEmail(rs.getString("email"));
                ins.setFormationName(rs.getString("formation_name"));

                list.add(ins);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getFormationIdByStudent(int studentId) {
        String sql = "SELECT formation_id FROM inscriptions WHERE etudiant_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("formation_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void updateStudentFormation(int studentId, int newFormationId) {
        String sql = "UPDATE inscriptions SET formation_id = ? WHERE etudiant_id = ?";

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement psUpdate = conn.prepareStatement(sql);
            psUpdate.setInt(1, newFormationId);
            psUpdate.setInt(2, studentId);

            if (psUpdate.executeUpdate() == 0) {
                String sqlInsert = "INSERT INTO inscriptions (formation_id, etudiant_id) VALUES (?, ?)";
                PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
                psInsert.setInt(1, newFormationId);
                psInsert.setInt(2, studentId);
                psInsert.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}