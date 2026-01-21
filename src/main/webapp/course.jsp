<%@ page import="com.projetjee.model.User" %>
<%@ page import="com.projetjee.model.Formation" %>
<%@ page import="com.projetjee.model.Programme" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = null;
    if (request.getSession(false) != null) {
        user = (User) request.getSession().getAttribute("user");
    }

    List<Formation> catalogueFormations = (List<Formation>) request.getAttribute("catalogueFormations");

    if (catalogueFormations == null) {
        catalogueFormations = new java.util.ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="utf-8">
    <title>FormaPRO - Catalogue des Formations</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="Formations professionnelles, Cours, Certification, Apprentissage" name="keywords">
    <meta content="Catalogue des formations proposées par notre centre" name="description">

    <link href="img/favicon.ico" rel="icon">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700;800&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #007bff;
            --secondary-color: #28a745;
            --dark-text: #343a40;
            --light-bg: #f8f9fa;
            --module-bg: #e9f5ff;
            --shadow-subtle: 0 4px 12px rgba(0, 0, 0, 0.08);
            --shadow-hover: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        .course-item {
            min-height: 520px;
            display: flex;
            flex-direction: column;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s ease-in-out;
            box-shadow: var(--shadow-subtle);
            background-color: white;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .course-item:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-hover);
        }

        .info-section {
            padding: 1.5rem !important;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .info-section h3 {
            color: var(--dark-text);
            font-weight: 800;
            margin-bottom: 1rem;
            line-height: 1.3;
        }

        .info-section .details-meta {
            margin-bottom: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 10px;
            border-top: 1px solid rgba(0, 0, 0, 0.05);
        }

        .info-section .meta-detail {
            font-size: 0.95rem;
            color: #555;
            font-weight: 600;
        }

        .info-section .meta-detail i {
            color: var(--primary-color);
            margin-right: 0.5rem;
        }

        .info-section .price-detail {
            color: var(--secondary-color) !important;
            font-size: 1.1rem;
            font-weight: 800;
        }

        .info-section .description-text {
            color: #6c757d;
            line-height: 1.6;
            margin-top: 0.5rem;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }

        .modules-section {
            background-color: var(--module-bg);
            padding: 1.5rem;
            border-top: 1px solid rgba(0, 0, 0, 0.1);
        }

        .modules-section h5 {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 0.75rem !important;
            font-size: 1rem;
        }

        .modules-list li {
            padding: 0.5rem 0;
            border-bottom: 1px dashed rgba(0, 0, 0, 0.1);
        }

        .modules-list li:last-child {
            border-bottom: none;
        }

        .modules-list strong {
            color: var(--dark-text);
            font-size: 0.9rem;
        }

        .modules-list small {
            color: #6a737d;
            font-size: 0.8rem;
            display: block;
            margin-top: 2px;
        }

        .action-button {
            text-align: center;
            padding-top: 1.5rem;
            padding-bottom: 1rem;
            background-color: var(--module-bg);
        }

        .course-item .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            font-weight: 600;
            padding: 0.7rem 1.8rem;
            border-radius: 50px;
            transition: all 0.3s ease;
        }

        .course-item .btn-primary:hover {
            background-color: #0056b3;
            border-color: #004085;
            transform: scale(1.05);
        }

        .owl-carousel .owl-nav button.owl-prev,
        .owl-carousel .owl-nav button.owl-next {
            background: var(--primary-color) !important;
            opacity: 0.9;
            width: 45px;
            height: 45px;
            font-size: 1.5rem !important;
        }

        .owl-carousel .owl-nav button.owl-prev { left: -35px; }
        .owl-carousel .owl-nav button.owl-next { right: -35px; }

        .section-title h1 {
            font-size: 2.8rem;
            font-weight: 800;
            color: var(--dark-text);
        }

        .section-title h6 {
            font-size: 1.1rem;
            color: var(--primary-color);
            letter-spacing: 0.1em;
            font-weight: 700;
        }
    </style>
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
                    <a href="index.jsp" class="nav-item nav-link">Accueil</a>
                    <a href="<%= request.getContextPath() %>/course" class="nav-item nav-link active">Formations</a>
                    <a href="<%= request.getContextPath() %>/contact.jsp" class="nav-item nav-link">Contact</a>
                </div>

                <% if (user == null) { %>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-primary py-2 px-4 d-none d-lg-block">Rejoignez-nous</a>
                <% } else { %>
                    <div class="d-none d-lg-flex align-items-center">
                        <span class="mr-3 text-dark font-weight-bold" style="font-size: 0.9rem;">
                            <i class="fa fa-user-circle mr-1"></i> <%= user.getFullName() %>
                        </span>
                        <%
                            String dashboardLink = "";
                            switch (user.getRole()) {
                                case "ADMIN":
                                    dashboardLink = request.getContextPath() + "/admin/dashboard.jsp";
                                    break;
                                case "FORMATEUR":
                                    dashboardLink = request.getContextPath() + "/formateur/dashboard";
                                    break;
                                case "ETUDIANT":
                                    dashboardLink = request.getContextPath() + "/etudiant/dashboard.jsp";
                                    break;
                                default:
                                    dashboardLink = request.getContextPath() + "/home.jsp";
                            }
                        %>
                        <a href="<%= dashboardLink %>" class="btn btn-primary py-2 px-3 mr-2">Mon Espace</a>
                        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-danger py-2 px-3">
                            <i class="fa fa-sign-out-alt"></i>
                        </a>
                    </div>
                <% } %>
            </div>
        </nav>
    </div>

    <div class="jumbotron jumbotron-fluid page-header position-relative overlay-bottom" style="margin-bottom: 90px;">
        <div class="container text-center py-5">
            <h1 class="text-white display-1">Formations</h1>
            <div class="d-inline-flex text-white mb-5">
                <p class="m-0 text-uppercase"><a class="text-white" href="index.jsp">Accueil</a></p>
                <i class="fa fa-angle-double-right pt-1 px-3"></i>
                <p class="m-0 text-uppercase">Formations</p>
            </div>
        </div>
    </div>

    <div class="container-fluid py-5">
        <div class="container py-5">
            <div class="row mx-0 justify-content-center">
                <div class="col-lg-8">
                    <div class="section-title text-center position-relative mb-5">
                        <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Notre Catalogue</h6>
                        <h1 class="display-4">Découvrez Nos Programmes de Formation</h1>
                    </div>
                </div>
            </div>

            <% if (catalogueFormations.isEmpty()) { %>
                <div class="row">
                    <div class="col-12 text-center py-5">
                        <p class="lead">Aucun programme de formation n'est actuellement disponible dans le catalogue.</p>
                    </div>
                </div>
            <% } else { %>
                <div class="owl-carousel courses-carousel owl-theme position-relative">
                    <% for (Formation formation : catalogueFormations) { %>
                        <div class="course-item bg-white m-3">
                            <div class="info-section">
                                <div>
                                    <h3><%= formation.getNom() %></h3>
                                    <div class="details-meta">
                                        <span class="meta-detail"><i class="fa fa-clock"></i><%= formation.getDureeMois() %> Mois</span>
                                        <span class="meta-detail price-detail"><i class="fa fa-wallet"></i><%= formation.getPrix() %> TND</span>
                                    </div>
                                    <p class="description-text"><%= formation.getDescription() %></p>
                                </div>
                            </div>

                            <div class="modules-section">
                                <h5><i class="fa fa-list-alt mr-2"></i>Programme Détaillé:</h5>
                                <ul class="list-unstyled mb-0 modules-list">
                                    <% if (formation.getProgrammes().isEmpty()) { %>
                                        <li class="text-muted small">Programme en cours de définition.</li>
                                    <% } else {
                                        int moduleCount = 0;
                                        int maxModules = 4;
                                        for (Programme programme : formation.getProgrammes()) {
                                            if (moduleCount < maxModules) {
                                                moduleCount++;
                                    %>
                                                <li>
                                                    <strong>Module <%= programme.getOrdre() %>: <%= programme.getTitreModule() %></strong>
                                                    <small class="d-block"><%= programme.getDetails() %></small>
                                                </li>
                                    <%      } else if (formation.getProgrammes().size() > maxModules) { %>
                                                <li class="text-muted small">... et <%= formation.getProgrammes().size() - maxModules %> autres modules.</li>
                                    <%          break;
                                            }
                                        }
                                    } %>
                                </ul>
                            </div>

                            <div class="action-button">
                                <a class="btn btn-primary" href="<%= request.getContextPath() %>/contact.jsp">
                                    S'inscrire <i class="fa fa-arrow-right ml-2"></i>
                                </a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
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

    <script>
        $(document).ready(function() {
            if ($('.courses-carousel').length) {
                $(".courses-carousel").owlCarousel({
                    autoplay: true,
                    smartSpeed: 1000,
                    loop: true,
                    dots: false,
                    nav: true,
                    navText : [
                        '<i class="fa fa-angle-left"></i>',
                        '<i class="fa fa-angle-right"></i>'
                    ],
                    responsive: {
                        0:{
                            items:1,
                            nav:false
                        },
                        768:{
                            items:2,
                            nav:true
                        },
                        992:{
                            items:2,
                            nav:true
                        },
                        1200:{
                            items:3,
                            nav:true
                        }
                    }
                });
            }
        });
    </script>
</body>

</html>