package com.projetjee.web.admin;

import com.projetjee.dao.ReservationDAO;
import com.projetjee.dao.UserDAO;
import com.projetjee.model.Reservation;
import com.projetjee.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/admin/reservations/liste_reservations")
public class ListeReservationsServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin/reservations/liste_reservations";

        if ("delete".equals(action)) {
            handleDeleteReservation(request, response, redirectUrl);
            return;
        }

        String dateParam = request.getParameter("date");
        String formateurParam = request.getParameter("formateurId");

        Date selectedDate = null;
        String todayString = LocalDate.now().toString();

        if (dateParam != null && !dateParam.isEmpty()) {
            selectedDate = Date.valueOf(dateParam);
        } else {
            selectedDate = Date.valueOf(todayString);
            dateParam = todayString;
        }

        int formateurId = -1;
        if (formateurParam != null && !formateurParam.isEmpty() && !"-1".equals(formateurParam)) {
            try {
                formateurId = Integer.parseInt(formateurParam);
            } catch (NumberFormatException e) {
                formateurId = -1;
            }
        }

        List<User> formateurs = userDAO.getUsersByRole("FORMATEUR");
        List<Reservation> reservations = reservationDAO.getFilteredReservations(selectedDate, formateurId);

        request.setAttribute("formateurs", formateurs);
        request.setAttribute("reservations", reservations);
        request.setAttribute("selectedDate", dateParam);
        request.setAttribute("selectedFormateurId", formateurId);

        request.getRequestDispatcher("/admin/reservations/liste_reservations.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

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