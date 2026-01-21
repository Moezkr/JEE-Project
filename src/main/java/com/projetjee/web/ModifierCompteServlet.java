package com.projetjee.web;

import com.projetjee.dao.UserDAO;
import com.projetjee.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/compte/modifier")
public class ModifierCompteServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User sessionUser = (User) request.getSession().getAttribute("user");

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        System.out.println("=== DEBUG ROLE INFO ===");
        System.out.println("User role from DB: " + sessionUser.getRole());
        System.out.println("User role lowercase: " + sessionUser.getRole().toLowerCase());
       

        request.setAttribute("userToEdit", sessionUser);

        String role = sessionUser.getRole().toLowerCase();
        String jspPath;

        if ("formateur".equals(role)) {
            jspPath = "/formateur/modifier_compte.jsp";
        } else if ("student".equals(role)) {
            jspPath = "/etudiant/modifier_compte.jsp";
        } else {
            jspPath = "/admin/modifier_compte.jsp";
        }

        System.out.println("Forwarding to: " + jspPath);
        request.getRequestDispatcher(jspPath).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        User sessionUser = (User) request.getSession().getAttribute("user");

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");

        if (firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || phoneNumber.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/compte/modifier?error=Champs obligatoires manquants");
            return;
        }

        sessionUser.setFirstName(firstName);
        sessionUser.setLastName(lastName);
        sessionUser.setEmail(email);
        sessionUser.setPhoneNumber(phoneNumber);

        if (password != null && !password.isEmpty()) {
            sessionUser.setPassword(password);
        }

        boolean updated = userDAO.updateUser(sessionUser);

        if (updated) {
            String msg = URLEncoder.encode("Compte modifié avec succès !", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/compte/modifier?success=true&msg=" + msg);
        } else {
            response.sendRedirect(request.getContextPath() + "/compte/modifier?error=Erreur lors de la modification");
        }
    }
}