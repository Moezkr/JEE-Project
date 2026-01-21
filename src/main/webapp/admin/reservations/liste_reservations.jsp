<%@ page import="com.projetjee.model.User" %>
<%@ page import="com.projetjee.model.Room" %>
<%@ page import="com.projetjee.model.Reservation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<User> formateurs = (List<User>) request.getAttribute("formateurs");
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");

    if (formateurs == null) formateurs = new java.util.ArrayList<>();
    if (reservations == null) reservations = new java.util.ArrayList<>();

    String selectedDate = (String) request.getAttribute("selectedDate");
    Integer selectedFormateurId = (Integer) request.getAttribute("selectedFormateurId");
    if (selectedFormateurId == null) selectedFormateurId = -1;

    java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("HH:mm");
    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy");
    String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());

    String error = request.getParameter("error");
    String success = request.getParameter("success");
    String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>FormaPRO - Liste des Réservations</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="../../css/admin_dashboard.css" rel="stylesheet">

    <style>
        .filter-card { padding: 20px; background: #fff; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .filter-form { display: flex; gap: 20px; align-items: flex-end; }
        .filter-group { flex: 1; }
        .filter-group label { font-weight: 600; color: #1e293b; margin-bottom: 5px; display: block; font-size: 0.9rem; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #e2e8f0; border-radius: 6px; }
        .btn-filter { padding: 10px 20px; background-color: #112958; color: white; border: none; border-radius: 6px; cursor: pointer; }
        .btn-filter:hover { background-color: #ffc107; color: #112958; }

        .btn-action { padding: 8px 12px; background-color: #ef4444; color: white; border: none; border-radius: 6px; cursor: pointer; transition: 0.3s; }
        .btn-action:hover { background-color: #dc2626; }

        .toast-notification {
            position: fixed; bottom: 20px; right: 20px; z-index: 9999;
            padding: 15px 25px; border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            display: flex; align-items: center; justify-content: space-between;
            min-width: 300px; animation: slideInRight 0.5s ease-out forwards;
        }
        .toast-success { background-color: #d1fae5; color: #065f46; border-left: 5px solid #10b981; }
        .toast-error { background-color: #fee2e2; color: #991b1b; border-left: 5px solid #ef4444; }

        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>

<body>

<jsp:include page="../sidebar.jsp" />

<div class="main-content">
    <jsp:include page="../header.jsp">
        <jsp:param name="pageTitle" value="Liste des Réservations" />
    </jsp:include>

    <main>
        <%
            if (error != null || success != null) {
                String toastClass = (error != null) ? "toast-error" : "toast-success";
                String iconClass = (error != null) ? "fa-exclamation-circle" : "fa-check-circle";
                String displayMsg = (msg != null) ? java.net.URLDecoder.decode(msg, "UTF-8") : (error != null ? "Erreur inconnue." : "Opération réussie !");
        %>
            <div id="toastNotification" class="toast-notification <%= toastClass %>">
                <div style="display:flex; align-items:center;">
                    <i class="fa <%= iconClass %> mr-3" style="font-size: 1.2rem; margin-right: 10px;"></i>
                    <span><%= displayMsg %></span>
                </div>
                <span style="cursor:pointer; margin-left:20px; font-weight:bold;" onclick="this.parentElement.style.display='none'">&times;</span>
            </div>
        <% } %>

        <div class="filter-card">
            <form action="<%= request.getContextPath() %>/admin/reservations/liste_reservations" method="get" class="filter-form">
                <div class="filter-group">
                    <label for="filterDate">Jour</label>
                    <input type="date" id="filterDate" name="date" class="form-control"
                           value="<%= selectedDate != null ? selectedDate : today %>">
                </div>

                <div class="filter-group">
                    <label for="filterTrainer">Formateur</label>
                    <select id="filterTrainer" name="formateurId" class="form-control">
                        <option value="-1" <%= (selectedFormateurId == -1) ? "selected" : "" %>>
                            -- Tous les formateurs --
                        </option>
                        <% for (User t : formateurs) {
                            boolean isSelected = (selectedFormateurId != -1 && selectedFormateurId.equals(t.getId()));
                        %>
                            <option value="<%= t.getId() %>" <%= isSelected ? "selected" : "" %>>
                                <%= t.getFirstName() %> <%= t.getLastName() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="filter-group">
                    <button type="submit" class="btn-filter">
                        <i class="fa fa-filter"></i> Filtrer
                    </button>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header">
                <h3>
                    Planning Salle pour le
                    <%= selectedDate != null ? dateFormat.format(java.sql.Date.valueOf(selectedDate))
                            : dateFormat.format(java.sql.Date.valueOf(today)) %>
                </h3>
            </div>

            <div class="card-body">
                <table width="100%">
                    <thead>
                        <tr>
                            <td>Salle</td>
                            <td>Formation</td>
                            <td>Formateur</td>
                            <td>Début</td>
                            <td>Fin</td>
                            <td>Action</td>
                        </tr>
                    </thead>

                    <tbody>
                        <% if (reservations.isEmpty()) { %>
                            <tr>
                                <td colspan="6" style="text-align:center; padding:20px;">
                                    Aucune réservation trouvée pour ces critères.
                                </td>
                            </tr>
                        <% } else {
                            for (Reservation res : reservations) {
                                int reservationId = res.getId();
                                String roomName = res.getRoomName();
                                String startTime = timeFormat.format(res.getStartTime());
                        %>
                            <tr>
                                <td><%= roomName %></td>
                                <td><%= res.getFormationNom() %></td>
                                <td><%= res.getUserName() %></td>
                                <td><%= startTime %></td>
                                <td><%= timeFormat.format(res.getEndTime()) %></td>
                                <td>
                                    <% if (res.getEndTime().after(new java.util.Date())) { %>
                                        <button class="btn-action"
                                                onclick="confirmAnnulation(<%= reservationId %>, '<%= roomName %>', '<%= startTime %>')">
                                            <i class="fa fa-times"></i> Annuler
                                        </button>
                                    <% } else { %>
                                        —
                                    <% } %>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="cancelModal" class="modal">
            <div class="modal-content" style="width: 450px; text-align: left;">
                <div class="modal-header" style="border-bottom: none;">
                    <h3 style="color: var(--primary-color);"><i class="fa fa-exclamation-triangle"></i> Confirmer Annulation</h3>
                </div>
                <div class="modal-body" style="padding-top: 0;">
                    <p>Êtes-vous sûr de vouloir annuler la réservation suivante ?</p>
                    <p style="font-weight: 600; margin-top: 10px;">Salle: <span id="modalRoomName"></span></p>
                    <p style="font-weight: 600;">Début: <span id="modalStartTime"></span></p>

                    <form id="deleteForm" action="<%= request.getContextPath() %>/admin/reservations/liste_reservations" method="get" style="margin-top: 20px;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="reservationId" id="modalReservationId">
                        <div class="modal-footer" style="justify-content: flex-end;">
                            <button type="button" class="btn-modal btn-cancel" onclick="closeCancelModal()">Non</button>
                            <button type="submit" class="btn-modal btn-confirm btn-action" style="background-color: var(--danger);">Oui, Annuler</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    const modal = document.getElementById('cancelModal');
    const modalRoomName = document.getElementById('modalRoomName');
    const modalStartTime = document.getElementById('modalStartTime');
    const modalReservationId = document.getElementById('modalReservationId');

    function confirmAnnulation(reservationId, roomName, startTime) {
        modalReservationId.value = reservationId;
        modalRoomName.innerText = roomName;
        modalStartTime.innerText = startTime;
        modal.style.display = 'flex';
    }

    function closeCancelModal() {
        modal.style.display = 'none';
    }

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        var toast = document.getElementById("toastNotification");
        if(toast) {
            setTimeout(function() {
                toast.style.transition = "opacity 0.5s ease";
                toast.style.opacity = "0";
                setTimeout(function(){ toast.style.display = "none"; }, 500);
            }, 5000);
        }
    });
</script>

</body>
</html>