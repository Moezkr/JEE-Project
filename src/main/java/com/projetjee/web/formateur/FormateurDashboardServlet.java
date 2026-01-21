package com.projetjee.web.formateur;

import com.projetjee.dao.UserDAO;
import com.projetjee.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/formateur/dashboard")
public class FormateurDashboardServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"FORMATEUR".equals(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }

        int trainerId = user.getId();

        int myFormationsCount = userDAO.countFormationsByTrainer(trainerId);
        int hoursToday = userDAO.countTodayHoursByTrainer(trainerId);
        int reservationsToday = userDAO.countTodayReservations(trainerId);

        request.setAttribute("myFormationsCount", myFormationsCount);
        request.setAttribute("hoursToday", hoursToday);
        request.setAttribute("reservationsToday", reservationsToday);

        request.getRequestDispatcher("/formateur/dashboard.jsp").forward(request, response);
    }
}