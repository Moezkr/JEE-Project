<%@ page import="com.projetjee.model.User" %>
<%@ page import="com.projetjee.dao.FormationDAO" %>
<%@ page import="com.projetjee.model.Formation" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("../../login.jsp");
        return;
    }

    List<Formation> formations = (List<Formation>) request.getAttribute("formations");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>FormaPRO - Ajouter un Étudiant</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link href="../../css/admin_dashboard.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.8.5/dist/dotlottie-wc.js" type="module"></script>

    <style>
        .form-container { max-width: 800px; margin: 0 auto; }
        .form-group label { font-weight: 600; color: #1e293b; margin-bottom: 8px; display: block; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 20px; }
        .form-control:focus { outline: none; border-color: #112958; box-shadow: 0 0 0 3px rgba(17,41,88,0.1); }
        .btn-submit { background-color: #112958; color: white; padding: 12px 30px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s; }
        .btn-submit:hover { background-color: #ffc107; color: #112958; }
        .btn-back { color: #64748b; text-decoration: none; margin-right: 15px; font-weight: 600; }

        .toast-notification { position: fixed; bottom: 20px; right: 20px; z-index: 9999; padding: 15px 25px; border-radius: 8px; display: flex; align-items: center; justify-content: space-between; min-width: 300px; animation: slideInRight 0.5s ease-out forwards; }
        .alert-error { background-color: #fee2e2; color: #991b1b; border-left: 5px solid #ef4444; }
        #passwordError { display:none; color:#ef4444; font-weight:600; margin-top:5px; }

        @keyframes slideInRight { 
            from { transform: translateX(100%); opacity: 0; } 
            to { transform: translateX(0); opacity: 1; } 
        }

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
        .lottie-container { width: 50%; padding-top: 20px; display: flex; justify-content: center; align-items: center; }

        @media (max-width: 1024px) {
            .content-split { flex-direction: column; }
            .form-container, .lottie-container { width: 100%; }
            .lottie-container { padding-top: 20px; order: 1; }
            .form-container { order: 2; }
        }
    </style>
</head>

<body>

<jsp:include page="../sidebar.jsp" />

<div class="main-content">
    <jsp:include page="../header.jsp">
        <jsp:param name="pageTitle" value="Inscrire un Étudiant" />
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
                        <% if ("DuplicateInfo".equals(error)) { %>
                            <strong>Erreur :</strong> Email ou téléphone déjà utilisé.
                        <% } else if ("MissingFields".equals(error)) { %>
                            <strong>Erreur :</strong> Champs obligatoires manquants.
                        <% } else { %>
                            Une erreur est survenue.
                        <% } %>
                    </span>
                </div>
                <span style="cursor:pointer; margin-left:20px; font-weight:bold; font-size:1.2rem;" onclick="this.parentElement.style.display='none'">&times;</span>
            </div>

            <script>
                setTimeout(function() { 
                    var toast = document.getElementById("toastError"); 
                    if(toast) { toast.style.display="none"; }
                }, 5000);
            </script>
        <% } %>

        <div class="content-split">
            <div class="card form-container">
                <div class="card-header">
                    <h3>Nouvel Étudiant</h3>
                    <a href="liste_etudiants" class="btn-back"><i class="fa fa-arrow-left"></i> Retour</a>
                </div>

                <div class="card-body">
                    <form id="addStudentForm" action="<%= request.getContextPath() %>/admin/etudiants/ajouter" method="post">
                        <input type="hidden" name="role" value="STUDENT">

                        <div class="row" style="display:flex; gap:20px;">
                            <div class="form-group" style="flex:1;">
                                <label>Prénom</label>
                                <input type="text" name="firstName" class="form-control" required placeholder="Ex: Sarah">
                            </div>
                            <div class="form-group" style="flex:1;">
                                <label>Nom</label>
                                <input type="text" name="lastName" class="form-control" required placeholder="Ex: Jaziri">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" required placeholder="email@exemple.com">
                        </div>

                        <div class="form-group">
                            <label>Téléphone</label>
                            <input type="tel" name="phoneNumber" class="form-control" placeholder="Ex: 22334455" pattern="^\d{8}$" title="8 chiffres obligatoires" required>
                        </div>

                        <div class="row" style="display:flex; gap:20px;">
                            <div class="form-group" style="flex:1;">
                                <label>Mot de passe</label>
                                <input type="password" id="password" name="password" class="form-control" required>
                            </div>
                            <div class="form-group" style="flex:1;">
                                <label>Confirmer le mot de passe</label>
                                <input type="password" id="confirmPassword" class="form-control" required>
                                <small id="passwordError">
                                    <i class="fa fa-times-circle"></i> Les mots de passe ne correspondent pas.
                                </small>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Formation à suivre</label>
                            <select name="formationId" class="form-control" required>
                                <option value="" disabled selected>-- Choisir une formation --</option>
                                <%
                                    if (formations != null) {
                                        for (Formation f : formations) {
                                %>
                                    <option value="<%= f.getId() %>">
                                        <%= f.getNom() %> (<%= f.getPrix() %> TND - <%= f.getDureeMois() %> Mois)
                                    </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div style="text-align:right; margin-top:10px;">
                            <button type="button" class="btn-submit" onclick="validateAndConfirm()">
                                <i class="fa fa-user-plus"></i> Inscrire
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="lottie-container">
                <dotlottie-wc
                    src="https://lottie.host/1759f252-d87e-4093-aee5-f9e703a72989/VkscH6KhhA.lottie"
                    style="width: 600px;height: 600px" 
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
            <p>Voulez-vous vraiment inscrire cet étudiant à la formation sélectionnée ?</p>
        </div>
        <div class="modal-footer">
            <button class="btn-modal btn-cancel" onclick="closeConfirmModal()">Annuler</button>
            <button class="btn-modal btn-confirm" onclick="submitForm()" style="background-color:#10b981;">Confirmer</button>
        </div>
    </div>
</div>

<script>
    function validateAndConfirm() {
        var form = document.getElementById("addStudentForm");
        var pass = document.getElementById("password").value;
        var confirm = document.getElementById("confirmPassword").value;
        var errorMsg = document.getElementById("passwordError");
        var confirmInput = document.getElementById("confirmPassword");

        if(pass !== confirm) {
            errorMsg.style.display = "block";
            confirmInput.style.borderColor = "#ef4444";
            return;
        } else {
            errorMsg.style.display = "none";
            confirmInput.style.borderColor = "#e2e8f0";
        }

        if(form.checkValidity()) {
            document.getElementById("confirmModal").style.display = "flex";
        } else {
            form.reportValidity();
        }
    }

    function closeConfirmModal() { 
        document.getElementById("confirmModal").style.display = "none"; 
    }

    function submitForm() { 
        document.getElementById("addStudentForm").submit(); 
    }

    window.onclick = function(event) {
        var modal = document.getElementById('confirmModal');
        if(event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>

</body>
</html>