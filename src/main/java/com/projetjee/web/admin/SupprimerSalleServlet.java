package com.projetjee.web.admin;

import com.projetjee.dao.RoomDAO;
import com.projetjee.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/admin/salles/supprimer")
public class SupprimerSalleServlet extends HttpServlet {

    private RoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");

        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);

                boolean success = roomDAO.deleteRoom(id);

                if (success) {
                    String msg = URLEncoder.encode("Salle supprimée avec succès !", StandardCharsets.UTF_8);
                    response.sendRedirect(request.getContextPath() + "/admin/salles/liste_salles?success=true&msg=" + msg);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/salles/liste_salles?error=DeleteFailed");
                }

            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/salles/liste_salles?error=InvalidId");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/salles/liste_salles?error=NoId");
        }
    }
}