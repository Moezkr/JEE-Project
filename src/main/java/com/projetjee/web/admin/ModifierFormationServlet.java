package com.projetjee.web.admin;

import com.projetjee.dao.FormationDAO;
import com.projetjee.dao.ProgrammeDAO;
import com.projetjee.model.Formation;
import com.projetjee.model.Programme;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;

@WebServlet("/admin/formations/modifier")
public class ModifierFormationServlet extends HttpServlet {

    private FormationDAO formationDAO = new FormationDAO();
    private ProgrammeDAO programmeDAO = new ProgrammeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("liste_formations.jsp");
            return;
        }

        int formationId = Integer.parseInt(idStr);
        Formation formation = formationDAO.getFormationById(formationId);

        if (formation == null) {
            response.sendRedirect("liste_formations.jsp");
            return;
        }

        request.setAttribute("formation", formation);
        request.setAttribute("modules", programmeDAO.getProgrammeByFormationId(formationId));

        request.getRequestDispatcher("/admin/formations/modifier_formation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int formationId = Integer.parseInt(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");
        BigDecimal prix = BigDecimal.valueOf(Double.parseDouble(request.getParameter("prix")));
        int duree = Integer.parseInt(request.getParameter("duree"));

        Formation formation = new Formation();
        formation.setId(formationId);
        formation.setNom(nom);
        formation.setDescription(description);
        formation.setPrix(prix);
        formation.setDureeMois(duree);

        formationDAO.updateFormation(formation);

        String[] moduleTitles = request.getParameterValues("moduleTitles");
        String[] moduleDetails = request.getParameterValues("moduleDetails");

        programmeDAO.deleteModulesByFormationId(formationId);

        if (moduleTitles != null && moduleDetails != null) {
            for (int i = 0; i < moduleTitles.length; i++) {
                Programme p = new Programme();
                p.setFormationId(formationId);
                p.setTitreModule(moduleTitles[i]);
                p.setDetails(moduleDetails[i]);
                p.setOrdre(i + 1);

                programmeDAO.addProgramme(p);
            }
        }

        String msg = URLEncoder.encode("Formation modifiée avec succès !", "UTF-8");
        response.sendRedirect(request.getContextPath()
                + "/admin/formations/liste_formations?success=true&msg=" + msg);
    }
}