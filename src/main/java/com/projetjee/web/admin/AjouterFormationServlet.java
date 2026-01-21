package com.projetjee.web.admin;

import com.projetjee.dao.FormationDAO;
import com.projetjee.dao.ProgrammeDAO;
import com.projetjee.model.Formation;
import com.projetjee.model.Programme;
import com.projetjee.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/admin/formations/ajouter")
public class AjouterFormationServlet extends HttpServlet {

    private FormationDAO formationDAO = new FormationDAO();
    private ProgrammeDAO programmeDAO = new ProgrammeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/admin/formations/ajouter_formation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String nom = request.getParameter("nom");
        String description = request.getParameter("description");
        String prixStr = request.getParameter("prix");
        String dureeStr = request.getParameter("duree");

        String[] moduleTitles = request.getParameterValues("moduleTitles");
        String[] moduleDetails = request.getParameterValues("moduleDetails");

        if (nom == null || prixStr == null || dureeStr == null) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/formations/ajouter_formation.jsp?error=MissingFields");
            return;
        }

        try {
            BigDecimal prix = new BigDecimal(prixStr);
            int duree = Integer.parseInt(dureeStr);

            Formation f = new Formation();
            f.setNom(nom);
            f.setDescription(description);
            f.setPrix(prix);
            f.setDureeMois(duree);

            formationDAO.addFormation(f);

            int formationId = formationDAO.getLastInsertedId();

            if (moduleTitles != null && formationId != -1) {
                for (int i = 0; i < moduleTitles.length; i++) {
                    Programme p = new Programme();
                    p.setFormationId(formationId);
                    p.setTitreModule(moduleTitles[i]);
                    p.setDetails(moduleDetails[i]);
                    p.setOrdre(i + 1);

                    programmeDAO.addProgramme(p);
                }
            }


            String msg = URLEncoder.encode("Formation ajoutée avec succès !", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath()
                    + "/admin/formations/liste_formations?success=true&msg=" + msg);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/formations/ajouter_formation.jsp?error=InvalidNumber");
        }
    }
}