<%@ page import="com.projetjee.model.Room" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>FormaPRO - Liste des Salles</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="../../css/admin_dashboard.css" rel="stylesheet">

    <style>
        .btn-action { width: 35px; height: 35px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; color: white; margin: 0 5px; transition: 0.3s; border: none; cursor: pointer; text-decoration: none; }
        .btn-edit { background-color: #3b82f6; }
        .btn-edit:hover { background-color: #2563eb; }
        .btn-delete { background-color: #ef4444; }
        .btn-delete:hover { background-color: #dc2626; }

        .badge { padding: 5px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .badge-info { background: #e0f2fe; color: #0369a1; }
        .badge-capacity { background: #fef9c3; color: #854d0e; }

        .toast-notification {
            position: fixed; bottom: 20px; right: 20px; z-index: 9999;
            background-color: #d1fae5; color: #065f46; border-left: 5px solid #10b981;
            padding: 15px 25px; border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            display: flex; align-items: center; justify-content: space-between;
            min-width: 300px; animation: slideInRight 0.5s ease-out forwards;
        }

        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>

<body>

<jsp:include page="../sidebar.jsp" />

<div class="main-content">
    <jsp:include page="../header.jsp">
        <jsp:param name="pageTitle" value="Gestion des Salles" />
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
                <span style="cursor:pointer; margin-left:20px; font-weight:bold;" onclick="this.parentElement.style.display='none'">&times;</span>
            </div>

            <script>
                setTimeout(function() {
                    var toast = document.getElementById("toastSuccess");
                    if(toast) {
                        toast.style.transition = "opacity 0.5s ease";
                        toast.style.opacity = "0";
                        setTimeout(function(){ toast.style.display = "none"; }, 500);
                    }
                }, 4000);
            </script>
        <% } %>

        <div class="card">
            <div class="card-header">
                <h3>Liste des Salles</h3>
                <a href="/admin/salles/ajouter" class="btn"><i class="fa fa-plus"></i> Ajouter Salle</a>
            </div>

            <div class="card-body">
                <table width="100%">
                    <thead>
                        <tr>
                            <td>Nom de la Salle</td>
                            <td>Type</td>
                            <td>Capacité</td>
                            <td style="text-align: right;">Actions</td>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (rooms == null || rooms.isEmpty()) { %>
                            <tr>
                                <td colspan="4" style="text-align:center; padding:20px;">Aucune salle enregistrée.</td>
                            </tr>
                        <% } else {
                            for (Room r : rooms) { %>
                            <tr>
                                <td>
                                    <div class="student-flex">
                                        <div style="width:40px; height:40px; background:#e0e7ff; color:#3730a3; border-radius:8px; display:flex; align-items:center; justify-content:center; font-weight:bold; margin-right:10px;">
                                            <i class="fa fa-door-open"></i>
                                        </div>
                                        <div>
                                            <span style="display:block; color:#1e293b; font-weight:600;"><%= r.getName() %></span>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge badge-info"><%= r.getType() %></span></td>
                                <td><span class="badge badge-capacity"><%= r.getCapacity() %> places</span></td>
                                <td style="text-align: right;">
                                    <a href="../../modifierSalle?id=<%= r.getId() %>" class="btn-action btn-edit" title="Modifier">
                                        <i class="fa fa-pen"></i>
                                    </a>
                                    <button onclick="confirmDelete(<%= r.getId() %>)" class="btn-action btn-delete" title="Supprimer">
                                        <i class="fa fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        <%  }
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<div id="deleteModal" class="modal">
    <div class="modal-content">
        <div class="modal-header"><h3>Confirmation</h3></div>
        <div class="modal-body"><p>Voulez-vous vraiment supprimer cette salle ?</p></div>
        <div class="modal-footer">
            <button class="btn-modal btn-cancel" onclick="closeDeleteModal()">Annuler</button>
            <a href="#" id="confirmDeleteBtn" class="btn-modal btn-confirm">Supprimer</a>
        </div>
    </div>
</div>

<script>
    function confirmDelete(id) {
        document.getElementById('confirmDeleteBtn').href = "<%= request.getContextPath() %>/admin/salles/supprimer?id=" + id;
        document.getElementById('deleteModal').style.display = 'flex';
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').style.display = 'none';
    }

    window.onclick = function(e) {
        if (e.target == document.getElementById('deleteModal')) {
            closeDeleteModal();
        }
    }
</script>

</body>
</html>