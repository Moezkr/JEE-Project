<%@ page import="com.projetjee.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    User headerUser = (User) session.getAttribute("user");
    if (headerUser == null) {
        response.sendRedirect("../login.jsp");
        return;
    }


    String pageTitle = request.getParameter("pageTitle");
    if (pageTitle == null || pageTitle.isEmpty()) {
        pageTitle = "Tableau de bord";
    }
%>

<header style="border-bottom: 3px solid #ffc107;">
    <h2>
        <%= pageTitle %>
    </h2>



    <div class="user-wrapper">

        <div class="profile">
            <div>
                <h4 style="font-size:0.9rem; color:#112958;"><%= headerUser.getFullName() %></h4>
                <small style="color:#666; font-size:0.8rem;"><%= headerUser.getRole() %></small>
            </div>
            <img src="https://ui-avatars.com/api/?name=<%= headerUser.getFullName().replace(" ", "+") %>&background=10b981&color=fff" alt="Formateur">
        </div>
    </div>
</header>