<%@ page import="com.projetjee.model.User" %>
<%@ page import="com.projetjee.model.Reservation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"FORMATEUR".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    LocalDate startDate = (LocalDate) request.getAttribute("startDate");
    LocalDate endDate = (LocalDate) request.getAttribute("endDate");

    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, dd/MM/yyyy", Locale.FRENCH);
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Emploi du Temps - 14 Jours</title>
    <link href="../../css/admin_dashboard.css" rel="stylesheet">
    <link href="../../css/formateur_dashboard.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #3b82f6; color: white; }
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
        <h2>Emploi du Temps de <%= user.getFirstName() %> : Du <%= startDate %> au <%= endDate %></h2>

        <div class="card">
            <div class="card-body">
                <table>
                    <thead>
                        <tr>
                            <th>Formation / Session</th>
                            <th>Salle</th>
                            <th>Date</th>
                            <th>Heure</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (reservations == null || reservations.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="4" style="text-align:center;">Aucune session trouvée dans les 14 jours à venir.</td>
                            </tr>
                        <%
                            } else {
                                for (Reservation r : reservations) {
                        %>
                            <tr>
                                <td><span class="badge badge-formation"><%= r.getFormationNom() %></span></td>
                                <td><span class="badge badge-room"><%= r.getRoomName() %></span></td>
                                <td><%= dateFormat.format(r.getStartTime()) %></td>
                                <td>
                                    <span class="badge badge-time">
                                        <%= timeFormat.format(r.getStartTime()) %> - <%= timeFormat.format(r.getEndTime()) %>
                                    </span>
                                </td>
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