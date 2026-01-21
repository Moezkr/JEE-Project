package com.projetjee.web.admin;

import com.projetjee.dao.FormationDAO;
import com.projetjee.dao.UserDAO;
import com.projetjee.model.Formation;
import com.projetjee.model.User;
import com.projetjee.util.SecurityUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/admin/formateurs/ajouter")
public class AjouterFormateurServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        FormationDAO formationDAO = new FormationDAO();
        List<Formation> formations = formationDAO.getAllFormations();
        request.setAttribute("formations", formations);

        request.getRequestDispatcher("/admin/formateurs/ajouter_formateur.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String[] formationIds = request.getParameterValues("formationIds");

        String errorPage = request.getContextPath() + "/admin/formateurs/ajouter.jsp";

        if (firstName == null || lastName == null || email == null ||
                phone == null || password == null) {
            response.sendRedirect(errorPage + "?error=MissingFields");
            return;
        }

        if (!email.toLowerCase().endsWith("@gmail.com")) {
            response.sendRedirect(errorPage + "?error=InvalidEmail");
            return;
        }

        if (!phone.matches("^\\d{8}$")) {
            response.sendRedirect(errorPage + "?error=InvalidPhone");
            return;
        }

        if (formationIds == null || formationIds.length == 0) {
            response.sendRedirect(errorPage + "?error=MissingFormations");
            return;
        }

        UserDAO userDAO = new UserDAO();
        if (userDAO.isEmailOrPhoneTaken(email, phone)) {
            response.sendRedirect(errorPage + "?error=DuplicateInfo");
            return;
        }


        String hashedPwd = SecurityUtils.hashPassword(password);
        User formateur = new User();
        formateur.setFirstName(firstName);
        formateur.setLastName(lastName);
        formateur.setEmail(email);
        formateur.setPhoneNumber(phone);
        formateur.setPassword(hashedPwd);
        formateur.setRole("FORMATEUR");

        boolean success = userDAO.addUser(formateur);
        if (!success) {
            response.sendRedirect(errorPage + "?error=UnknownError");
            return;
        }

        int formateurId = formateur.getId();

        boolean relationsSaved = userDAO.addFormateurFormations(formateurId, formationIds);
        if (!relationsSaved) {
            response.sendRedirect(errorPage + "?error=RelationsFailed");
            return;
        }


        String msg = URLEncoder.encode("Formateur ajouté avec succès !", StandardCharsets.UTF_8);

        response.sendRedirect(
                request.getContextPath() +
                        "/admin/formateurs/liste_formateurs?success=true&msg=" + msg
        );
    }
}