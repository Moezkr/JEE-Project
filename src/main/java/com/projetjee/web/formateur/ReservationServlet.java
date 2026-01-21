package com.projetjee.web.formateur;

import com.projetjee.dao.FormationDAO;
import com.projetjee.dao.ReservationDAO;
import com.projetjee.dao.RoomDAO;
import com.projetjee.model.Formation;
import com.projetjee.model.Reservation;
import com.projetjee.model.Room;
import com.projetjee.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/formateur/salles")
public class ReservationServlet extends HttpServlet {

    private RoomDAO roomDAO;
    private ReservationDAO reservationDAO;
    private FormationDAO formationDAO;

    private static final DateTimeFormatter DATE_HOUR_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");


    @Override
    public void init() {
        roomDAO = new RoomDAO();
        reservationDAO = new ReservationDAO();
        formationDAO = new FormationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User sessionUser = (User) request.getSession().getAttribute("user");
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/formateur/salles";

        if ("delete".equals(action)) {
            handleDeleteReservation(request, response, redirectUrl);
            return;
        }

        List<Room> allRooms = roomDAO.getAllRooms();
        request.setAttribute("allRooms", allRooms);

        List<Formation> userFormations = formationDAO.getFormationsByFormateur(sessionUser.getId());
        request.setAttribute("userFormations", userFormations);

        final int DAYS_TO_LOAD = 14;
        List<Reservation> futureReservations = reservationDAO.getReservationsForNextDays(DAYS_TO_LOAD);
        request.setAttribute("futureReservations", futureReservations);

        List<Reservation> userReservations = reservationDAO.getReservationsByUserId(sessionUser.getId());
        request.setAttribute("userReservations", userReservations);

        String role = sessionUser.getRole().toLowerCase();
        String jspPath;

        if ("formateur".equals(role)) {
            jspPath = "/formateur/salles/salles_disponibles.jsp";
        } else if ("admin".equals(role)) {
            jspPath = "/admin/salles/salles_disponibles.jsp";
        } else {
            response.sendRedirect(request.getContextPath() + "/" + role + "/dashboard.jsp");
            return;
        }

        request.getRequestDispatcher(jspPath).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User sessionUser = (User) request.getSession().getAttribute("user");
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            handleCreateReservation(request, response, sessionUser);
        } else {
            doGet(request, response);
        }
    }

    private void handleCreateReservation(HttpServletRequest request, HttpServletResponse response, User sessionUser) throws IOException {
        try {
            int userId = sessionUser.getId();
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int formationId = Integer.parseInt(request.getParameter("formationId"));

            String dateStr = request.getParameter("startDate");
            int startHour = Integer.parseInt(request.getParameter("startHour"));
            int durationHours = Integer.parseInt(request.getParameter("durationHours"));

            String startDateTimeString = dateStr + " " + String.format("%02d", startHour) + ":00";

            LocalDateTime startLDT = LocalDateTime.parse(startDateTimeString, DATE_HOUR_FORMATTER);
            LocalDateTime endLDT = startLDT.plusHours(durationHours);

            Timestamp startTime = Timestamp.valueOf(startLDT);
            Timestamp endTime = Timestamp.valueOf(endLDT);

            String redirectUrl = request.getContextPath() + "/formateur/salles";

            if (startTime.before(new Timestamp(System.currentTimeMillis()))) {
                sendError(response, redirectUrl, "La date de début doit être future.");
                return;
            }
            if (endLDT.getHour() > 18 || (endLDT.getHour() == 18 && endLDT.getMinute() > 0) || startLDT.getHour() < 8) {
                sendError(response, redirectUrl, "La réservation doit être entièrement comprise entre 08:00 et 18:00.");
                return;
            }


            if (reservationDAO.checkUserConflict(userId, startTime, endTime)) {
                sendError(response, redirectUrl, "Vous avez déjà une réservation planifiée pour ce créneau horaire. Un utilisateur ne peut pas réserver deux salles à la fois.");
                return;
            }

            if (reservationDAO.checkConflict(roomId, startTime, endTime)) {
                sendError(response, redirectUrl, "La salle est déjà réservée pour ce créneau.");
                return;
            }

            Reservation newReservation = new Reservation();
            newReservation.setUserId(userId);
            newReservation.setRoomId(roomId);
            newReservation.setFormationId(formationId);
            newReservation.setStartTime(startTime);
            newReservation.setEndTime(endTime);

            if (reservationDAO.createReservation(newReservation)) {
                sendSuccess(response, redirectUrl, "Réservation effectuée avec succès !");
            } else {
                sendError(response, redirectUrl, "Erreur lors de l'enregistrement de la réservation.");
            }

        } catch (NumberFormatException e) {
            sendError(response, request.getContextPath() + "/formateur/salles", "Données de formulaire invalides. Veuillez vérifier les nombres.");
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, request.getContextPath() + "/formateur/salles", "Erreur inattendue lors de la création de la réservation.");
        }
    }

    private void handleDeleteReservation(HttpServletRequest request, HttpServletResponse response, String redirectUrl) throws IOException {
        try {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));

            if (reservationDAO.deleteReservation(reservationId)) {
                sendSuccess(response, redirectUrl, "La réservation a été annulée avec succès.");
            } else {
                sendError(response, redirectUrl, "Impossible d'annuler la réservation. ID inconnu ou erreur base de données.");
            }

        } catch (NumberFormatException e) {
            sendError(response, redirectUrl, "ID de réservation invalide.");
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, redirectUrl, "Erreur inattendue lors de la suppression.");
        }
    }


    private void sendError(HttpServletResponse response, String redirectUrl, String message) throws IOException {
        String encodedMsg = URLEncoder.encode(message, StandardCharsets.UTF_8.toString());
        response.sendRedirect(redirectUrl + "?error=true&msg=" + encodedMsg);
    }

    private void sendSuccess(HttpServletResponse response, String redirectUrl, String message) throws IOException {
        String encodedMsg = URLEncoder.encode(message, StandardCharsets.UTF_8.toString());
        response.sendRedirect(redirectUrl + "?success=true&msg=" + encodedMsg);
    }
}