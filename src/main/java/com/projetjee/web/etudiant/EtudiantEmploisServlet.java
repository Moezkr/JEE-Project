package com.projetjee.web.etudiant;

import com.projetjee.dao.ReservationDAO;
import com.projetjee.model.Reservation;
import com.projetjee.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/etudiant/emplois")
public class EtudiantEmploisServlet extends HttpServlet {

    private ReservationDAO reservationDAO;

    @Override
    public void init() {
        reservationDAO = new ReservationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"STUDENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int etudiantId = user.getId();

        List<Reservation> futureSessions = reservationDAO.getFutureSessionsByEtudiant(etudiantId);

        request.setAttribute("futureSessions", futureSessions);

        request.getRequestDispatcher("/etudiant/emplois/emplois.jsp").forward(request, response);
    }
}