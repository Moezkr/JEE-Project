<%@ page import="com.projetjee.model.User" %>
<%@ page import="com.projetjee.model.Formation" %>
<%@ page import="com.projetjee.model.Programme" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Formation formation = (Formation) request.getAttribute("formation");
    if (formation == null) {
        response.sendRedirect(request.getContextPath() + "/admin/formations/liste_formations.jsp");
        return;
    }

    List<Programme> existingModules = (List<Programme>) request.getAttribute("modules");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>FormaPRO - Modifier Formation</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="../../css/admin_dashboard.css" rel="stylesheet">

    <style>
        .form-container { max-width: 900px; margin: 0 auto; }
        .form-group label { font-weight: 600; color: #1e293b; margin-bottom: 8px; display: block; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 20px; }
        .form-control:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
        .btn-submit { background-color: #3b82f6; color: white; padding: 12px 30px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; width: 100%; transition: 0.3s; }
        .btn-submit:hover { background-color: #2563eb; }
        .btn-back { color: #64748b; text-decoration: none; margin-right: 15px; font-weight: 600; }

        .module-section { margin-top: 40px; border-top: 1px solid #e2e8f0; padding-top: 30px; }
        .module-list-item { background: #f8f9fa; border: 1px solid #e2e8f0; padding: 20px; border-radius: 8px; margin-bottom: 15px; position: relative; }
        .module-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; border-bottom: 1px solid #e2e8f0; padding-bottom: 10px; }
        .btn-add-module { background-color: #10b981; color: white; padding: 12px 0; border-radius: 6px; border: none; cursor: pointer; font-weight: 600; width: 100%; }
        .btn-add-module:hover { background-color: #059669; }
        .btn-remove { color: #ef4444; background: none; border: none; cursor: pointer; font-size: 1.1rem; }

        .toast-notification { position: fixed; bottom: 20px; right: 20px; z-index: 9999; padding: 15px 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; justify-content: space-between; min-width: 300px; animation: slideInRight 0.5s ease-out forwards; }
        .alert-error { background-color: #fee2e2; color: #991b1b; border-left: 5px solid #ef4444; }
        
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>

<body>

<jsp:include page="../sidebar.jsp" />

<div class="main-content">
    <jsp:include page="../header.jsp">
        <jsp:param name="pageTitle" value="Modifier une Formation" />
    </jsp:include>

    <main>
        <% String error = request.getParameter("error"); if(error != null) { %>
            <div id="toastError" class="toast-notification alert-error">
                <span><i class="fa fa-exclamation-circle mr-2"></i> Erreur lors de l'opération.</span>
                <span onclick="this.parentElement.style.display='none'" style="cursor:pointer;">&times;</span>
            </div>
            <script>setTimeout(function(){ document.getElementById("toastError").style.display="none"; }, 5000);</script>
        <% } %>

        <div class="card form-container">
            <div class="card-header">
                <h3>Modifier Formation: <%= formation.getNom() %></h3>
                <a href="liste_formations.jsp" class="btn-back"><i class="fa fa-arrow-left"></i> Retour</a>
            </div>

            <div class="card-body">
                <form id="editFormationForm" action="<%= request.getContextPath() %>/admin/formations/modifier" method="post">
                    <input type="hidden" name="id" value="<%= formation.getId() %>">

                    <h4 style="color:#112958;">Informations Générales</h4>

                    <div class="form-group">
                        <label>Nom de la formation</label>
                        <input type="text" name="nom" class="form-control" value="<%= formation.getNom() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description" class="form-control" rows="3" required><%= formation.getDescription() %></textarea>
                    </div>

                    <div class="row" style="display:flex; gap:20px;">
                        <div class="form-group" style="flex:1;">
                            <label>Prix (TND)</label>
                            <input type="number" name="prix" class="form-control" value="<%= formation.getPrix() %>" required>
                        </div>
                        <div class="form-group" style="flex:1;">
                            <label>Durée (Mois)</label>
                            <input type="number" name="duree" class="form-control" value="<%= formation.getDureeMois() %>" required>
                        </div>
                    </div>

                    <hr style="margin: 30px 0; border: 0; border-top: 1px solid #e2e8f0;">

                    <div class="module-section">
                        <h4 style="margin:0; color:#112958;">Programme de la Formation (Modules)</h4>
                        <p style="color:#64748b; font-size:0.9rem; margin-bottom:20px;">Les anciens modules seront remplacés par la nouvelle liste soumise.</p>

                        <div id="modules-container">
                            <%
                                int initialModuleCount = 0;
                                for (Programme p : existingModules) {
                                    initialModuleCount++;
                            %>
                            <div class="module-list-item" data-module-id="<%= p.getId() %>">
                                <div class="module-header">
                                    <h5 style="margin:0; color:#334155;" class="module-order-label">Module <%= initialModuleCount %></h5>
                                    <button type="button" class="btn-remove" onclick="removeModule(this)" title="Supprimer">
                                        <i class="fa fa-trash"></i>
                                    </button>
                                </div>
                                <div class="form-group">
                                    <label>Titre du Module</label>
                                    <input type="text" name="moduleTitles" class="form-control" value="<%= p.getTitreModule() %>" required>
                                </div>
                                <div class="form-group" style="margin-bottom:0;">
                                    <label>Détails / Contenu</label>
                                    <textarea name="moduleDetails" class="form-control" rows="2" required><%= p.getDetails() %></textarea>
                                </div>
                            </div>
                            <% } %>
                        </div>

                        <button type="button" class="btn-add-module" onclick="addModule()">
                            <i class="fa fa-plus-circle mr-2"></i> Ajouter un Module
                        </button>
                    </div>

                    <div style="margin-top: 40px;">
                        <button type="button" class="btn-submit" onclick="showConfirmModal()">
                            <i class="fa fa-save mr-2"></i> Enregistrer la Formation Complète
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
            <p>Voulez-vous vraiment modifier cette formation et remplacer son programme actuel ?</p>
        </div>
        <div class="modal-footer">
            <button class="btn-modal btn-cancel" onclick="closeConfirmModal()">Annuler</button>
            <button class="btn-modal btn-confirm" onclick="submitFormationForm()" style="background-color:#3b82f6;">Confirmer</button>
        </div>
    </div>
</div>

<script>
    let moduleCounter = <%= existingModules.size() %>;

    function addModule() {
        moduleCounter++;
        const container = document.getElementById('modules-container');

        const html = `
            <div class="module-list-item" data-module-id="new-\${moduleCounter}">
                <div class="module-header">
                    <h5 style="margin:0; color:#334155;" class="module-order-label">Module N°</h5>
                    <button type="button" class="btn-remove" onclick="removeModule(this)" title="Supprimer">
                        <i class="fa fa-trash"></i>
                    </button>
                </div>
                <div class="form-group">
                    <label>Titre du Module</label>
                    <input type="text" name="moduleTitles" class="form-control" required placeholder="Ex: Introduction au Java">
                </div>
                <div class="form-group" style="margin-bottom:0;">
                    <label>Détails / Contenu</label>
                    <textarea name="moduleDetails" class="form-control" rows="2" required placeholder="Contenu détaillé..."></textarea>
                </div>
            </div>
        `;

        container.insertAdjacentHTML('beforeend', html);
        renumberModules();
    }

    function removeModule(buttonElement) {
        const moduleElement = buttonElement.closest('.module-list-item');
        if (moduleElement) {
            moduleElement.remove();
            renumberModules();
        }
    }

    function renumberModules() {
        const modules = document.querySelectorAll('#modules-container .module-list-item');
        modules.forEach((module, index) => {
            const label = module.querySelector('.module-order-label');
            if (label) {
                label.innerText = 'Module ' + (index + 1);
            }
        });
    }

    function showConfirmModal() {
        const form = document.getElementById("editFormationForm");
        const moduleCount = document.querySelectorAll('#modules-container .module-list-item').length;

        if (moduleCount === 0) {
            alert("Veuillez ajouter au moins un module au programme.");
            return;
        }

        if (form.checkValidity()) {
            document.getElementById("confirmModal").style.display = "flex";
        } else {
            form.reportValidity();
        }
    }

    function submitFormationForm() {
        renumberModules();
        document.getElementById("editFormationForm").submit();
    }

    function closeConfirmModal() { 
        document.getElementById("confirmModal").style.display = "none"; 
    }

    window.onclick = function(e) {
        if(e.target == document.getElementById('confirmModal')) closeConfirmModal();
    }

    document.addEventListener('DOMContentLoaded', renumberModules);
</script>

</body>
</html>