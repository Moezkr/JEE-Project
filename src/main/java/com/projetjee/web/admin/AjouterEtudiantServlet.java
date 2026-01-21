package com.projetjee.web.admin;

import com.projetjee.dao.FormationDAO;
import com.projetjee.dao.InscriptionDAO;
import com.projetjee.dao.UserDAO;
import com.projetjee.model.Formation;
import com.projetjee.model.Inscription;
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

@WebServlet("/admin/etudiants/ajouter")
public class AjouterEtudiantServlet extends HttpServlet {

    private UserDAO userDAO;
    private InscriptionDAO inscriptionDAO;
    private FormationDAO formationDAO;

    private static final String ERROR_REDIRECT_URL = "/admin/etudiants/ajouter";
    private static final String SUCCESS_REDIRECT_URL = "/admin/etudiants/liste_etudiants";


    @Override
    public void init() {
        userDAO = new UserDAO();
        inscriptionDAO = new InscriptionDAO();
        formationDAO = new FormationDAO();
    }

    private void sendRedirectWithMessage(HttpServletResponse response, HttpServletRequest request, String path, String type, String message) throws IOException {
        String encodedMsg = URLEncoder.encode(message, StandardCharsets.UTF_8.toString());
        String redirectUrl = request.getContextPath() + path + "?" + type + "=true&msg=" + encodedMsg;
        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Formation> formations = formationDAO.getAllFormations();
        request.setAttribute("formations", formations);

        request.getRequestDispatcher("/admin/etudiants/ajouter_etudiant.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String formationIdParam = request.getParameter("formationId");


        if (firstName == null || lastName == null || email == null || phoneNumber == null
                || formationIdParam == null || password == null
                || firstName.isEmpty() || lastName.isEmpty() || email.isEmpty()
                || phoneNumber.isEmpty() || formationIdParam.isEmpty() || password.isEmpty()) {
            sendRedirectWithMessage(response, request, ERROR_REDIRECT_URL, "error", "Tous les champs sont obligatoires.");
            return;
        }

        if (!email.trim().toLowerCase().endsWith("@gmail.com")) {
            sendRedirectWithMessage(response, request, ERROR_REDIRECT_URL, "error", "L'email doit être une adresse Gmail valide.");
            return;
        }

        if (!phoneNumber.matches("^\\d{8}$")) {
            sendRedirectWithMessage(response, request, ERROR_REDIRECT_URL, "error", "Le numéro de téléphone doit contenir exactement 8 chiffres.");
            return;
        }

        if (userDAO.isEmailOrPhoneTaken(email, phoneNumber)) {
            sendRedirectWithMessage(response, request, ERROR_REDIRECT_URL, "error", "L'email ou le téléphone est déjà utilisé.");
            return;
        }

        try {
            User student = new User();
            student.setFirstName(firstName);
            student.setLastName(lastName);
            student.setEmail(email);
            student.setPhoneNumber(phoneNumber);
            student.setRole("STUDENT");

            String hashedPassword = SecurityUtils.hashPassword(password);
            student.setPassword(hashedPassword);


            boolean userCreated = userDAO.addUser(student);
            int studentId = student.getId();

            if (userCreated && studentId != 0) {

                Inscription inscription = new Inscription();
                inscription.setEtudiantId(studentId);
                inscription.setFormationId(Integer.parseInt(formationIdParam));

                if (inscriptionDAO.addInscription(inscription)) {
                    sendRedirectWithMessage(response, request, SUCCESS_REDIRECT_URL, "success", "Étudiant inscrit avec succès !");
                } else {
                    sendRedirectWithMessage(response, request, ERROR_REDIRECT_URL, "error", "Utilisateur créé, mais échec de l'inscription à la formation.");
                }
            } else {
                sendRedirectWithMessage(response, request, ERROR_REDIRECT_URL, "error", "Erreur inconnue lors de la création de l'utilisateur.");
            }
        } catch (NumberFormatException e) {
            sendRedirectWithMessage(response, request, ERROR_REDIRECT_URL, "error", "ID de formation invalide.");
        } catch (Exception e) {
            e.printStackTrace();
            sendRedirectWithMessage(response, request, ERROR_REDIRECT_URL, "error", "Erreur inattendue du serveur lors de l'enregistrement.");
        }
    }
}