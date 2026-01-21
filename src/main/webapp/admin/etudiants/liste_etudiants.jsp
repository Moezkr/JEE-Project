<%@ page import="com.projetjee.model.Inscription" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Inscription> inscriptions = (List<Inscription>) request.getAttribute("displayedInscriptions");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>FormaPRO - Liste des Étudiants</title>
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

        .badge { padding: 5px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; display: inline-block; }
        .badge-valide { background: #dcfce7; color: #166534; }
        .badge-attente { background: #fef9c3; color: #854d0e; }
        .badge-refuse { background: #fee2e2; color: #991b1b; }

        .toast-notification {
            position: fixed; bottom: 20px; right: 20px; z-index: 9999;
            background-color: #d1fae5; color: #065f46; border-left: 5px solid #10b981;
            padding: 15px 25px; border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            display: flex; align-items: center; justify-content: space-between;
            min-width: 300px; animation: slideInRight 0.5s ease-out forwards;
        }

        @keyframes slideInRight { 
            from { transform: translateX(100%); opacity: 0; } 
            to { transform: translateX(0); opacity: 1; } 
        }
    </style>
</head>

<body>

<jsp:include page="../sidebar.jsp" />

<div class="main-content">
    <jsp:include page="../header.jsp">
        <jsp:param name="pageTitle" value="Gestion des Étudiants" />
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
                <h3>Liste des Étudiants</h3>
                <a href="<%= request.getContextPath() %>/admin/etudiants/ajouter" class="btn">
                    <i class="fa fa-plus"></i> Inscrire
                </a>
            </div>

            <div class="card-body">
                <table width="100%">
                    <thead>
                        <tr>
                            <td>Étudiant</td>
                            <td>Email</td>
                            <td>Formation</td>
                            <td>Statut</td>
                            <td style="text-align: right;">Actions</td>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (inscriptions == null || inscriptions.isEmpty()) { %>
                            <tr>
                                <td colspan="5" style="text-align:center; padding: 20px;">Aucun étudiant inscrit pour le moment.</td>
                            </tr>
                        <% } else {
                            for (Inscription ins : inscriptions) { %>
                            <tr>
                                <td>
                                    <div class="student-flex">
                                        <img src="https://ui-avatars.com/api/?name=<%= ins.getStudentName().replace(" ", "+") %>&background=random" class="student-img">
                                        <div>
                                            <span style="display:block; color:#1e293b; font-weight:600;"><%= ins.getStudentName() %></span>
                                        </div>
                                    </div>
                                </td>
                                <td><%= ins.getStudentEmail() %></td>
                                <td><%= ins.getFormationName() %></td>
                                <td><span class="badge badge-valide">Inscrit</span></td>
                                <td style="text-align: right;">
                                    <a href="<%= request.getContextPath() %>/admin/etudiants/modifier?id=<%= ins.getEtudiantId() %>" class="btn-action btn-edit" title="Modifier">
                                        <i class="fa fa-pen"></i>
                                    </a>
                                    <button onclick="confirmDelete(<%= ins.getEtudiantId() %>)" class="btn-action btn-delete">
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
        <div class="modal-body"><p>Voulez-vous vraiment supprimer cet étudiant ?</p></div>
        <div class="modal-footer">
            <button class="btn-modal btn-cancel" onclick="closeDeleteModal()">Annuler</button>
            <a href="#" id="confirmDeleteBtn" class="btn-modal btn-confirm">Supprimer</a>
        </div>
    </div>
</div>

<script>
    function confirmDelete(id) {
        document.getElementById('confirmDeleteBtn').href = "<%= request.getContextPath() %>/admin/utilisateurs/supprimer?id=" + id + "&role=STUDENT";
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