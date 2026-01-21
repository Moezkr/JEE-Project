package com.projetjee.web.formateur;

import com.projetjee.dao.ReservationDAO;
import com.projetjee.model.Reservation;
import com.projetjee.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/formateur/emplois")
public class FormateurEmploisServlet extends HttpServlet {

    private ReservationDAO reservationDAO;

    @Override
    public void init() {
        reservationDAO = new ReservationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"FORMATEUR".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }

        int formateurId = user.getId();

        LocalDate startDate = LocalDate.now();
        LocalDate endDate = startDate.plusDays(13);

        List<Reservation> reservations =
                reservationDAO.getWeeklyReservationsByFormateur(formateurId);

        request.setAttribute("reservations", reservations);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        request.getRequestDispatcher("/formateur/emplois/emplois.jsp").forward(request, response);
    }
}