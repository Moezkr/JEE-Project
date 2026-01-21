<%@ page import="com.projetjee.model.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<User> displayedFormateurs = (List<User>) request.getAttribute("displayedFormateurs");
    int currentPage = (int) request.getAttribute("currentPage");
    int totalPages = (int) request.getAttribute("totalPages");
%>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="utf-8">
    <title>FormaPRO - Liste des Formateurs</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">


    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">


    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">


    <link href="../../css/admin_dashboard.css" rel="stylesheet">

    <style>
        .btn-action { width: 35px; height: 35px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; color: white; margin: 0 5px; cursor: pointer; transition: 0.3s; border: none; }
        .btn-edit { background-color: #3b82f6; }
        .btn-edit:hover { background-color: #2563eb; }
        .btn-delete { background-color: #ef4444; }
        .btn-delete:hover { background-color: #dc2626; }

        .pagination { display: flex; justify-content: center; margin-top: 20px; gap: 5px; }
        .page-link { padding: 8px 12px; border: 1px solid #ddd; color: #112958; border-radius: 4px; text-decoration: none; }
        .page-link.active { background-color: #112958; color: white; border-color: #112958; }

        .toast-notification { position: fixed; bottom: 20px; right: 20px; z-index: 9999; background-color: #d1fae5; color: #065f46; border-left: 5px solid #10b981; padding: 15px 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; justify-content: space-between; min-width: 300px; animation: slideInRight 0.5s ease-out forwards; }
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>

<body>

<jsp:include page="../sidebar.jsp" />

<div class="main-content">
    <jsp:include page="../header.jsp">
        <jsp:param name="pageTitle" value="Gestion des Formateurs" />
    </jsp:include>

    <main>

        <%
            String success = request.getParameter("success");
            String msg = request.getParameter("msg");
            if ("true".equals(success)) {
        %>
        <div id="toastSuccess" class="toast-notification">
            <div style="display:flex; align-items:center;">
                <i class="fa fa-check-circle mr-3" style="font-size: 1.2rem;"></i>
                <span><%= (msg != null) ? java.net.URLDecoder.decode(msg, "UTF-8") : "Opération réussie !" %></span>
            </div>
            <span style="cursor:pointer; margin-left:20px; font-weight:bold; font-size:1.2rem;" onclick="this.parentElement.style.display='none'">&times;</span>
        </div>
        <script>
            setTimeout(function() {
                var toast = document.getElementById("toastSuccess");
                if(toast) { toast.style.transition = "opacity 0.5s ease"; toast.style.opacity = "0"; setTimeout(function(){ toast.style.display = "none"; }, 500); }
            }, 4000);
        </script>
        <% } %>

        <div class="card">
            <div class="card-header">
                <h3>Liste des formateurs</h3>
                <a href="<%= request.getContextPath() %>/admin/formateurs/ajouter" class="btn"><i class="fa fa-plus"></i> Ajouter</a>
            </div>
            <div class="card-body">
                <table width="100%">
                    <thead>
                    <tr>
                        <td>Formateur</td>
                        <td>Email</td>
                        <td>Téléphone</td>
                        <td style="text-align: right;">Actions</td>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (displayedFormateurs.isEmpty()) { %>
                    <tr><td colspan="4" style="text-align:center;">Aucun formateur trouvé.</td></tr>
                    <% } else {
                        for (User f : displayedFormateurs) { %>
                    <tr>
                        <td>
                            <div class="student-flex">
                                <img src="https://ui-avatars.com/api/?name=<%= f.getFullName().replace(" ", "+") %>&background=random" class="student-img">
                                <div>
                                    <span style="display:block; color:#1e293b; font-weight:600;"><%= f.getFullName() %></span>

                                </div>
                            </div>
                        </td>
                        <td><%= f.getEmail() %></td>
                        <td><%= (f.getPhoneNumber() != null) ? f.getPhoneNumber() : "N/A" %></td>
                        <td style="text-align: right;">
                            <a href="<%= request.getContextPath() %>/admin/formateurs/modifier?id=<%= f.getId() %>" class="btn-action btn-edit">
                                <i class="fa fa-pen"></i>
                            </a>
                            <button onclick="confirmDelete(<%= f.getId() %>, 'FORMATEUR')" class="btn-action btn-delete">
                                <i class="fa fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>

                <% if (totalPages > 1) { %>
                <div class="pagination">
                    <% if (currentPage > 1) { %><a href="?page=<%= currentPage - 1 %>" class="page-link">&laquo;</a><% } %>
                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="?page=<%= i %>" class="page-link <%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
                    <% } %>
                    <% if (currentPage < totalPages) { %><a href="?page=<%= currentPage + 1 %>" class="page-link">&raquo;</a><% } %>
                </div>
                <% } %>
            </div>
        </div>
    </main>
</div>


<div id="deleteModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fa fa-exclamation-triangle" style="color:#ef4444;"></i> Confirmation</h3>
        </div>
        <div class="modal-body"><p>Êtes-vous sûr de vouloir supprimer ce formateur ?</p></div>
        <div class="modal-footer">
            <button class="btn-modal btn-cancel" onclick="closeDeleteModal()">Annuler</button>
            <a href="#" id="confirmDeleteBtn" class="btn-modal btn-confirm">Supprimer</a>
        </div>
    </div>
</div>

<script>
    function confirmDelete(userId, role) {
        var modal = document.getElementById('deleteModal');
        document.getElementById('confirmDeleteBtn').href = "<%= request.getContextPath() %>/admin/utilisateurs/supprimer?id=" + userId + "&role=" + role;
        modal.style.display = 'flex';
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').style.display = 'none';
    }

    window.onclick = function(e) {
        if (e.target == document.getElementById('deleteModal')) closeDeleteModal();
    }
</script>

</body>
</html>
