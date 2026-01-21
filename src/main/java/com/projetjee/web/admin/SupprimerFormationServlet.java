package com.projetjee.web.admin;


import com.projetjee.dao.FormationDAO;
import com.projetjee.dao.ProgrammeDAO;
import com.projetjee.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/admin/formations/supprimer")
public class SupprimerFormationServlet extends HttpServlet {

    private FormationDAO formationDAO = new FormationDAO();
    private ProgrammeDAO programmeDAO = new ProgrammeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");

        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/formations/liste_formations?error=MissingId");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            programmeDAO.deleteModulesByFormationId(id);

            formationDAO.deleteFormation(id);

            String msg = URLEncoder.encode("Formation supprimée avec succès !", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath()
                    + "/admin/formations/liste_formations?success=true&msg=" + msg);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/formations/liste_formations?error=DeleteFailed");
        }
    }
}