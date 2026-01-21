<%@ page import="com.projetjee.model.User" %>
<%@ page import="com.projetjee.dao.AdminDashboardDAO" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }


    AdminDashboardDAO dashboardDAO = new AdminDashboardDAO();
    int studentCount = dashboardDAO.getCountUsersByRole("STUDENT");
    int trainerCount = dashboardDAO.getCountUsersByRole("FORMATEUR");
    int formationCount = dashboardDAO.getCountFormations();
    BigDecimal totalRevenue = dashboardDAO.getTotalRevenue();
%>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="utf-8">
    <title>FormaPRO - Tableau de Bord Moderne</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <link href="../css/admin_dashboard.css" rel="stylesheet">

    <script
            src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.8.5/dist/dotlottie-wc.js"
            type="module"></script>

    <style>

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
            border-left: 5px solid #112958;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .welcome-text span {
            color: #112958;
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

<jsp:include page="sidebar.jsp" />

<div class="main-content">

    <jsp:include page="header.jsp">
        <jsp:param name="pageTitle" value="Dashboard" />
    </jsp:include>

    <main>
        <div class="cards">
            <div class="card-single">
                <div>
                    <h1><%= studentCount %></h1>
                    <span>Total Étudiants</span>
                </div>
                <div>
                    <i class="fa fa-users icon-large"></i>
                </div>
            </div>

            <div class="card-single">
                <div>
                    <h1><%= trainerCount %></h1>
                    <span>Total Formateurs</span>
                </div>
                <div>
                    <i class="fa fa-chalkboard-teacher icon-large"></i>
                </div>
            </div>

            <div class="card-single">
                <div>
                    <h1><%= formationCount %></h1>
                    <span>Total Formations</span>
                </div>
                <div>
                    <i class="fa fa-graduation-cap icon-large"></i>
                </div>
            </div>

            <div class="card-single">
                <div>
                    <h1><%= totalRevenue %> TND</h1>
                    <span>Total Revenus</span>
                </div>
                <div>
                    <i class="fa fa-wallet icon-large"></i>
                </div>
            </div>
        </div>

        <div class="dashboard-split">

            <div class="lottie-container">
                <dotlottie-wc
                        src="https://lottie.host/99ed5be8-955f-4ee3-af50-9f0b8c87089a/E8bahzVIwY.lottie"
                        style="width: 600px;height: 600px"
                        autoplay
                        loop></dotlottie-wc>
            </div>

            <div class="welcome-text-container">
                <p class="welcome-text">
                    Welcome, <span>Admin Dashboard</span>. <br>
                    Gérez tous les aspects de la plateforme FormaPRO ici.
                </p>
            </div>

        </div>
    </main>


</div>

</body>
</html>