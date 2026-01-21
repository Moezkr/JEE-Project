<%@ page import="com.projetjee.model.User" %>
<%@ page import="com.projetjee.model.Formation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    User formateur = (User) request.getAttribute("formateur");
    List<Formation> allFormations = (List<Formation>) request.getAttribute("allFormations");
    List<Integer> assignedFormationIds = (List<Integer>) request.getAttribute("assignedFormationIds");

    java.util.Set<Integer> assignedIdsSet = assignedFormationIds != null ? new java.util.HashSet<>(assignedFormationIds) : java.util.Collections.emptySet();

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>FormaPRO - Modifier Formateur</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="../../css/admin_dashboard.css" rel="stylesheet">

    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.8.5/dist/dotlottie-wc.js" type="module"></script>

    <style>
        .form-container { max-width: 800px; margin: 0 auto; }
        .form-group label { font-weight: 600; color: #1e293b; margin-bottom: 8px; display: block; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-family: 'Open Sans', sans-serif; margin-bottom: 20px; }
        .form-control:focus { outline: none; border-color: #112958; box-shadow: 0 0 0 3px rgba(17, 41, 88, 0.1); }
        .btn-submit { background-color: #112958; color: white; padding: 12px 30px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s; }
        .btn-submit:hover { background-color: #ffc107; color: #112958; }
        .btn-back { color: #64748b; text-decoration: none; margin-right: 15px; font-weight: 600; }

        .toast-notification { position: fixed; bottom: 20px; right: 20px; z-index: 9999; padding: 15px 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; justify-content: space-between; min-width: 300px; animation: slideInRight 0.5s ease-out forwards; }
        .alert-error { background-color: #fee2e2; color: #991b1b; border-left: 5px solid #ef4444; }

        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

        .modal { display: none; position: fixed; z-index: 10000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); justify-content: center; align-items: center; }
        .modal-content { background-color: #fefefe; border-radius: 8px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); width: 90%; max-width: 400px; animation-name: animatetop; animation-duration: 0.4s; }
        .modal-header { padding: 15px; border-bottom: 1px solid #e2e8f0; }
        .modal-header h3 { margin: 0; color: #112958; font-size: 1.2rem; }
        .modal-body { padding: 20px; }
        .modal-footer { padding: 15px; text-align: right; border-top: 1px solid #e2e8f0; }

        .btn-modal { padding: 8px 15px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: background-color 0.2s; }
        .btn-cancel { background-color: #cbd5e1; color: #1e293b; margin-right: 10px; }
        .btn-cancel:hover { background-color: #94a3b8; }
        .btn-confirm { background-color: #10b981; color: white; }
        .btn-confirm:hover { background-color: #059669; }

        @keyframes animatetop { from {top: -300px; opacity: 0} to {top: 0; opacity: 1} }

        .content-split { display: flex; gap: 30px; align-items: flex-start; padding: 20px 0; }
        .form-container { max-width: 100%; width: 50%; margin: 0; }
        .lottie-container { width: 50%; padding-top: 50px; display: flex; justify-content: center; align-items: center; height: 100%; }

        @media (max-width: 1024px) {
            .content-split { flex-direction: column; }
            .form-container, .lottie-container { width: 100%; }
            .lottie-container { padding-top: 20px; }
        }

        .formation-list { display: flex; flex-wrap: wrap; gap: 10px; }
        .checkbox-container { display: flex; align-items: center; user-select: none; cursor: pointer; padding: 8px 12px; border: 2px solid #e2e8f0; border-radius: 6px; transition: all 0.2s ease-in-out; }
        .checkbox-container:hover { border-color: #ffc107; }
        .checkbox-container input[type="checkbox"] { position: absolute; opacity: 0; cursor: pointer; height: 0; width: 0; }
        .checkbox-custom { height: 18px; width: 18px; background-color: #fff; border: 2px solid #ccc; border-radius: 4px; display: inline-block; margin-right: 8px; position: relative; transition: background-color 0.2s, border-color 0.2s; }

        .checkbox-container input:checked ~ .checkbox-custom { background-color: #112958; border-color: #112958; }
        .checkbox-custom:after { content: ""; position: absolute; display: none; left: 5px; top: 1px; width: 4px; height: 10px; border: solid white; border-width: 0 3px 3px 0; transform: rotate(45deg); }
        .checkbox-container input:checked ~ .checkbox-custom:after { display: block; }
        .checkbox-container input:checked ~ span:not(.checkbox-custom) { font-weight: 600; color: #112958; }
        #formationError { display:none; color:#ef4444; font-weight:600; margin-top:5px; }
    </style>
</head>

<body>

<jsp:include page="../sidebar.jsp" />

<div class="main-content">
    <jsp:include page="../header.jsp">
        <jsp:param name="pageTitle" value="Modifier un Formateur" />
    </jsp:include>

    <main>
        <% if (error != null) { %>
            <div id="toastError" class="toast-notification alert-error">
                <div style="display:flex; align-items:center;">
                    <i class="fa fa-exclamation-circle mr-3" style="font-size: 1.2rem;"></i>
                    <span>
                        <% if ("DuplicateInfo".equals(error)) { %>
                            <strong>Erreur :</strong> Email ou téléphone déjà utilisé.
                        <% } else if ("InvalidEmail".equals(error)) { %>
                            <strong>Erreur :</strong> L'email doit se terminer par @gmail.com.
                        <% } else if ("InvalidPhone".equals(error)) { %>
                            <strong>Erreur :</strong> Le numéro doit contenir exactement 8 chiffres.
                        <% } else if ("MissingFormations".equals(error)) { %>
                            <strong>Erreur :</strong> Vous devez sélectionner au moins une formation.
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
                    if(toast) {
                        toast.style.transition="opacity 0.5s";
                        toast.style.opacity="0";
                        setTimeout(function(){ toast.style.display="none"; },500);
                    }
                }, 5000);
            </script>
        <% } %>

        <div class="content-split">
            <div class="card form-container">
                <div class="card-header">
                    <h3>Modifier: <%= formateur.getFullName() %></h3>
                    <a href="liste_formateurs.jsp" class="btn-back"><i class="fa fa-arrow-left"></i> Retour</a>
                </div>

                <div class="card-body">
                    <form id="editFormateurForm" method="post" action="<%= request.getContextPath() %>/admin/formateurs/modifier">
                        <input type="hidden" name="id" value="<%= formateur.getId() %>">

                        <div class="row" style="display:flex; gap:20px;">
                            <div class="form-group" style="flex:1;">
                                <label>Prénom</label>
                                <input type="text" name="firstName" class="form-control" value="<%= formateur.getFirstName() %>" required>
                            </div>
                            <div class="form-group" style="flex:1;">
                                <label>Nom</label>
                                <input type="text" name="lastName" class="form-control" value="<%= formateur.getLastName() %>" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" value="<%= formateur.getEmail() %>" required>
                            <small style="color:#64748b; font-size:0.8rem;">Doit se terminer par @gmail.com</small>
                        </div>

                        <div class="form-group">
                            <label>Téléphone</label>
                            <input type="tel" name="phoneNumber" class="form-control" value="<%= formateur.getPhoneNumber() %>" pattern="^\d{8}$" title="8 chiffres obligatoires" required>
                            <small style="color:#64748b; font-size:0.8rem;">8 chiffres obligatoires</small>
                        </div>

                        <div class="form-group">
                            <label>Formations assignées <span style="color:red">*</span></label>
                            <div class="formation-list">
                                <% 
                                    if (allFormations != null) {
                                        for (Formation f : allFormations) {
                                            boolean isChecked = assignedIdsSet.contains(f.getId());
                                %>
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="formationIds" value="<%=f.getId()%>" <%= isChecked ? "checked" : "" %>>
                                        <span class="checkbox-custom"></span>
                                        <span><%= f.getNom() %></span>
                                    </label>
                                <% 
                                        }
                                    } else { 
                                %>
                                    <p>Aucune formation trouvée.</p>
                                <% } %>
                            </div>
                            <small id="formationError">Vous devez sélectionner au moins une formation.</small>
                        </div>

                        <div style="text-align: right; margin-top: 10px;">
                            <button type="button" class="btn-submit" onclick="validateAndConfirm()">
                                <i class="fa fa-save"></i> Enregistrer les modifications
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="lottie-container">
                <dotlottie-wc
                        src="https://lottie.host/da13f0f0-30d8-4868-994b-bb71fcb7f7ff/8kA8xWKqmE.lottie"
                        style="width: 600px; height: 600px"
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
            <h3><i class="fa fa-edit"></i> Confirmation</h3>
        </div>
        <div class="modal-body">
            <p>Voulez-vous vraiment modifier les informations de ce formateur ?</p>
        </div>
        <div class="modal-footer">
            <button class="btn-modal btn-cancel" onclick="closeConfirmModal()">Annuler</button>
            <button class="btn-modal btn-confirm" onclick="submitForm()">Confirmer</button>
        </div>
    </div>
</div>

<script>
    function validateAndConfirm() {
        var form = document.getElementById("editFormateurForm");
        if (!form) return;

        var checkboxes = document.querySelectorAll('input[name="formationIds"]:checked');
        var formationError = document.getElementById("formationError");
        var hasFormationsSelected = checkboxes.length > 0;

        if (!hasFormationsSelected) {
            formationError.style.display = "block";
            return;
        } else {
            formationError.style.display = "none";
        }

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
        document.getElementById("editFormateurForm").submit();
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