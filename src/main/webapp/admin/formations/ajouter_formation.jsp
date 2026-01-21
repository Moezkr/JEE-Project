<%@ page import="com.projetjee.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("../../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>FormaPRO - Ajouter une Formation</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="../../css/admin_dashboard.css" rel="stylesheet">

    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.8.5/dist/dotlottie-wc.js" type="module"></script>

    <style>
        .form-container { max-width: 900px; margin: 0 auto; }
        .form-group label { font-weight: 600; color: #1e293b; margin-bottom: 8px; display: block; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 20px; }
        .btn-submit { background-color: #112958; color: white; padding: 12px 30px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; width: 100%; }
        .btn-submit:hover { background-color: #ffc107; color: #112958; }
        .btn-back { color: #64748b; text-decoration: none; margin-right: 15px; font-weight: 600; }

        .module-card {
            background: #f8f9fa;
            border: 1px solid #e2e8f0;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            position: relative;
            animation: fadeIn 0.3s ease;
        }

        .module-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 10px;
        }

        .btn-add-module {
            background-color: #e0f2fe;
            color: #0369a1;
            border: 1px dashed #0369a1;
            width: 100%;
            padding: 15px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-add-module:hover { background-color: #bae6fd; }
        .btn-remove { color: #ef4444; background: none; border: none; cursor: pointer; font-size: 1.1rem; }

        @keyframes fadeIn { 
            from { opacity: 0; transform: translateY(10px); } 
            to { opacity: 1; transform: translateY(0); } 
        }

        .content-split { display: flex; gap: 30px; align-items: flex-start; padding: 20px 0; }
        .form-container { max-width: 100%; width: 50%; margin: 0; }
        .lottie-container { width: 50%; padding-top: 50px; display: flex; justify-content: center; align-items: flex-start; }

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
        <jsp:param name="pageTitle" value="Ajouter une Formation" />
    </jsp:include>

    <main>
        <div class="content-split">
            <div class="card form-container">
                <div class="card-header">
                    <h3>Nouvelle Formation</h3>
                    <a href="/admin/formations/ajouter" class="btn-back"><i class="fa fa-arrow-left"></i> Retour</a>
                </div>

                <div class="card-body">
                    <% String error = request.getParameter("error"); if(error != null) { %>
                        <div style="color: #ef4444; background:#fee2e2; padding:10px; border-radius:6px; margin-bottom:20px;">
                            <i class="fa fa-exclamation-circle"></i> Une erreur est survenue (Vérifiez les champs).
                        </div>
                    <% } %>

                    <form id="addFormationForm" action="<%= request.getContextPath() %>/admin/formations/ajouter" method="post">
                        <h4 class="mb-3" style="color:#112958;">Informations Générales</h4>

                        <div class="form-group">
                            <label>Nom de la formation</label>
                            <input type="text" name="nom" class="form-control" required placeholder="Ex: Développement Web Fullstack">
                        </div>

                        <div class="form-group">
                            <label>Description</label>
                            <textarea name="description" class="form-control" rows="3" required placeholder="Une brève description du cours..."></textarea>
                        </div>

                        <div class="row" style="display:flex; gap:20px;">
                            <div class="form-group" style="flex:1;">
                                <label>Prix (TND)</label>
                                <input type="number" name="prix" class="form-control" required placeholder="Ex: 1200">
                            </div>
                            <div class="form-group" style="flex:1;">
                                <label>Durée (Mois)</label>
                                <input type="number" name="duree" class="form-control" required placeholder="Ex: 4">
                            </div>
                        </div>

                        <hr style="margin: 30px 0; border: 0; border-top: 1px solid #e2e8f0;">

                        <h4 class="mb-3" style="color:#112958;">Programme de la Formation</h4>
                        <p style="color:#64748b; font-size:0.9rem; margin-bottom:20px;">Ajoutez les modules (chapitres) qui seront enseignés.</p>

                        <div id="modules-container"></div>

                        <button type="button" class="btn-add-module" onclick="addModule()">
                            <i class="fa fa-plus-circle mr-2"></i> Ajouter un Module
                        </button>

                        <div style="margin-top: 40px;">
                            <button type="submit" class="btn-submit">
                                <i class="fa fa-save mr-2"></i> Enregistrer la Formation
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="lottie-container">
                <dotlottie-wc
                    src="https://lottie.host/f5df20bb-a88b-47e0-8113-dcaa210d393e/FiGQbIdJFV.lottie"
                    style="width: 600px; height: 600px"
                    autoplay
                    loop>
                </dotlottie-wc>
            </div>
        </div>
    </main>
</div>

<script>
    let moduleCount = 0;

    function addModule() {
        moduleCount++;
        const container = document.getElementById('modules-container');

        const html = `
            <div class="module-card" id="module-\${moduleCount}">
                <div class="module-header">
                    <h5 style="margin:0; color:#334155;">Module \${moduleCount}</h5>
                    <button type="button" class="btn-remove" onclick="removeModule(\${moduleCount})" title="Supprimer">
                        <i class="fa fa-trash"></i>
                    </button>
                </div>
                <div class="form-group">
                    <label>Titre du Module</label>
                    <input type="text" name="moduleTitles" class="form-control" placeholder="Ex: Introduction au Java" required>
                </div>
                <div class="form-group" style="margin-bottom:0;">
                    <label>Détails / Contenu</label>
                    <textarea name="moduleDetails" class="form-control" rows="2" placeholder="Ex: Installation JDK, Variables, Boucles..." required></textarea>
                </div>
            </div>
        `;

        container.insertAdjacentHTML('beforeend', html);
    }

    function removeModule(id) {
        const element = document.getElementById('module-' + id);
        if (element) {
            element.remove();
        }
    }

    window.onload = function() {
        if (moduleCount === 0) {
            addModule();
        }
    };
</script>

</body>
</html>