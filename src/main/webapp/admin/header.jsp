<%@ page import="com.projetjee.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    User headerUser = (User) session.getAttribute("user");


    String pageTitle = request.getParameter("pageTitle");
    if (pageTitle == null || pageTitle.isEmpty()) {
        pageTitle = "Dashboard";
    }
%>

<header>
    <h2>
        <%= pageTitle %>
    </h2>



    <div class="user-wrapper">

        <div class="profile">
            <% if (headerUser != null) { %>
            <div>

                <h4 style="font-size:0.9rem; color:#112958;"><%= headerUser.getFullName() %></h4>
                <small style="color:#666; font-size:0.8rem;"><%= headerUser.getRole() %></small>
            </div>

            <img src="https://ui-avatars.com/api/?name=<%= headerUser.getFullName().replace(" ", "+") %>&background=112958&color=fff" alt="Admin">
            <% } %>
        </div>
    </div>
</header>