package com.projetjee.web.admin;

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

@WebServlet("/admin/formations/liste_formations")
public class ListeFormationsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        FormationDAO formationDAO = new FormationDAO();
        List<Formation> formations = formationDAO.getAllFormations();

        int pageSize = 8;
        String pageParam = request.getParameter("page");
        int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int totalItems = formations.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        int startIdx = (currentPage - 1) * pageSize;
        int endIdx = Math.min(startIdx + pageSize, totalItems);

        List<Formation> displayedFormations = (totalItems > 0) ? formations.subList(startIdx, endIdx) : List.of();

        request.setAttribute("displayedFormations", displayedFormations);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/admin/formations/liste_formations.jsp").forward(request, response);
    }
}