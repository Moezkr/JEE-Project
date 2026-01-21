package com.projetjee.config;

import com.projetjee.util.DBConnection;
import com.projetjee.util.SecurityUtils;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebListener
public class AppInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("--- APPLICATION STARTING: CHECKING DATABASE SEEDING ---");
        seedDatabase();
    }

    private void seedDatabase() {
        try (Connection conn = DBConnection.getConnection()) {

            String checkSql = "SELECT count(*) FROM users WHERE email = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, "admin@gmail.com");
                ResultSet rs = checkStmt.executeQuery();
                rs.next();

                if (rs.getInt(1) == 0) {
                    System.out.println("No Admin found. Seeding default Admin...");

                    String insertSql = "INSERT INTO users (email, password, full_name, role) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setString(1, "admin@gmail.com");
                        insertStmt.setString(2, SecurityUtils.hashPassword("1234"));
                        insertStmt.setString(3, "Directeur du Centre");
                        insertStmt.setString(4, "ADMIN");
                        insertStmt.executeUpdate();
                        System.out.println("Admin seeded successfully! (Pass: 1234)");
                    }
                } else {
                    System.out.println("Admin already exists. Skipping seed.");
                }
            }

            String checkRooms = "SELECT count(*) FROM rooms";
            try(PreparedStatement ps = conn.prepareStatement(checkRooms)) {
                ResultSet rs = ps.executeQuery();
                rs.next();
                if(rs.getInt(1) == 0) {
                    System.out.println("No Rooms found. Seeding default Training Rooms...");
                    String insertRoom = "INSERT INTO rooms (name, capacity, type) VALUES (?, ?, ?)";
                    try(PreparedStatement roomStmt = conn.prepareStatement(insertRoom)) {
                        roomStmt.setString(1, "Labo Informatique 1");
                        roomStmt.setInt(2, 20);
                        roomStmt.setString(3, "Laboratoire");
                        roomStmt.executeUpdate();

                        roomStmt.setString(1, "Salle de Formation A");
                        roomStmt.setInt(2, 40);
                        roomStmt.setString(3, "Cours Théorique");
                        roomStmt.executeUpdate();

                        roomStmt.setString(1, "Auditorium Principal");
                        roomStmt.setInt(2, 100);
                        roomStmt.setString(3, "Conférence");
                        roomStmt.executeUpdate();

                        System.out.println("Training Center rooms seeded successfully!");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("ERROR SEEDING DATABASE: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

    }
}