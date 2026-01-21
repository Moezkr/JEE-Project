package com.projetjee.dao;

import com.projetjee.model.Reservation;
import com.projetjee.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;


public class ReservationDAO {

    private static final String SELECT_RESERVATIONS_BY_USER =
            "SELECT r.id, r.start_time, r.end_time, r.user_id, r.room_id, r.formation_id, " +
                    "u.first_name, u.last_name, rm.name AS room_name " +
                    "FROM reservations r " +
                    "JOIN users u ON r.user_id = u.id " +
                    "JOIN rooms rm ON r.room_id = rm.id " +
                    "WHERE r.user_id = ? AND r.end_time >= NOW() " +
                    "ORDER BY r.start_time ASC";

    private static final String SELECT_RESERVATIONS_IN_PERIOD =
            "SELECT r.room_id, r.start_time, r.end_time " +
                    "FROM reservations r " +
                    "WHERE r.end_time > NOW() " +
                    "AND r.start_time < DATE_ADD(CURDATE(), INTERVAL ? DAY) " +
                    "ORDER BY r.room_id, r.start_time ASC";

    private static final String INSERT_RESERVATION_SQL =
            "INSERT INTO reservations (user_id, room_id, formation_id, start_time, end_time) VALUES (?, ?, ?, ?, ?)";

    private static final String DELETE_RESERVATION_SQL = "DELETE FROM reservations WHERE id = ?";

    private static final String CHECK_USER_CONFLICT =
            "SELECT count(*) FROM reservations WHERE user_id = ? AND " +
                    "((start_time < ? AND end_time > ?) OR " +
                    "(start_time < ? AND end_time > ?) OR " +
                    "(start_time >= ? AND end_time <= ?))";


    public boolean checkConflict(int roomId, Timestamp requestedStart, Timestamp requestedEnd) {
        String CHECK_CONFLICT =
                "SELECT count(*) FROM reservations WHERE room_id = ? AND " +
                        "((start_time < ? AND end_time > ?) OR " +
                        "(start_time < ? AND end_time > ?) OR " +
                        "(start_time >= ? AND end_time <= ?))";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(CHECK_CONFLICT)) {

            ps.setInt(1, roomId);
            ps.setTimestamp(2, requestedEnd);
            ps.setTimestamp(3, requestedStart);
            ps.setTimestamp(4, requestedStart);
            ps.setTimestamp(5, requestedEnd);
            ps.setTimestamp(6, requestedStart);
            ps.setTimestamp(7, requestedEnd);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkUserConflict(int userId, Timestamp requestedStart, Timestamp requestedEnd) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(CHECK_USER_CONFLICT)) {

            ps.setInt(1, userId);
            ps.setTimestamp(2, requestedEnd);
            ps.setTimestamp(3, requestedStart);
            ps.setTimestamp(4, requestedStart);
            ps.setTimestamp(5, requestedEnd);
            ps.setTimestamp(6, requestedStart);
            ps.setTimestamp(7, requestedEnd);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Reservation> getReservationsForNextDays(int days) {
        List<Reservation> reservations = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_RESERVATIONS_IN_PERIOD)) {

            ps.setInt(1, days);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Reservation res = new Reservation();
                res.setRoomId(rs.getInt("room_id"));
                res.setStartTime(rs.getTimestamp("start_time"));
                res.setEndTime(rs.getTimestamp("end_time"));

                reservations.add(res);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public List<Reservation> getReservationsByUserId(int userId) {
        List<Reservation> reservations = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_RESERVATIONS_BY_USER)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Reservation res = new Reservation(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("room_id"),
                        rs.getInt("formation_id"),
                        rs.getTimestamp("start_time"),
                        rs.getTimestamp("end_time")
                );
                res.setUserName(rs.getString("first_name") + " " + rs.getString("last_name"));
                res.setRoomName(rs.getString("room_name"));

                reservations.add(res);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public boolean createReservation(Reservation reservation) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_RESERVATION_SQL)) {

            ps.setInt(1, reservation.getUserId());
            ps.setInt(2, reservation.getRoomId());
            ps.setInt(3, reservation.getFormationId());
            ps.setTimestamp(4, reservation.getStartTime());
            ps.setTimestamp(5, reservation.getEndTime());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteReservation(int reservationId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_RESERVATION_SQL)) {

            ps.setInt(1, reservationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Reservation> getFilteredReservations(Date date, int trainerId) {
        List<Reservation> reservations = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT r.id, r.start_time, r.end_time, r.user_id, r.room_id, r.formation_id, " +
                        "u.first_name, u.last_name, rm.name AS room_name, f.nom AS formation_nom " +
                        "FROM reservations r " +
                        "JOIN users u ON r.user_id = u.id " +
                        "JOIN rooms rm ON r.room_id = rm.id " +
                        "JOIN formations f ON r.formation_id = f.id "
        );

        List<Object> parameters = new ArrayList<>();
        boolean firstWhere = true;

        if (trainerId > 0) {
            sql.append(" WHERE r.user_id = ?");
            parameters.add(trainerId);
            firstWhere = false;
        }

        if (date != null) {
            sql.append(firstWhere ? " WHERE " : " AND ");
            sql.append(" DATE(r.start_time) = ?");
            parameters.add(date);
        }

        sql.append(" ORDER BY r.start_time ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reservation res = new Reservation(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("room_id"),
                        rs.getInt("formation_id"),
                        rs.getTimestamp("start_time"),
                        rs.getTimestamp("end_time")
                );
                res.setUserName(rs.getString("first_name") + " " + rs.getString("last_name"));
                res.setRoomName(rs.getString("room_name"));
                res.setFormationNom(rs.getString("formation_nom"));

                reservations.add(res);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reservations;
    }


    public List<Reservation> getWeeklyReservationsByFormateur(int formateurId) {
        List<Reservation> list = new ArrayList<>();

        String sql =
                "SELECT r.id, r.user_id, r.room_id, r.formation_id, r.start_time, r.end_time, " +
                        "rm.name AS room_name, f.nom AS formation_nom " +
                        "FROM reservations r " +
                        "JOIN rooms rm ON r.room_id = rm.id " +
                        "JOIN formations f ON r.formation_id = f.id " +
                        "WHERE r.user_id = ? " +
                        "AND r.end_time >= NOW() " +
                        "AND r.start_time < DATE_ADD(CURDATE(), INTERVAL 14 DAY) " +
                        "ORDER BY r.start_time ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, formateurId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                Reservation r = new Reservation(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("room_id"),
                        rs.getInt("formation_id"),
                        rs.getTimestamp("start_time"),
                        rs.getTimestamp("end_time")
                );

                r.setFormationNom(rs.getString("formation_nom"));
                r.setRoomName(rs.getString("room_name"));

                list.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    private static final String SELECT_RESERVATIONS_BY_ETUDIANT_FORMATIONS =
            "SELECT r.id, r.start_time, r.end_time, r.room_id, r.formation_id, " +
                    "rm.name AS room_name, f.nom AS formation_nom " +
                    "FROM reservations r " +
                    "JOIN rooms rm ON r.room_id = rm.id " +
                    "JOIN formations f ON r.formation_id = f.id " +
                    "WHERE r.formation_id IN (SELECT formation_id FROM inscriptions WHERE etudiant_id = ?) " +
                    "AND r.end_time >= NOW() " +
                    "ORDER BY r.start_time ASC";

    public List<Reservation> getFutureSessionsByEtudiant(int etudiantId) {
        List<Reservation> sessions = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_RESERVATIONS_BY_ETUDIANT_FORMATIONS)) {

            ps.setInt(1, etudiantId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Reservation r = new Reservation();

                r.setId(rs.getInt("id"));
                r.setRoomId(rs.getInt("room_id"));
                r.setFormationId(rs.getInt("formation_id"));
                r.setStartTime(rs.getTimestamp("start_time"));
                r.setEndTime(rs.getTimestamp("end_time"));
                r.setRoomName(rs.getString("room_name"));
                r.setFormationNom(rs.getString("formation_nom"));

                sessions.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sessions;
    }

}