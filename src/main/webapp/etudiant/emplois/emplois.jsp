<%@ page import="com.projetjee.model.User" %>
<%@ page import="com.projetjee.model.Reservation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Locale" %>
<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"STUDENT".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Récupérer les sessions futures de l'étudiant
    List<Reservation> futureSessions = (List<Reservation>) request.getAttribute("futureSessions");

    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, dd/MM/yyyy", Locale.FRENCH);

    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Emploi du Temps</title>
    <link href="../../css/admin_dashboard.css" rel="stylesheet">
    <link href="../../css/etudiant_dashbaord.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #10b988; color: white; }
        tr:nth-child(even) { background-color: #f9fafb; }
        .badge { padding: 5px 10px; border-radius: 20px; font-weight: 600; color: white; }
        .badge-room { background-color: #2563eb; }
        .badge-time { background-color: #10b981; }
        .badge-formation { background-color: #f59e0b; }
    </style>
</head>
<body>

<jsp:include page="../sidebar.jsp" />
<div class="main-content">
    <jsp:include page="../header.jsp" />

    <main>
        <h2>Mon Emploi du Temps : Sessions Futures</h2>

        <div class="card">
            <div class="card-body">
                <table>
                    <thead>
                    <tr>
                        <th>Formation</th>
                        <th>Salle</th>
                        <th>Date</th>
                        <th>Heure</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (futureSessions == null || futureSessions.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="4" style="text-align:center;">Aucune session future trouvée pour vos formations.</td>
                    </tr>
                    <%
                    } else {
                        for (Reservation r : futureSessions) {
                    %>
                    <tr>
                        <td><span class="badge badge-formation"><%= r.getFormationNom() %></span></td>
                        <td><span class="badge badge-room"><%= r.getRoomName() %></span></td>
                        <td><%= dateFormat.format(r.getStartTime()) %></td>
                        <td><span class="badge badge-time"><%= timeFormat.format(r.getStartTime()) %> - <%= timeFormat.format(r.getEndTime()) %></span></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

</body>
</html>