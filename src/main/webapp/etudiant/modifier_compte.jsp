<%@ page import="com.projetjee.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User userToEdit = (User) request.getAttribute("userToEdit");
    if (userToEdit == null) {
        userToEdit = (User) session.getAttribute("user");
    }
    if (userToEdit == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Étudiant - Modifier Compte</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css">

    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.8.5/dist/dotlottie-wc.js" type="module"></script>

    <style>
        :root {
            --primary-color: #10b981;
            --accent-color: #059669;
        }

        .form-container { max-width: 100%; width: 50%; }
        .form-group label { font-weight: 600; color: #1e293b; margin-bottom: 8px; display: block; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 20px; }
        .form-control:focus { outline: none; border-color: var(--primary-color); box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1); }

        .btn-submit {
            background-color: var(--primary-color);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-submit:hover { background-color: #059669; }

        .btn-back { color: #64748b; text-decoration: none; margin-bottom: 20px; display: inline-block; }

        .toast-notification {
            position: fixed; bottom: 20px; right: 20px; z-index: 9999;
            padding: 15px 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            display: flex; align-items: center; justify-content: space-between;
            min-width: 300px; animation: slideInRight 0.5s ease-out forwards;
        }
        .alert-error { background-color: #fee2e2; color: #991b1b; border-left: 5px solid #ef4444; }
        .alert-success { background-color: #d1fae5; color: #065f46; border-left: 5px solid #10b981; }
        #passwordError { display:none; color:#ef4444; font-weight:600; margin-top:5px; }

        @keyframes slideInRight {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        .modal {
            display: none; position: fixed; z-index: 10000; left:0; top:0;
            width:100%; height:100%; background-color: rgba(0,0,0,0.4);
            align-items:center; justify-content:center;
        }
        .modal-content {
            background-color:#fff; border-radius:8px; padding:20px;
            width:400px; max-width:90%;
        }
        .modal-header h3 { margin:0; }
        .modal-footer { display:flex; justify-content:flex-end; gap:10px; margin-top:20px; }
        .btn-modal { padding:8px 20px; border:none; border-radius:6px; font-weight:600; cursor:pointer; }
        .btn-cancel { background:#e2e8f0; color:#1e293b; }
        .btn-confirm { background:var(--primary-color); color:#fff; }

        .content-split {
            display: flex;
            gap: 30px;
            align-items: flex-start;
            padding: 20px 0;
        }

        .lottie-container {
            width: 50%;
            padding-top: 50px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        @media (max-width: 1024px) {
            .content-split { flex-direction: column; }
            .form-container, .lottie-container { width: 100%; }
        }
    </style>
</head>
<body>

<jsp:include page="/etudiant/sidebar.jsp" />

<div class="main-content">
    <header class="header">
        <div class="header-title">
            <h1>Modifier Compte</h1>
        </div>
        <div class="header-actions">
            <span>Étudiant</span>
        </div>
    </header>

    <main>
        <%
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            String msg = request.getParameter("msg");
        %>

        <% if (error != null) { %>
        <div id="toastError" class="toast-notification alert-error">
            <i class="fa fa-exclamation-circle mr-3"></i>
            <span><%= error %></span>
            <span style="cursor:pointer; margin-left:20px; font-weight:bold; font-size:1.2rem;"
                  onclick="this.parentElement.style.display='none'">&times;</span>
        </div>
        <% } else if ("true".equals(success)) { %>
        <div id="toastSuccess" class="toast-notification alert-success">
            <i class="fa fa-check-circle mr-3"></i>
            <span><%= (msg != null) ? java.net.URLDecoder.decode(msg, "UTF-8") : "Opération réussie !" %></span>
            <span style="cursor:pointer; margin-left:20px; font-weight:bold; font-size:1.2rem;"
                  onclick="this.parentElement.style.display='none'">&times;</span>
        </div>
        <% } %>

        <script>
            setTimeout(function(){
                var toast = document.getElementById("toastError") || document.getElementById("toastSuccess");
                if(toast){
                    toast.style.transition="opacity 0.5s";
                    toast.style.opacity="0";
                    setTimeout(()=>{toast.style.display="none";},500);
                }
            }, 5000);
        </script>

        <div class="content-split">
            <div class="card form-container">
                <div class="card-header">
                    <h3>Modifier mes informations</h3>
                </div>

                <div class="card-body">
                    <form id="editCompteForm" method="post" action="<%= request.getContextPath() %>/compte/modifier">
                        <input type="hidden" name="id" value="<%= userToEdit.getId() %>">

                        <div style="display:flex; gap:20px;">
                            <div class="form-group" style="flex:1;">
                                <label>Prénom</label>
                                <input type="text" name="firstName" class="form-control" required value="<%= userToEdit.getFirstName() %>">
                            </div>
                            <div class="form-group" style="flex:1;">
                                <label>Nom</label>
                                <input type="text" name="lastName" class="form-control" required value="<%= userToEdit.getLastName() %>">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" required value="<%= userToEdit.getEmail() %>">
                        </div>

                        <div class="form-group">
                            <label>Téléphone</label>
                            <input type="tel" name="phoneNumber" class="form-control" required
                                   value="<%= userToEdit.getPhoneNumber() %>" pattern="^\d{8}$"
                                   title="Le numéro doit contenir exactement 8 chiffres">
                        </div>

                        <h4 style="font-size:1.1rem; color:#1e293b; margin:30px 0 25px 0; font-weight:700;
                                  padding-bottom:10px; border-bottom:1px solid #e2e8f0;">
                            Changer le mot de passe <small style="font-weight:400;">(Laisser vide si inchangé)</small>
                        </h4>

                        <div style="display:flex; gap:30px;">
                            <div class="form-group" style="flex:1;">
                                <label>Nouveau Mot de passe</label>
                                <input type="password" id="password" name="password" class="form-control" autocomplete="new-password">
                            </div>
                            <div class="form-group" style="flex:1;">
                                <label>Confirmer le mot de passe</label>
                                <input type="password" id="confirmPassword" class="form-control" autocomplete="new-password">
                                <small id="passwordError" style="font-size:0.875rem;">
                                    <i class="fa fa-times-circle"></i> Les mots de passe ne correspondent pas.
                                </small>
                            </div>
                        </div>

                        <div style="text-align:right; margin-top:30px; padding-top:20px; border-top:1px solid #e2e8f0;">
                            <button type="button" class="btn-submit" onclick="validateAndConfirm()">
                                <i class="fa fa-save"></i> Enregistrer
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="lottie-container">
                <dotlottie-wc
                        src="https://lottie.host/1bf01b95-00bb-4bf0-aece-edc8f7610f0a/74OmZRHY6y.lottie"
                        style="width: 600px;height: 600px"
                        autoplay
                        loop
                ></dotlottie-wc>
            </div>
        </div>
    </main>
</div>

<div id="confirmModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fa fa-edit" style="color:var(--primary-color);"></i> Confirmation</h3>
        </div>
        <div class="modal-body">
            <p>Voulez-vous vraiment appliquer ces modifications à votre compte ?</p>
        </div>
        <div class="modal-footer">
            <button class="btn-modal btn-cancel" onclick="closeConfirmModal()">Annuler</button>
            <button class="btn-modal btn-confirm" onclick="submitForm()">Confirmer</button>
        </div>
    </div>
</div>

<script>
    function validateAndConfirm() {
        var form = document.getElementById("editCompteForm");
        var pass = document.getElementById("password").value;
        var confirm = document.getElementById("confirmPassword").value;
        var errorMsg = document.getElementById("passwordError");
        var confirmField = document.getElementById("confirmPassword");

        errorMsg.style.display = "none";
        confirmField.style.borderColor = "#e2e8f0";

        if (pass || confirm) {
            if (pass !== confirm) {
                errorMsg.style.display = "block";
                confirmField.style.borderColor = "#ef4444";
                return;
            }
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
        document.getElementById("editCompteForm").submit();
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