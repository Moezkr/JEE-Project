package com.projetjee.web;

import com.projetjee.dao.FormationDAO;
import com.projetjee.dao.ProgrammeDAO;
import com.projetjee.model.Formation;
import com.projetjee.model.Programme;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/course")
public class CatalogueServlet extends HttpServlet {

    private FormationDAO formationDAO;
    private ProgrammeDAO programmeDAO;

    @Override
    public void init() {
        formationDAO = new FormationDAO();
        programmeDAO = new ProgrammeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<Formation> formations = formationDAO.getAllFormations();

        for (Formation formation : formations) {
            List<Programme> programmes = programmeDAO.getProgrammeByFormationId(formation.getId());
            formation.setProgrammes(programmes);
        }

        request.setAttribute("catalogueFormations", formations);

        request.getRequestDispatcher("/course.jsp").forward(request, response);
    }
}