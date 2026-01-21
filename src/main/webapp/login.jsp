<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Connexion - FormaPRO</title>
    <link href="css/login.css" rel="stylesheet">
    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.8.5/dist/dotlottie-wc.js" type="module"></script>
</head>

<body>
    <div class="login-card">
        <div class="login-left">
            <dotlottie-wc
                src="https://lottie.host/a49d0412-0f34-4d00-9926-b6d376efcd7e/z32vF7SjjG.lottie"
                style="width: 500px; height: 500px;"
                autoplay
                loop>
            </dotlottie-wc>
            <h3>Bienvenue chez FormaPRO</h3>
            <p style="color:#666; text-align:center;">Accédez à votre espace de formation</p>
        </div>

        <div class="login-right">
            <div class="login-header">
                <h2>Connexion</h2>
                <p>Entrez vos identifiants pour continuer</p>
            </div>

            <%
                String error = (String) request.getAttribute("errorMessage");
                if (error != null) {
            %>
                <div class="alert-error">
                    <i class="fa fa-exclamation-circle mr-2"></i> <%= error %>
                </div>
            <% } %>

            <form action="login" method="post">
                <div class="form-group">
                    <label>Nom d'utilisateur ou Email</label>
                    <input type="text" class="form-control" name="email" placeholder="ex: utilisateur@gmail.com" required>
                </div>

                <div class="form-group">
                    <label>Mot de passe</label>
                    <input type="password" class="form-control" name="password" placeholder="Votre mot de passe" required>
                </div>

                <button type="submit" class="btn-login">Se connecter</button>

                <div style="text-align: center; margin-top: 20px;">
                    <a href="index.jsp" style="text-decoration: none; color: #666;">Retour à l'accueil</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>