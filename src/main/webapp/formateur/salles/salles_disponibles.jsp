<%@ page import="com.projetjee.model.User" %>
<%@ page import="com.projetjee.model.Room" %>
<%@ page import="com.projetjee.model.Reservation" %>
<%@ page import="com.projetjee.model.Formation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.DayOfWeek" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"FORMATEUR".equals(user.getRole()) && !"ADMIN".equals(user.getRole()))) {
        response.sendRedirect("../../login.jsp");
        return;
    }

    List<Room> allRooms = (List<Room>) request.getAttribute("allRooms");
    List<Reservation> futureReservations = (List<Reservation>) request.getAttribute("futureReservations");
    List<Reservation> userReservations = (List<Reservation>) request.getAttribute("userReservations");
    List<Formation> userFormations = (List<Formation>) request.getAttribute("userFormations");

    Locale localeFr = Locale.FRENCH;
    DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    DateTimeFormatter timeFormat = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter jsDateTimeFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS");
    DateTimeFormatter displayDateTimeFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    LocalTime startHourLimit = LocalTime.of(8, 0);
    LocalTime endHourLimit = LocalTime.of(18, 0);
    LocalTime lastReservableStartHour = LocalTime.of(17, 0);

    LocalDateTime now = LocalDateTime.now();
    LocalDateTime today = now.truncatedTo(ChronoUnit.DAYS);

    String minDateStr = today.format(dateFormat);
    String maxDateStr = today.plusDays(13).format(dateFormat);

    LocalDateTime[] days = new LocalDateTime[14];
    for(int i = 0; i < 14; i++) {
        days[i] = today.plusDays(i);
    }

    String error = request.getParameter("error");
    String success = request.getParameter("success");
    String msg = request.getParameter("msg");

    StringBuilder jsonReservations = new StringBuilder("[");
    if (futureReservations != null) {
        boolean first = true;
        for (Reservation res : futureReservations) {
            if (!first) jsonReservations.append(",");
            jsonReservations.append("{");
            jsonReservations.append("\"roomId\": ").append(res.getRoomId()).append(",");
            jsonReservations.append("\"startTime\": \"").append(res.getStartTime().toLocalDateTime().format(jsDateTimeFormat)).append("\",");
            jsonReservations.append("\"endTime\": \"").append(res.getEndTime().toLocalDateTime().format(jsDateTimeFormat)).append("\"");
            jsonReservations.append("}");
            first = false;
        }
    }
    jsonReservations.append("]");

    String selectedRoomId = request.getParameter("roomId");
    if (selectedRoomId == null) selectedRoomId = (String) request.getAttribute("selectedRoomId");
    if (selectedRoomId == null) selectedRoomId = "";
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>FormaPRO - Réserver Salle</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="../../css/admin_dashboard.css" rel="stylesheet">
    <link href="../../css/formateur_dashboard.css" rel="stylesheet">

    <style>
        .full-width-form-container { width: 100%; margin-bottom: 2rem; }
        .form-card, .list-card, .calendar-card { box-shadow: 0 4px 12px rgba(106, 13, 173, 0.1); }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; color: var(--text-dark); }
        .form-control, select.form-control, input.form-control[type="date"] { width: 100%; padding: 10px; border: 1px solid #e2e8f0; border-radius: 8px; box-sizing: border-box; line-height: normal; }
        .form-row { display: flex; gap: 15px; }
        .form-row > div { flex: 1; }
        .reservation-inputs { display: grid; grid-template-columns: repeat(5, 1fr); gap: 15px; }
        .btn-reserve { background-color: var(--primary-color); color: var(--white); padding: 12px 25px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s; float: right; }
        .btn-reserve:hover { background-color: #4b0082; }
        .availability-table { border-collapse: collapse; width: 100%; table-layout: fixed; font-size: 0.9rem; }
        .availability-table th, .availability-table td { border: 1px solid #e2e8f0; text-align: center; padding: 5px; }
        .availability-table th { background-color: #f7f6fb; color: var(--primary-color); font-weight: 600; }
        .hour-header { width: 60px; background-color: #e0e7ff !important; font-weight: 700; }
        .available { background-color: #d1fae5; }
        .reserved { background-color: #fee2e2; color: #991b1b; font-weight: 500; }
        .past-slot { background-color: #f3f4f6; color: #6b7280; font-weight: 400; }
        .toast-notification { position: fixed; bottom: 20px; right: 20px; z-index: 9999; padding: 15px 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; justify-content: space-between; min-width: 300px; animation: slideInRight 0.5s ease-out forwards; }
        .toast-success { background-color: #d1fae5; color: #065f46; border-left: 5px solid #10b981; }
        .toast-error { background-color: #fee2e2; color: #991b1b; border-left: 5px solid #ef4444; }
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>

<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="../header.jsp">
            <jsp:param name="pageTitle" value="Réservation de Salles" />
        </jsp:include>

        <main>
            <div class="full-width-form-container card form-card">
                <div class="card-header">
                    <h3><i class="fa fa-clock"></i> Réserver une Salle</h3>
                </div>
                <div class="card-body">
                    <form id="newReservationForm" action="<%= request.getContextPath() %>/formateur/salles" method="post" onsubmit="return validateNewReservationForm()">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="endDateTime" id="formEndDateTime">

                        <div class="reservation-inputs">
                            <div class="form-group">
                                <label for="formationSelect">Choisir la formation</label>
                                <select id="formationSelect" name="formationId" class="form-control" onchange="checkReservationInputs();" required>
                                    <option value="">-- Sélectionnez une formation --</option>
                                    <% if (userFormations != null) {
                                        for (Formation formation : userFormations) { %>
                                        <option value="<%= formation.getId() %>"><%= formation.getNom() %></option>
                                    <% }} %>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="roomFilter">Choisir la salle</label>
                                <select id="roomFilter" name="roomId" class="form-control" onchange="checkReservationInputs(); displayCalendar(this.value);" required>
                                    <option value="">-- Sélectionnez une salle --</option>
                                    <% if (allRooms != null) {
                                        for (Room room : allRooms) {
                                            String selected = (selectedRoomId.equals(String.valueOf(room.getId()))) ? "selected" : ""; %>
                                        <option value="<%= room.getId() %>" <%= selected %>><%= room.getName() %> (<%= room.getCapacity() %> places)</option>
                                    <% }} %>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="startDate">Date de début</label>
                                <input type="date" id="startDate" name="startDate" class="form-control" min="<%= minDateStr %>" max="<%= maxDateStr %>" value="<%= minDateStr %>" onchange="checkReservationInputs();" required />
                            </div>

                            <div class="form-group">
                                <label for="startHour">Heure de début</label>
                                <select id="startHour" name="startHour" class="form-control" onchange="checkReservationInputs();" required>
                                    <% LocalTime hour = startHourLimit;
                                    while (hour.isBefore(endHourLimit)) {
                                        String timeStr = hour.format(timeFormat);
                                        String selected = (hour.getHour() == 8) ? "selected" : ""; %>
                                        <option value="<%= hour.getHour() %>" <%= selected %>><%= timeStr %></option>
                                    <% hour = hour.plusHours(1); } %>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="durationHours">Durée (Max 3h)</label>
                                <select id="durationHours" name="durationHours" class="form-control" onchange="updateDurationMax(); checkReservationInputs();" required>
                                    <option value="1" selected>1 heure</option>
                                    <option value="2">2 heures</option>
                                    <option value="3">3 heures</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group" style="flex: 1; text-align: right;">
                                <button type="submit" id="btnReserve" class="btn-reserve" disabled><i class="fa fa-save"></i> Réserver</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div id="reservationCalendar" class="card calendar-card" style="<%= selectedRoomId.isEmpty() ? "display: none;" : "display: block;" %>">
                <div class="card-header">
                    <h3><i class="fa fa-calendar-check"></i> Créneaux Disponibles (14 Jours)</h3>
                </div>
                <div class="card-body" style="overflow-x: auto; max-height: 70vh;">
                    <table class="availability-table" id="calendarTable">
                        <thead>
                            <tr>
                                <th class="hour-header">Heure</th>
                                <% for(LocalDateTime day : days) {
                                    String dayName = day.getDayOfWeek().getDisplayName(TextStyle.SHORT, localeFr); %>
                                    <th><%= dayName %> <%= day.format(DateTimeFormatter.ofPattern("dd/MM")) %></th>
                                <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% LocalTime currentTime = startHourLimit;
                            while (currentTime.isBefore(endHourLimit)) {
                                LocalTime nextTime = currentTime.plusHours(1);
                                String timeSlot = currentTime.format(timeFormat);
                                String nextTimeSlot = nextTime.format(timeFormat); %>
                                <tr data-start-time="<%= timeSlot %>" data-end-time="<%= nextTimeSlot %>">
                                    <td class="hour-header"><%= timeSlot %> - <%= nextTimeSlot %></td>
                                    <% for(LocalDateTime day : days) {
                                        String dateStr = day.format(dateFormat); %>
                                        <td data-date="<%= dateStr %>" class="past-slot"></td>
                                    <% } %>
                                </tr>
                            <% currentTime = nextTime; } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card list-card" style="margin-top: 2rem;">
                <div class="card-header">
                    <h3><i class="fa fa-list-alt"></i> Mes Réservations</h3>
                </div>
                <div class="card-body">
                    <% if (userReservations != null && !userReservations.isEmpty()) { %>
                        <table width="100%">
                            <thead>
                                <tr>
                                    <th>Salle</th>
                                    <th>Début</th>
                                    <th>Fin</th>
                                    <th>Statut</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% Timestamp timestampNow = new Timestamp(System.currentTimeMillis());
                                for (Reservation res : userReservations) {
                                    boolean isPast = res.getEndTime().before(timestampNow);
                                    LocalDateTime start = res.getStartTime().toLocalDateTime();
                                    LocalDateTime end = res.getEndTime().toLocalDateTime(); %>
                                    <tr>
                                        <td><%= res.getRoomName() %></td>
                                        <td><%= start.format(displayDateTimeFormat) %></td>
                                        <td><%= end.format(displayDateTimeFormat) %></td>
                                        <td><span class="badge <%= isPast ? "warning" : "success" %>"><%= isPast ? "Passée" : "À Venir" %></span></td>
                                        <td>
                                            <% if (!isPast) { %>
                                                <button class="btn-annuler btn" onclick="confirmAnnulation(<%= res.getId() %>, '<%= res.getRoomName() %>', '<%= start.format(displayDateTimeFormat) %>')">
                                                    <i class="fa fa-times"></i> Annuler
                                                </button>
                                            <% } else { %> — <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } else { %>
                        <p style="text-align: center; padding: 20px;">Vous n'avez aucune réservation enregistrée.</p>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</div>

<% if (error != null || success != null) {
    String toastClass = (error != null) ? "toast-error" : "toast-success";
    String iconClass = (error != null) ? "fa-exclamation-circle" : "fa-check-circle";
    String displayMsg = (msg != null) ? java.net.URLDecoder.decode(msg, "UTF-8") : (error != null ? "Erreur inconnue." : "Opération réussie !"); %>
    <div id="toastNotification" class="toast-notification <%= toastClass %>">
        <div style="display:flex; align-items:center;">
            <i class="fa <%= iconClass %> mr-3" style="font-size: 1.2rem; margin-right: 10px;"></i>
            <span><%= displayMsg %></span>
        </div>
        <span style="cursor:pointer; margin-left:20px; font-weight:bold;" onclick="this.parentElement.style.display='none'">&times;</span>
    </div>
<% } %>

<div id="cancelModal" class="modal">
    <div class="modal-content" style="width: 450px; text-align: left;">
        <div class="modal-header" style="border-bottom: none;">
            <h3><i class="fa fa-exclamation-triangle"></i> Confirmer Annulation</h3>
        </div>
        <div class="modal-body">
            <p>Êtes-vous sûr de vouloir annuler la réservation suivante ?</p>
            <p style="font-weight: 600; margin-top: 10px;">Salle: <span id="modalRoomName"></span></p>
            <p style="font-weight: 600;">Début: <span id="modalStartTime"></span></p>
            <form id="deleteForm" action="<%= request.getContextPath() %>/formateur/salles" method="get" style="margin-top: 20px;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="reservationId" id="modalReservationId">
                <div class="modal-footer" style="justify-content: flex-end;">
                    <button type="button" class="btn-modal btn-cancel" onclick="closeCancelModal()">Non</button>
                    <button type="submit" class="btn-modal btn-confirm btn-annuler" style="background-color: var(--danger);">Oui, Annuler</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    const allReservations = JSON.parse('<%= jsonReservations.toString().replace("\\", "\\\\") %>');
    const calendarTable = document.getElementById('calendarTable');
    const reservationCalendar = document.getElementById('reservationCalendar');
    const roomFilter = document.getElementById('roomFilter');
    const startDateInput = document.getElementById('startDate');
    const startHourSelect = document.getElementById('startHour');
    const durationHoursSelect = document.getElementById('durationHours');
    const formationSelect = document.getElementById('formationSelect');
    const formEndDateTime = document.getElementById('formEndDateTime');
    const btnReserve = document.getElementById('btnReserve');

    function showCustomToastError(message) {
        const toastMessage = message || "Erreur de validation.";
        let toast = document.getElementById('toastNotification');
        if (toast) toast.remove();
        toast = document.createElement('div');
        toast.id = 'toastNotification';
        toast.classList.add('toast-notification', 'toast-error');
        toast.innerHTML = `
            <div style="display:flex; align-items:center;">
                <i class="fa fa-exclamation-circle mr-3" style="font-size: 1.2rem; margin-right: 10px;"></i>
                <span id="toastTextContainer"></span>
            </div>
            <span style="cursor:pointer; margin-left:20px; font-weight:bold;" onclick="this.parentElement.remove()">&times;</span>
        `;
        const textContainer = toast.querySelector('#toastTextContainer');
        if (textContainer) textContainer.appendChild(document.createTextNode(toastMessage));
        document.body.appendChild(toast);
        setTimeout(() => {
            toast.style.transition = "opacity 0.5s ease";
            toast.style.opacity = "0";
            setTimeout(() => { toast.remove(); }, 500);
        }, 5000);
    }

    function updateDurationMax() {
        const startHour = parseInt(startHourSelect.value);
        const durationLimit = Math.min(3, 18 - startHour);
        const currentDuration = parseInt(durationHoursSelect.value);
        durationHoursSelect.innerHTML = '';
        for (let i = 1; i <= 3; i++) {
            const option = document.createElement('option');
            option.value = i;
            option.text = i + (i > 1 ? ' heures' : ' heure');
            if (i > durationLimit) {
                option.disabled = true;
                option.text += ' (Max 18h)';
            }
            if (i === currentDuration && i <= durationLimit) option.selected = true;
            durationHoursSelect.appendChild(option);
        }
        if (currentDuration > durationLimit) durationHoursSelect.value = durationLimit || 1;
    }

    function updateEndDateTime() {
        const dateStr = startDateInput.value;
        const startHour = startHourSelect.value;
        const duration = parseInt(durationHoursSelect.value);
        if (!dateStr || !startHour || !duration) return;
        const start = new Date(dateStr + 'T' + String(startHour).padStart(2, '0') + ':00');
        const end = new Date(start.getTime() + duration * 60 * 60 * 1000);
        formEndDateTime.value = `\${end.getFullYear()}-\${String(end.getMonth() + 1).padStart(2, '0')}-\${String(end.getDate()).padStart(2, '0')}T\${String(end.getHours()).padStart(2, '0')}:\${String(end.getMinutes()).padStart(2, '0')}`;
    }

    function checkReservationInputs() {
        updateDurationMax();
        updateEndDateTime();
        const start = new Date(startDateInput.value + 'T' + String(startHourSelect.value).padStart(2, '0') + ':00');
        btnReserve.disabled = (!formationSelect.value || !roomFilter.value || isNaN(start.getTime()) || start < new Date());
        displayCalendar(roomFilter.value);
    }

    function validateNewReservationForm() {
        const start = new Date(startDateInput.value + 'T' + String(startHourSelect.value).padStart(2, '0') + ':00');
        const end = new Date(start.getTime() + parseInt(durationHoursSelect.value) * 60 * 60 * 1000);
        const conflict = allReservations.find(res => res.roomId == roomFilter.value && start < new Date(res.endTime) && end > new Date(res.startTime));
        if (conflict) {
            showCustomToastError('La salle est déjà réservée. Veuillez choisir un autre créneau.');
            return false;
        }
        return true;
    }

    function displayCalendar(roomId) {
        if (!roomId) { reservationCalendar.style.display = 'none'; return; }
        reservationCalendar.style.display = 'block';
        const localNow = new Date();
        calendarTable.querySelectorAll('td:not(.hour-header)').forEach(cell => {
            const dateStr = cell.getAttribute('data-date');
            const row = cell.closest('tr');
            const start = new Date(dateStr + 'T' + row.getAttribute('data-start-time'));
            const end = new Date(dateStr + 'T' + row.getAttribute('data-end-time'));
            cell.classList.remove('available', 'reserved', 'past-slot');
            if (end <= localNow) {
                cell.classList.add('past-slot');
                cell.innerText = 'Passé';
            } else if (allReservations.some(res => res.roomId == roomId && start < new Date(res.endTime) && end > new Date(res.startTime))) {
                cell.classList.add('reserved');
                cell.innerText = 'Réservé';
            } else {
                cell.classList.add('available');
                cell.innerText = 'Libre';
            }
        });
    }

    function confirmAnnulation(id, room, time) {
        document.getElementById('modalReservationId').value = id;
        document.getElementById('modalRoomName').innerText = room;
        document.getElementById('modalStartTime').innerText = time;
        document.getElementById('cancelModal').style.display = 'flex';
    }

    function closeCancelModal() { document.getElementById('cancelModal').style.display = 'none'; }

    document.addEventListener('DOMContentLoaded', () => {
        const toast = document.getElementById("toastNotification");
        if (toast) setTimeout(() => { toast.style.transition = "opacity 0.5s"; toast.style.opacity = "0"; setTimeout(() => { toast.style.display = "none"; }, 500); }, 5000);
        checkReservationInputs();
    });
</script>
</body>
</html>