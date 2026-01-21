<%@ page import="com.projetjee.model.User" %>
<%@ page import="com.projetjee.dao.UserDAO" %>
<%@ page import="com.projetjee.dao.FormationDAO" %>
<%@ page import="com.projetjee.dao.InscriptionDAO" %>
<%@ page import="com.projetjee.model.Formation" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User currentUser = (User) session.getAttribute("user");
    
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
        response.sendRedirect("../../login.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    User student = null;
    int currentFormationId = -1;
    List<Formation> formations = null;

    if (idParam != null) {
        int studentId = Integer.parseInt(idParam);

        UserDAO userDAO = new UserDAO();
        student = userDAO.getUserById(studentId);

        if (student != null) {
            InscriptionDAO inscriptionDAO = new InscriptionDAO();
            currentFormationId = inscriptionDAO.getFormationIdByStudent(studentId);

            FormationDAO formationDAO = new FormationDAO();
            formations = formationDAO.getAllFormations();
        }
    }

    if (student == null) {
        response.sendRedirect("liste_etudiants.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>FormaPRO - Modifier Étudiant</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="../../css/admin_dashboard.css" rel="stylesheet">

    <style>
        .form-container { max-width: 800px; margin: 0 auto; }
        .form-group label { font-weight: 600; color: #1e293b; margin-bottom: 8px; display: block; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-family: 'Open Sans', sans-serif; margin-bottom: 20px; }
        .form-control:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
        .btn-submit { background-color: #3b82f6; color: white; padding: 12px 30px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s; }
        .btn-submit:hover { background-color: #2563eb; }
        .btn-back { color: #64748b; text-decoration: none; margin-right: 15px; font-weight: 600; }

        .toast-notification { position: fixed; bottom: 20px; right: 20px; z-index: 9999; padding: 15px 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; justify-content: space-between; min-width: 300px; animation: slideInRight 0.5s ease-out forwards; }
        .alert-error { background-color: #fee2e2; color: #991b1b; border-left: 5px solid #ef4444; }

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
        <jsp:param name="pageTitle" value="Modifier un Étudiant" />
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
                        <% if ("DuplicateInfo".equals(error)) { %> Erreur : Email ou téléphone déjà utilisé. <% }
                        else if ("InvalidEmail".equals(error)) { %> Erreur : L'email doit se terminer par @gmail.com. <% }
                        else if ("InvalidPhone".equals(error)) { %> Erreur : 8 chiffres obligatoires. <% }
                        else { %> Une erreur est survenue. <% } %>
                    </span>
                </div>
                <span style="cursor:pointer; margin-left:20px; font-weight:bold; font-size:1.2rem;" onclick="this.parentElement.style.display='none'">&times;</span>
            </div>

            <script>
                setTimeout(function(){ 
                    var t = document.getElementById("toastError"); 
                    if(t) t.style.display="none"; 
                }, 5000);
            </script>
        <% } %>

        <div class="card form-container">
            <div class="card-header">
                <h3>Modifier: <%= student.getFullName() %></h3>
                <a href="/admin/etudiants/liste_etudiants" class="btn-back"><i class="fa fa-arrow-left"></i> Retour</a>
            </div>

            <div class="card-body">
                <form id="editStudentForm" action="../../admin/etudiants/modifier" method="post">
                    <input type="hidden" name="id" value="<%= student.getId() %>">
                    <input type="hidden" name="role" value="STUDENT">

                    <div class="row" style="display:flex; gap:20px;">
                        <div class="form-group" style="flex:1;">
                            <label>Prénom</label>
                            <input type="text" name="firstName" class="form-control" value="<%= student.getFirstName() %>" required>
                        </div>
                        <div class="form-group" style="flex:1;">
                            <label>Nom</label>
                            <input type="text" name="lastName" class="form-control" value="<%= student.getLastName() %>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" class="form-control" value="<%= student.getEmail() %>" required>
                        <small style="color:#64748b; font-size:0.8rem;">Doit se terminer par @gmail.com</small>
                    </div>

                    <div class="form-group">
                        <label>Téléphone</label>
                        <input type="tel" name="phoneNumber" class="form-control" value="<%= student.getPhoneNumber() %>" pattern="^\d{8}$" title="8 chiffres obligatoires" required>
                    </div>

                    <div class="form-group">
                        <label>Formation</label>
                        <select name="formationId" class="form-control" required>
                            <option value="" disabled>-- Choisir une formation --</option>
                            <%
                                if (formations != null) {
                                    for (Formation f : formations) {
                                        boolean isSelected = (f.getId() == currentFormationId);
                            %>
                                <option value="<%= f.getId() %>" <%= isSelected ? "selected" : "" %>>
                                    <%= f.getNom() %>
                                </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div style="text-align: right; margin-top: 10px;">
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
            <p>Voulez-vous vraiment modifier les informations de cet étudiant ?</p>
        </div>
        <div class="modal-footer">
            <button class="btn-modal btn-cancel" onclick="closeConfirmModal()">Annuler</button>
            <button class="btn-modal btn-confirm" onclick="submitForm()" style="background-color:#3b82f6;">Confirmer</button>
        </div>
    </div>
</div>

<script>
    function showConfirmModal() {
        var form = document.getElementById("editStudentForm");
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
        document.getElementById("editStudentForm").submit(); 
    }

    window.onclick = function(e) { 
        if(e.target == document.getElementById('confirmModal')) {
            closeConfirmModal();
        }
    }
</script>

</body>
</html>