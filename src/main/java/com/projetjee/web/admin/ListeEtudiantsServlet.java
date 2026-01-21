package com.projetjee.web.admin;

import com.projetjee.dao.InscriptionDAO;
import com.projetjee.model.Inscription;
import com.projetjee.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/etudiants/liste_etudiants")
public class ListeEtudiantsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        InscriptionDAO inscriptionDAO = new InscriptionDAO();
        List<Inscription> inscriptions = inscriptionDAO.getAllStudentInscriptions();

        int pageSize = 8;
        String pageParam = request.getParameter("page");
        int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int totalUsers = inscriptions.size();
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        int startIdx = (currentPage - 1) * pageSize;
        int endIdx = Math.min(startIdx + pageSize, totalUsers);

        List<Inscription> displayedInscriptions = (totalUsers > 0) ? inscriptions.subList(startIdx, endIdx) : List.of();

        request.setAttribute("displayedInscriptions", displayedInscriptions);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/admin/etudiants/liste_etudiants.jsp").forward(request, response);
    }
}