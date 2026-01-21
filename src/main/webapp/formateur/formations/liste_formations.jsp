<%@ page import="com.projetjee.model.Formation" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Formation> myFormations = (List<Formation>) request.getAttribute("myFormations");
%>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="utf-8">
    <title>FormaPRO - Mes Formations</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <link href="../../css/admin_dashboard.css" rel="stylesheet">
    <link href="../../css/formateur_dashboard.css" rel="stylesheet">

    <style>

        .btn-detail {
            background-color: #112958;
            color: white;
            padding: 8px 15px;
            border-radius: 6px;
            font-size: 0.9rem;
            text-decoration: none;
            transition: 0.3s;
        }
        .btn-detail:hover {
            background-color: #ff8c00;
            color: white;
        }
        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .badge-price { background: #fee2e2; color: #991b1b; }
        .badge-duration { background: #e0f2fe; color: #0369a1; }

        .student-flex {
            display: flex;
            align-items: center;
        }
    </style>
</head>

<body>

<div class="wrapper">

    <jsp:include page="../../formateur/sidebar.jsp" />

    <div class="main-content">

        <jsp:include page="../../formateur/header.jsp">
            <jsp:param name="pageTitle" value="Mes Formations" />
        </jsp:include>

        <main>
            <div class="card">
                <div class="card-header">
                    <h3>Formations Assignées</h3>
                </div>
                <div class="card-body">
                    <table width="100%">
                        <thead>
                        <tr>
                            <td>Formation</td>
                            <td>Prix</td>
                            <td>Durée</td>

                        </tr>
                        </thead>
                        <tbody>
                        <% if (myFormations.isEmpty()) { %>
                        <tr><td colspan="4" style="text-align:center; padding:30px; color:#666;">Vous n'êtes assigné à aucune formation pour le moment.</td></tr>
                        <% } else {
                            for (Formation f : myFormations) { %>
                        <tr>
                            <td>
                                <div class="student-flex">
                                    <div style="width:45px; height:45px; background:#f3e8ff; color:#6a0dad; border-radius:8px; display:flex; align-items:center; justify-content:center; font-size: 1.2rem; margin-right:15px;">
                                        <i class="fa fa-book"></i>
                                    </div>
                                    <div>
                                        <span style="display:block; color:#1e293b; font-weight:700; font-size: 1rem;"><%= f.getNom() %></span>
                                        <small style="color:#64748b;">
                                            <%= (f.getDescription() != null && f.getDescription().length() > 40) ? f.getDescription().substring(0, 40) + "..." : f.getDescription() %>
                                        </small>
                                    </div>
                                </div>
                            </td>
                            <td><span class="badge badge-price"><%= f.getPrix() %> TND</span></td>
                            <td><span class="badge badge-duration"><i class="fa fa-clock"></i> <%= f.getDureeMois() %> Mois</span></td>

                        </tr>
                        <%  }
                        } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

<div id="logoutModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fa fa-sign-out-alt"></i> Déconnexion</h3>
        </div>
        <div class="modal-body">
            <p>Êtes-vous sûr de vouloir vous déconnecter ?</p>
        </div>
        <div class="modal-footer">
            <button class="btn-modal btn-cancel" onclick="closeLogoutModal()">Annuler</button>
            <a href="../../logout" class="btn-modal btn-confirm">Déconnexion</a>
        </div>
    </div>
</div>

<script>
    function showLogoutModal() {
        document.getElementById('logoutModal').style.display = 'flex';
    }

    function closeLogoutModal() {
        document.getElementById('logoutModal').style.display = 'none';
    }

    window.onclick = function(event) {
        var modal = document.getElementById('logoutModal');
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>

</body>
</html>