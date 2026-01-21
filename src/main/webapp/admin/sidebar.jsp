<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="sidebar">
    <div class="sidebar-brand">
        <h2><i class="fa fa-book-reader" style="color:#ffc107; margin-right:5px;"></i> <span>FormaPRO</span></h2>
    </div>

    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="<%= request.getRequestURI().endsWith("dashboard.jsp") ? "active" : "" %>">
                <i class="fa fa-tachometer-alt"></i>
                <span>Tableau de bord</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/formateurs/liste_formateurs"
               class="<%= request.getRequestURI().endsWith("liste_formateurs") ? "active" : "" %>">
                <i class="fa fa-chalkboard-teacher"></i>
                <span>Gérer Formateurs</span>
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/admin/etudiants/liste_etudiants"
               class="<%= request.getRequestURI().endsWith("liste_etudiants") ? "active" : "" %>">
                <i class="fa fa-user-graduate"></i>
                <span>Gérer Étudiants</span>
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/admin/formations/liste_formations"
               class="<%= request.getRequestURI().endsWith("liste_formations") ? "active" : "" %>">
                <i class="fa fa-layer-group"></i>
                <span>Gérer Formations</span>
            </a>
        </li>


        <li>
            <a href="${pageContext.request.contextPath}/admin/salles/liste_salles"
               class="<%= request.getRequestURI().endsWith("liste_salles") ? "active" : "" %>">
                <i class="fa fa-door-open"></i>
                <span>Gérer Salles</span>
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/admin/reservations/liste_reservations"
               class="<%= request.getRequestURI().endsWith("liste_reservations") ? "active" : "" %>">
                <i class="fa fa-calendar-check"></i>
                <span>Réservations</span>
            </a>
        </li>

        <li>
            <a href="<%= request.getContextPath() %>/compte/modifier"
               class="<%= request.getRequestURI().contains("/compte/modifier") ? "active" : "" %>">
                <i class="fa fa-user-cog"></i>
                <span>Modifier Compte</span>
            </a>
        </li>

        <li>
            <a href="#" onclick="showLogoutModal()">
                <i class="fa fa-sign-out-alt"></i>
                <span>Déconnexion</span>
            </a>
        </li>
    </ul>
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
            <a href="${pageContext.request.contextPath}/logout" class="btn-modal btn-confirm">Déconnexion</a>
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