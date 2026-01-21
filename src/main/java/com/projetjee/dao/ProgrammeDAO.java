package com.projetjee.dao;

import com.projetjee.model.Programme;
import com.projetjee.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProgrammeDAO {

    private static final String INSERT_PROGRAMME = "INSERT INTO programme_formation (formation_id, titre_module, details, ordre) VALUES (?, ?, ?, ?)";
    private static final String SELECT_PROGRAMME_BY_FORMATION_ID = "SELECT * FROM programme_formation WHERE formation_id = ? ORDER BY ordre ASC";
    private static final String UPDATE_PROGRAMME = "UPDATE programme_formation SET titre_module = ?, details = ?, ordre = ? WHERE id = ?";
    private static final String DELETE_PROGRAMME = "DELETE FROM programme_formation WHERE id = ?";

    public void addProgramme(Programme programme) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_PROGRAMME)) {

            preparedStatement.setInt(1, programme.getFormationId());
            preparedStatement.setString(2, programme.getTitreModule());
            preparedStatement.setString(3, programme.getDetails());
            preparedStatement.setInt(4, programme.getOrdre());

            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Programme> getProgrammeByFormationId(int formationId) {
        List<Programme> programmes = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_PROGRAMME_BY_FORMATION_ID)) {

            preparedStatement.setInt(1, formationId);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                programmes.add(new Programme(
                        rs.getInt("id"),
                        rs.getInt("formation_id"),
                        rs.getString("titre_module"),
                        rs.getString("details"),
                        rs.getInt("ordre")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return programmes;
    }


    public void deleteModulesByFormationId(int formationId) {
        String sql = "DELETE FROM programme_formation WHERE formation_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, formationId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}