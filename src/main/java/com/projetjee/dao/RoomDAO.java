package com.projetjee.dao;

import com.projetjee.model.Room;
import com.projetjee.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    private static final String INSERT_ROOM = "INSERT INTO rooms (name, capacity, type) VALUES (?, ?, ?)";
    private static final String SELECT_ALL_ROOMS = "SELECT * FROM rooms";
    private static final String SELECT_ROOM_BY_ID = "SELECT * FROM rooms WHERE id = ?";
    private static final String UPDATE_ROOM = "UPDATE rooms SET name = ?, capacity = ?, type = ? WHERE id = ?";
    private static final String DELETE_ROOM = "DELETE FROM rooms WHERE id = ?";

    public void addRoom(Room room) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_ROOM)) {

            preparedStatement.setString(1, room.getName());
            preparedStatement.setInt(2, room.getCapacity());
            preparedStatement.setString(3, room.getType());

            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_ROOMS)) {

            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                rooms.add(new Room(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("capacity"),
                        rs.getString("type")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public Room getRoomById(int id) {
        Room room = null;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ROOM_BY_ID)) {

            preparedStatement.setInt(1, id);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                room = new Room(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("capacity"),
                        rs.getString("type")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return room;
    }

    public boolean updateRoom(Room room) {
        boolean rowUpdated = false;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_ROOM)) {

            preparedStatement.setString(1, room.getName());
            preparedStatement.setInt(2, room.getCapacity());
            preparedStatement.setString(3, room.getType());
            preparedStatement.setInt(4, room.getId());

            rowUpdated = preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }

    public boolean deleteRoom(int id) {
        boolean rowDeleted = false;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_ROOM)) {

            preparedStatement.setInt(1, id);
            rowDeleted = preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowDeleted;
    }
}