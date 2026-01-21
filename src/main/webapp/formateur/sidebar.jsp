<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="sidebar" style="background: #10b981;">
    <div class="sidebar-brand">
        <h2><i class="fa fa-graduation-cap" style="color:#ffc107; margin-right:5px;"></i> <span>FORMATEUR</span></h2>
    </div>

    <ul class="sidebar-menu">
        <li>
            <a href="<%= request.getContextPath() %>/formateur/dashboard"
               class="<%= request.getRequestURI().endsWith("/formateur/dashboard") ? "active" : "" %>"
               style="border-left-color: #ffc107;">
                <i class="fa fa-tachometer-alt"></i>
                <span>Tableau de bord</span>
            </a>
        </li>

        <li>
            <a href="<%= request.getContextPath() %>/formateur/formations"
               class="<%= request.getRequestURI().contains("/formateur/formations") ? "active" : "" %>"
               style="border-left-color: #ffc107;">
                <i class="fa fa-layer-group"></i>
                <span>Mes Formations</span>
            </a>
        </li>

        <li>
            <a href="<%= request.getContextPath() %>/formateur/emplois"
               class="<%= request.getRequestURI().contains("/formateur/emplois") ? "active" : "" %>"
               style="border-left-color: #ffc107;">
                <i class="fa fa-calendar-alt"></i>
                <span>Mon Emploi du Temps</span>
            </a>
        </li>

        <li>
            <a href="<%= request.getContextPath() %>/formateur/salles"
               class="<%= request.getRequestURI().endsWith("/formateur/salles") ? "active" : "" %>"
               style="border-left-color: #ffc107;">
                <i class="fa fa-door-open"></i>
                <span>Réserver Salle</span>
            </a>
        </li>

        <li>
            <a href="<%= request.getContextPath() %>/compte/modifier"
               class="<%= request.getRequestURI().contains("/compte/modifier") ? "active" : "" %>"
               style="border-left-color: #ffc107;">
                <i class="fa fa-user-cog"></i>
                <span>Modifier Compte</span>
            </a>
        </li>

        <li>
            <a href="#" onclick="showLogoutModal()" style="border-left-color: #ffc107;">
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
            <a href="<%= request.getContextPath() %>/logout" class="btn-modal btn-confirm">Déconnexion</a>
        </div>
    </div>
</div>

<script>
    function showLogoutModal() {
        const modal = document.getElementById('logoutModal');
        if (modal) {
            modal.style.display = 'flex';
        }
    }

    function closeLogoutModal() {
        document.getElementById('logoutModal').style.display = 'none';
    }

    window.onclick = function(event) {
        const modal = document.getElementById('logoutModal');
        if (event.target === modal) {
            modal.style.display = "none";
        }
    }
</script>