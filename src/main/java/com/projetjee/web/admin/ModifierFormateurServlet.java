package com.projetjee.web.admin;

import com.projetjee.dao.FormationDAO;
import com.projetjee.dao.UserDAO;
import com.projetjee.model.Formation;
import com.projetjee.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet("/admin/formateurs/modifier")
public class ModifierFormateurServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private FormationDAO formationDAO = new FormationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/formateurs/liste_formateurs");
            return;
        }

        int formateurId = Integer.parseInt(idParam);

        User formateur = userDAO.getUserById(formateurId);

        if (formateur == null) {
            response.sendRedirect(request.getContextPath() + "/admin/formateurs/liste_formateurs");
            return;
        }

        List<Formation> allFormations = formationDAO.getAllFormations();

        List<Integer> assignedFormationIds = userDAO.getFormateurFormationIds(formateurId);


        request.setAttribute("formateur", formateur);
        request.setAttribute("allFormations", allFormations);
        request.setAttribute("assignedFormationIds", assignedFormationIds);

        request.getRequestDispatcher("/admin/formateurs/modifier_formateur.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");

        String[] newFormationIds = request.getParameterValues("formationIds");


        if (userDAO.isEmailOrPhoneTaken(email, phoneNumber, id)) {
            String error = URLEncoder.encode("DuplicateInfo", "UTF-8");
            response.sendRedirect(request.getContextPath()
                    + "/admin/formateurs/modifier?id=" + id + "&error=" + error);
            return;
        }

        User formateur = new User();
        formateur.setId(id);
        formateur.setFirstName(firstName);
        formateur.setLastName(lastName);
        formateur.setEmail(email);
        formateur.setPhoneNumber(phoneNumber);

        boolean updated = userDAO.updateUser(formateur);

        userDAO.deleteFormateurFormations(id);

        if (newFormationIds != null && newFormationIds.length > 0) {
            userDAO.addFormateurFormations(id, newFormationIds);
        }


        String msg = URLEncoder.encode("Formateur a été modifié avec succès !", "UTF-8");
        response.sendRedirect(request.getContextPath()
                + "/admin/formateurs/liste_formateurs?success=true&msg=" + msg);
    }
}