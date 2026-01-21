<%@ page import="com.projetjee.model.Room" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Room room = (Room) request.getAttribute("room");
    if (room == null) {
        response.sendRedirect(request.getContextPath() + "/admin/salles/liste_salles");
        return;
    }

    String[] roomTypes = {
            "Salle de Cours",
            "Salle Informatique",
            "Salle de Conférence",
            "Salle de Réunion",
            "Atelier"
    };
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>FormaPRO - Modifier Salle</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="../../css/admin_dashboard.css" rel="stylesheet">

    <style>
        .form-container { max-width: 600px; margin: 0 auto; }
        .form-group label { font-weight: 600; color: #1e293b; margin-bottom: 8px; display: block; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 20px; }
        .form-control:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
        .btn-submit { background-color: #3b82f6; color: white; padding: 12px 30px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s; width: 100%; }
        .btn-submit:hover { background-color: #2563eb; }
        .btn-back { color: #64748b; text-decoration: none; margin-right: 15px; font-weight: 600; }

        .toast-notification { position: fixed; bottom: 20px; right: 20px; z-index: 9999; padding: 15px 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; justify-content: space-between; min-width: 300px; animation: slideInRight 0.5s ease-out forwards; }
        .alert-error { background-color: #fee2e2; color: #991b1b; border-left: 5px solid #ef4444; }
        
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>

<body>

<jsp:include page="../sidebar.jsp" />

<div class="main-content">
    <jsp:include page="../header.jsp">
        <jsp:param name="pageTitle" value="Modifier une Salle" />
    </jsp:include>

    <main>
        <% String error = request.getParameter("error"); if(error != null) { %>
            <div id="toastError" class="toast-notification alert-error">
                <span>
                    <% if ("InvalidCapacity".equals(error)) { %>
                        <strong>Erreur :</strong> La capacité doit être valide.
                    <% } else if ("UpdateFailed".equals(error)) { %>
                        <strong>Erreur :</strong> Échec de la mise à jour.
                    <% } else { %>
                        Une erreur inconnue est survenue.
                    <% } %>
                </span>
                <span onclick="this.parentElement.style.display='none'" style="cursor:pointer;">&times;</span>
            </div>
            <script>setTimeout(function(){ document.getElementById("toastError").style.display="none"; }, 5000);</script>
        <% } %>

        <div class="card form-container">
            <div class="card-header">
                <h3>Modifier Salle: <%= room.getName() %></h3>
                <a href="liste_salles.jsp" class="btn-back"><i class="fa fa-arrow-left"></i> Retour</a>
            </div>

            <div class="card-body">
                <form id="editRoomForm" action="<%=request.getContextPath()%>/modifierSalle" method="post">
                    <input type="hidden" name="id" value="<%= room.getId() %>">

                    <div class="form-group">
                        <label>Nom de la Salle</label>
                        <input type="text" name="name" class="form-control" value="<%= room.getName() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Capacité</label>
                        <input type="number" name="capacity" class="form-control" value="<%= room.getCapacity() %>" required min="1">
                    </div>

                    <div class="form-group">
                        <label>Type de Salle</label>
                        <select name="type" class="form-control" required>
                            <option value="" disabled>-- Choisir le type --</option>
                            <%
                                for (String type : roomTypes) {
                                    boolean isSelected = type.equals(room.getType());
                            %>
                                <option value="<%= type %>" <%= isSelected ? "selected" : "" %>>
                                    <%= type %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div style="margin-top: 20px;">
                        <button type="button" class="btn-submit" onclick="showConfirmModal()">
                            <i class="fa fa-save"></i> Enregistrer les modifications
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<div id="confirmModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fa fa-edit" style="color:#3b82f6;"></i> Confirmation</h3>
        </div>
        <div class="modal-body">
            <p>Voulez-vous vraiment modifier les informations de cette salle ?</p>
        </div>
        <div class="modal-footer">
            <button class="btn-modal btn-cancel" onclick="closeConfirmModal()">Annuler</button>
            <button class="btn-modal btn-confirm" onclick="submitForm()" style="background-color:#3b82f6;">Confirmer</button>
        </div>
    </div>
</div>

<script>
    function showConfirmModal() {
        var form = document.getElementById("editRoomForm");
        if (form.checkValidity()) {
            document.getElementById("confirmModal").style.display = "flex";
        } else {
            form.reportValidity();
        }
    }

    function closeConfirmModal() {
        document.getElementById("confirmModal").style.display = "none";
    }

    function submitForm() {
        document.getElementById("editRoomForm").submit();
    }

    window.onclick = function(event) {
        var modal = document.getElementById('confirmModal');
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>

</body>
</html>