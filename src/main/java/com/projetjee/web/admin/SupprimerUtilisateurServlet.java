package com.projetjee.web.admin;

import com.projetjee.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/admin/utilisateurs/supprimer")
public class SupprimerUtilisateurServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String role = request.getParameter("role");

        if (idParam != null && role != null) {
            int userId = Integer.parseInt(idParam);
            boolean success = userDAO.deleteUser(userId);

            if (success) {
                String msg = "Utilisateur supprimé avec succès !";
                if ("FORMATEUR".equals(role)) msg = "Formateur a été supprimé avec succès !";
                if ("STUDENT".equals(role)) msg = "Étudiant a été supprimé avec succès !";

                String encodedMsg = URLEncoder.encode(msg, StandardCharsets.UTF_8);

                if ("FORMATEUR".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/admin/formateurs/liste_formateurs?success=true&msg=" + encodedMsg);
                } else if ("STUDENT".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/admin/etudiants/liste_etudiants?success=true&msg=" + encodedMsg);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/utilisateurs/liste?success=true&msg=" + encodedMsg);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=DeleteFailed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?error=InvalidRequest");
        }
    }
}