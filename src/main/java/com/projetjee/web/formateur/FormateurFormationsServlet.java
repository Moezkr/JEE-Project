package com.projetjee.web.formateur;

import com.projetjee.dao.FormationDAO;
import com.projetjee.model.Formation;
import com.projetjee.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/formateur/formations")
public class FormateurFormationsServlet extends HttpServlet {

    private FormationDAO formationDAO;

    @Override
    public void init() {
        formationDAO = new FormationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"FORMATEUR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Formation> myFormations = formationDAO.getFormationsByFormateur(user.getId());
        request.setAttribute("myFormations", myFormations);

        request.getRequestDispatcher("/formateur/formations/liste_formations.jsp").forward(request, response);
    }
}