<%@ page import="com.projetjee.model.User" %>
<%@ page import="com.projetjee.dao.UserDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"STUDENT".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>FormaPRO - Tableau de Bord Étudiant</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <link href="../css/admin_dashboard.css" rel="stylesheet">
    <link href="../css/etudiant_dashboard.css" rel="stylesheet">

    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.8.5/dist/dotlottie-wc.js" type="module"></script>

    <style>
        :root {
            --primary-color: #10b981;
        }

        .dashboard-split {
            display: flex;
            gap: 30px;
            margin-top: 40px;
            align-items: center;
        }

        .lottie-container {
            width: 50%;
            display: flex;
            justify-content: center;
        }

        .welcome-text-container {
            width: 50%;
            padding: 20px;
        }

        .welcome-text {
            font-size: 2.5rem;
            font-weight: 700;
            color: #334155;
            line-height: 1.2;
            padding: 10px;
            border-left: 5px solid var(--primary-color);
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .welcome-text span {
            color: var(--primary-color);
        }

        @media (max-width: 1024px) {
            .dashboard-split {
                flex-direction: column;
            }
            .lottie-container, .welcome-text-container {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<div class="wrapper">

    <jsp:include page="sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="header.jsp">
            <jsp:param name="pageTitle" value="Tableau de bord" />
        </jsp:include>

        <main>
            <h2 style="color: var(--primary-color);">Bienvenue, <%= user.getFirstName() %>!</h2>

            <div class="dashboard-split">
                <div class="lottie-container">
                    <dotlottie-wc
                        src="https://lottie.host/2fdde984-8e7c-403d-b19c-e8104120e33b/fvMwKTxgPF.lottie"
                        style="width: 600px;height: 600px"
                        autoplay
                        loop>
                    </dotlottie-wc>
                </div>

                <div class="welcome-text-container">
                    <p class="welcome-text">
                        Bienvenue sur votre <span>Espace Étudiant</span>. <br>
                        Consultez votre emploi du temps et suivez vos progrès.
                    </p>
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
            <a href="<%= request.getContextPath() %>/logout" class="btn-modal btn-confirm" style="background-color: #ef4444;">Déconnexion</a>
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