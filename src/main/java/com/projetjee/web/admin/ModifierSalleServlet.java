package com.projetjee.web.admin;


import com.projetjee.dao.RoomDAO;
import com.projetjee.model.Room;
import com.projetjee.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.io.IOException;

@WebServlet("/modifierSalle")
public class ModifierSalleServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/salles/liste_salles");
            return;
        }

        int roomId;
        try {
            roomId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/salles/liste_salles");
            return;
        }

        RoomDAO roomDAO = new RoomDAO();
        Room room = roomDAO.getRoomById(roomId);

        if (room == null) {
            response.sendRedirect(request.getContextPath() + "/admin/salles/liste_salles");
            return;
        }

        request.setAttribute("room", room);
        request.getRequestDispatcher("/admin/salles/modifier_salle.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        String type = request.getParameter("type");

        Room room = new Room(id, name, capacity, type);
        RoomDAO roomDAO = new RoomDAO();
        boolean updated = roomDAO.updateRoom(room);

        if (updated) {
            String msg = URLEncoder.encode("Salle modifiée avec succès !", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/admin/salles/liste_salles?success=true&msg=" + msg);
        } else {
            String msg = URLEncoder.encode("Échec de la modification de la salle.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/admin/salles/liste_salles?error=true&msg=" + msg);
        }
    }
}