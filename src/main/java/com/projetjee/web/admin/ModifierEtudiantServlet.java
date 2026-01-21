package com.projetjee.web.admin;

import com.projetjee.dao.FormationDAO;
import com.projetjee.dao.InscriptionDAO;
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

@WebServlet("/admin/etudiants/modifier")
public class ModifierEtudiantServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/etudiants/liste_etudiants");
            return;
        }

        int studentId = Integer.parseInt(idParam);

        UserDAO userDAO = new UserDAO();
        User student = userDAO.getUserById(studentId);

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/admin/etudiants/liste_etudiants");
            return;
        }

        InscriptionDAO inscriptionDAO = new InscriptionDAO();
        int currentFormationId = inscriptionDAO.getFormationIdByStudent(studentId);

        FormationDAO formationDAO = new FormationDAO();
        List<Formation> formations = formationDAO.getAllFormations();

        request.setAttribute("student", student);
        request.setAttribute("currentFormationId", currentFormationId);
        request.setAttribute("formations", formations);

        request.getRequestDispatcher("/admin/etudiants/modifier_etudiant.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int studentId = Integer.parseInt(request.getParameter("id"));
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            int formationId = Integer.parseInt(request.getParameter("formationId"));

            UserDAO userDAO = new UserDAO();
            User student = userDAO.getUserById(studentId);

            if (student == null) {
                response.sendRedirect(request.getContextPath() + "/admin/etudiants/liste_etudiants?error=true&msg=Étudiant+introuvable");
                return;
            }

            student.setFirstName(firstName);
            student.setLastName(lastName);
            student.setEmail(email);
            student.setPhoneNumber(phoneNumber);

            boolean updated = userDAO.updateUser(student);

            if (!updated) {
                response.sendRedirect(request.getContextPath() + "/admin/etudiants/liste_etudiants?error=true&msg=Erreur+mise+à+jour");
                return;
            }

            InscriptionDAO inscriptionDAO = new InscriptionDAO();
            inscriptionDAO.updateStudentFormation(studentId, formationId);

            String msg = "Étudiant a été modifié avec succès !";
            msg = URLEncoder.encode(msg, "UTF-8");
            response.sendRedirect(request.getContextPath()
                    + "/admin/etudiants/liste_etudiants?success=true&msg=" + msg);


        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/etudiants/liste_etudiants?error=true&msg=Erreur+modification");
        }
    }

}