<%@ page import="com.projetjee.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("../../login.jsp");
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
    <title>FormaPRO - Ajouter une Salle</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="../../css/admin_dashboard.css" rel="stylesheet">

    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.8.5/dist/dotlottie-wc.js" type="module"></script>

    <style>
        .form-container { max-width: 600px; margin: 0 auto; }
        .form-group label { font-weight: 600; color: #1e293b; margin-bottom: 8px; display: block; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 20px; }
        .form-control:focus { outline: none; border-color: #112958; box-shadow: 0 0 0 3px rgba(17, 41, 88, 0.1); }
        .btn-submit { background-color: #112958; color: white; padding: 12px 30px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s; width: 100%; }
        .btn-submit:hover { background-color: #ffc107; color: #112958; }
        .btn-back { color: #64748b; text-decoration: none; margin-right: 15px; font-weight: 600; }

        .modal { display: none; position: fixed; z-index: 10000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); justify-content: center; align-items: center; }
        .modal-content { background-color: #fefefe; border-radius: 8px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); width: 90%; max-width: 400px; }
        .modal-header { padding: 15px; border-bottom: 1px solid #e2e8f0; }
        .modal-header h3 { margin: 0; color: #112958; font-size: 1.2rem; }
        .modal-body { padding: 20px; }
        .modal-footer { padding: 15px; text-align: right; border-top: 1px solid #e2e8f0; }
        .btn-modal { padding: 8px 15px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: background-color 0.2s; }
        .btn-cancel { background-color: #cbd5e1; color: #1e293b; margin-right: 10px; }
        .btn-confirm { background-color: #10b981; color: white; }

        .content-split { display: flex; gap: 30px; align-items: flex-start; padding: 20px 0; }
        .form-container { max-width: 100%; width: 50%; margin: 0; }
        .lottie-container { width: 50%; padding-top: 50px; display: flex; justify-content: center; align-items: center; }

        @media (max-width: 1024px) {
            .content-split { flex-direction: column; }
            .form-container, .lottie-container { width: 100%; }
        }
    </style>
</head>

<body>

<jsp:include page="../sidebar.jsp" />

<div class="main-content">
    <jsp:include page="../header.jsp">
        <jsp:param name="pageTitle" value="Ajouter une Salle" />
    </jsp:include>

    <main>
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <div id="toastError" class="toast-notification alert-error">
                <div style="display:flex; align-items:center;">
                    <i class="fa fa-exclamation-circle mr-3" style="font-size: 1.2rem;"></i>
                    <span>
                        <% if ("MissingFields".equals(error)) { %>
                            <strong>Erreur :</strong> Veuillez remplir tous les champs obligatoires.
                        <% } else if ("InvalidCapacity".equals(error)) { %>
                            <strong>Erreur :</strong> La capacité doit être un nombre valide.
                        <% } else { %>
                            Une erreur inconnue est survenue.
                        <% } %>
                    </span>
                </div>
                <span style="cursor:pointer; margin-left:20px; font-weight:bold; font-size:1.2rem;" onclick="this.parentElement.style.display='none'">&times;</span>
            </div>

            <script>
                setTimeout(function() { 
                    var toast = document.getElementById("toastError"); 
                    if(toast) { toast.style.display = "none"; }
                }, 5000);
            </script>
        <% } %>

        <div class="content-split">
            <div class="card form-container">
                <div class="card-header">
                    <h3>Nouvelle Salle</h3>
                    <a href="/admin/salles/liste_salles" class="btn-back"><i class="fa fa-arrow-left"></i> Retour</a>
                </div>

                <div class="card-body">
                    <form id="addRoomForm" action="<%= request.getContextPath() %>/admin/salles/ajouter" method="post">
                        <div class="form-group">
                            <label>Nom de la Salle</label>
                            <input type="text" name="name" class="form-control" required placeholder="Ex: Salle B-201">
                        </div>

                        <div class="form-group">
                            <label>Capacité (Nombre de places)</label>
                            <input type="number" name="capacity" class="form-control" required min="1" placeholder="Ex: 30">
                        </div>

                        <div class="form-group">
                            <label>Type de Salle</label>
                            <select name="type" class="form-control" required>
                                <option value="" disabled selected>-- Choisir le type --</option>
                                <% for (String type : roomTypes) { %>
                                    <option value="<%= type %>"><%= type %></option>
                                <% } %>
                            </select>
                            <small style="color:#64748b; font-size:0.8rem;">Définit l'équipement et l'usage de la salle.</small>
                        </div>

                        <div style="margin-top: 20px;">
                            <button type="button" class="btn-submit" onclick="showConfirmModal()">
                                <i class="fa fa-save"></i> Enregistrer la Salle
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="lottie-container">
                <dotlottie-wc
                    src="https://lottie.host/ecd7083c-010c-428b-a13b-b5556af1b75f/ciij8Pl5bl.lottie"
                    style="width: 450px;height: 450px"
                    autoplay
                    loop>
                </dotlottie-wc>
            </div>
        </div>
    </main>
</div>

<div id="confirmModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fa fa-check-circle" style="color:#10b981;"></i> Confirmation</h3>
        </div>
        <div class="modal-body">
            <p>Voulez-vous vraiment ajouter cette nouvelle salle ?</p>
        </div>
        <div class="modal-footer">
            <button class="btn-modal btn-cancel" onclick="closeConfirmModal()">Annuler</button>
            <button class="btn-modal btn-confirm" onclick="submitForm()" style="background-color:#10b981;">Confirmer</button>
        </div>
    </div>
</div>

<script>
    function showConfirmModal() {
        var form = document.getElementById("addRoomForm");
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
        document.getElementById("addRoomForm").submit();
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