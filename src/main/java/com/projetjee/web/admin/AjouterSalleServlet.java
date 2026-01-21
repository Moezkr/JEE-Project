package com.projetjee.web.admin;

import com.projetjee.model.User;
import com.projetjee.model.Room;
import com.projetjee.dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/admin/salles/ajouter")
public class AjouterSalleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/admin/salles/ajouter_salle.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String name = request.getParameter("name");
        String capacityStr = request.getParameter("capacity");
        String type = request.getParameter("type");


        String errorRedirect = request.getContextPath() + "/admin/salles/ajouter";

        if (name == null || name.isEmpty() || capacityStr == null || type == null || type.isEmpty()) {
            response.sendRedirect(errorRedirect + "?error=MissingFields");
            return;
        }

        try {
            int capacity = Integer.parseInt(capacityStr);

            Room room = new Room();
            room.setName(name);
            room.setCapacity(capacity);
            room.setType(type);

            RoomDAO roomDAO = new RoomDAO();
            roomDAO.addRoom(room);

            String msg = java.net.URLEncoder.encode("Salle ajoutée avec succès !", java.nio.charset.StandardCharsets.UTF_8);

            response.sendRedirect(request.getContextPath() + "/admin/salles/liste_salles?success=true&msg=" + msg);

        } catch (NumberFormatException e) {
            response.sendRedirect(errorRedirect + "?error=InvalidCapacity");
        }
    }

}