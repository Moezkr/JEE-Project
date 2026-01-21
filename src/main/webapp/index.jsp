<%@ page import="com.projetjee.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="utf-8">
    <title>FormaPRO - Centre de Formation Professionnelle</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="Formation, Apprentissage, Cours, Certification" name="keywords">
    <meta content="Site web de centre de formation professionnelle" name="description">

    <link href="img/favicon.ico" rel="icon">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <link href="css/style.css" rel="stylesheet">
</head>

<body>

    <div class="container-fluid p-0">
        <nav class="navbar navbar-expand-lg bg-white navbar-light py-3 py-lg-0 px-lg-5">
            <a href="index.jsp" class="navbar-brand ml-lg-3">
                <h1 class="m-0 text-uppercase text-primary"><i class="fa fa-book-reader mr-3"></i>FormaPRO</h1>
            </a>
            <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-between px-lg-3" id="navbarCollapse">
                <div class="navbar-nav mx-auto py-0">
                    <a href="index.jsp" class="nav-item nav-link active">Accueil</a>
                    <a href="<%= request.getContextPath() %>/course" class="nav-item nav-link ">Formations</a>
                    <a href="contact.jsp" class="nav-item nav-link">Contact</a>
                </div>

                <% if (user == null) { %>
                    <a href="login.jsp" class="btn btn-primary py-2 px-4 d-none d-lg-block">Rejoignez-nous</a>
                <% } else { %>
                    <div class="d-none d-lg-flex align-items-center">
                        <span class="mr-3 text-dark font-weight-bold" style="font-size: 0.9rem;">
                            <i class="fa fa-user-circle mr-1"></i> <%= user.getFullName() %>
                        </span>

                        <% if ("ADMIN".equals(user.getRole())) { %>
                            <a href="admin-dashboard.jsp" class="btn btn-primary py-2 px-3 mr-2">Admin</a>
                        <% } else { %>
                            <a href="home.jsp" class="btn btn-primary py-2 px-3 mr-2">Mon Espace</a>
                        <% } %>

                        <a href="logout" class="btn btn-outline-danger py-2 px-3">
                            <i class="fa fa-sign-out-alt"></i>
                        </a>
                    </div>
                <% } %>

            </div>
        </nav>
    </div>

    <div class="jumbotron jumbotron-fluid position-relative overlay-bottom" style="margin-bottom: 90px;">
        <div class="container text-center my-5 py-5">
            <h1 class="text-white mt-4 mb-4">Développez vos compétences</h1>
            <h1 class="text-white display-1 mb-5">Centre de Formation d'Excellence</h1>
        </div>
    </div>

    <div class="container-fluid bg-image" style="margin: 90px 0;">
        <div class="container">
            <div class="row">
                <div class="col-lg-7 my-5 pt-5 pb-lg-5">
                    <div class="section-title position-relative mb-4">
                        <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Pourquoi Nous Choisir ?</h6>
                        <h1 class="display-4">Pourquoi Commencer Votre Formation Avec Nous ?</h1>
                    </div>
                    <p class="mb-4 pb-2">Nous offrons un environnement d'apprentissage stimulant, des équipements modernes et un accompagnement personnalisé pour garantir votre réussite professionnelle.</p>
                    
                    <div class="d-flex mb-3">
                        <div class="btn-icon bg-primary mr-4">
                            <i class="fa fa-2x fa-graduation-cap text-white"></i>
                        </div>
                        <div class="mt-n1">
                            <h4>Formateurs Experts</h4>
                            <p>Nos formateurs sont des professionnels actifs dans leurs domaines respectifs, apportant une expérience réelle.</p>
                        </div>
                    </div>

                    <div class="d-flex mb-3">
                        <div class="btn-icon bg-secondary mr-4">
                            <i class="fa fa-2x fa-certificate text-white"></i>
                        </div>
                        <div class="mt-n1">
                            <h4>Certificats Reconnus</h4>
                            <p>Obtenez des certifications valorisées par les employeurs à la fin de votre parcours.</p>
                        </div>
                    </div>

                    <div class="d-flex">
                        <div class="btn-icon bg-warning mr-4">
                            <i class="fa fa-2x fa-book-reader text-white"></i>
                        </div>
                        <div class="mt-n1">
                            <h4>Cours en Présentiel</h4>
                            <p class="m-0">
                                Bénéficiez d'un accompagnement réel en classe, pour un apprentissage efficace et interactif.
                            </p>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5" style="min-height: 500px;">
                    <div class="position-relative h-100">
                        <img class="position-absolute w-100 h-100" src="img/feature.jpg" style="object-fit: cover;">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid py-5">
        <div class="container py-5">
            <div class="row align-items-center">
                <div class="col-lg-5 mb-5 mb-lg-0">
                    <div class="bg-light d-flex flex-column justify-content-center px-5" style="height: 450px;">
                        <div class="d-flex align-items-center mb-5">
                            <div class="btn-icon bg-primary mr-4">
                                <i class="fa fa-2x fa-map-marker-alt text-white"></i>
                            </div>
                            <div class="mt-n1">
                                <h4>Notre Adresse</h4>
                                <p class="m-0">123 Rue de la Formation, Tunis, Tunisie</p>
                            </div>
                        </div>

                        <div class="d-flex align-items-center mb-5">
                            <div class="btn-icon bg-secondary mr-4">
                                <i class="fa fa-2x fa-phone-alt text-white"></i>
                            </div>
                            <div class="mt-n1">
                                <h4>Appelez-nous</h4>
                                <p class="m-0">+216 12 345 678</p>
                            </div>
                        </div>

                        <div class="d-flex align-items-center">
                            <div class="btn-icon bg-warning mr-4">
                                <i class="fa fa-2x fa-envelope text-white"></i>
                            </div>
                            <div class="mt-n1">
                                <h4>Email</h4>
                                <p class="m-0">info@exemple.com</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-7">
                    <div class="section-title position-relative mb-4">
                        <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Besoin d'aide ?</h6>
                        <h1 class="display-4">Envoyez-nous un message</h1>
                    </div>
                    <div class="contact-form">
                        <form>
                            <div class="row">
                                <div class="col-6 form-group">
                                    <input type="text" class="form-control border-top-0 border-right-0 border-left-0 p-0" placeholder="Votre Nom" required="required">
                                </div>
                                <div class="col-6 form-group">
                                    <input type="email" class="form-control border-top-0 border-right-0 border-left-0 p-0" placeholder="Votre Email" required="required">
                                </div>
                            </div>
                            <div class="form-group">
                                <input type="text" class="form-control border-top-0 border-right-0 border-left-0 p-0" placeholder="Sujet" required="required">
                            </div>
                            <div class="form-group">
                                <textarea class="form-control border-top-0 border-right-0 border-left-0 p-0" rows="5" placeholder="Message" required="required"></textarea>
                            </div>
                            <div>
                                <button class="btn btn-primary py-3 px-5" type="submit">Envoyer</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid position-relative overlay-top bg-dark text-white-50 py-5" style="margin-top: 90px;">
        <div class="container mt-5 pt-5">
            <div class="row">
                <div class="col-md-8 offset-md-2 mb-5 text-center">
                    <a href="index.jsp" class="navbar-brand">
                        <h1 class="mt-n2 text-uppercase text-white" style="display:inline-block;"><i class="fa fa-book-reader mr-3"></i>FormaPRO</h1>
                    </a>
                    <p class="m-0">Votre partenaire de confiance pour la formation professionnelle et le développement des compétences. Rejoignez notre communauté d'apprenants dès aujourd'hui.</p>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid bg-dark text-white-50 border-top py-4" style="border-color: rgba(256, 256, 256, .1) !important;">
        <div class="container">
            <div class="row">
                <div class="col-12 text-center mb-3 mb-md-0">
                    <p class="m-0">Copyright &copy; <a class="text-white" href="#">FormaPRO</a>. Tous droits réservés.</p>
                </div>
            </div>
        </div>
    </div>

    <a href="#" class="btn btn-lg btn-primary rounded-0 btn-lg-square back-to-top"><i class="fa fa-angle-double-up"></i></a>

    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="lib/easing/easing.min.js"></script>
    <script src="lib/waypoints/waypoints.min.js"></script>
    <script src="lib/counterup/counterup.min.js"></script>
    <script src="lib/owlcarousel/owl.carousel.min.js"></script>

    <script src="js/main.js"></script>
</body>

</html>