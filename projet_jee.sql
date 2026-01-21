-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 30, 2025 at 09:41 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `projet_jee`
--

-- --------------------------------------------------------

--
-- Table structure for table `formateur_formation`
--

CREATE TABLE `formateur_formation` (
  `id` int(11) NOT NULL,
  `formateur_id` int(11) NOT NULL,
  `formation_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `formateur_formation`
--

INSERT INTO `formateur_formation` (`id`, `formateur_id`, `formation_id`) VALUES
(30, 39, 13),
(31, 39, 14),
(32, 40, 15);

-- --------------------------------------------------------

--
-- Table structure for table `formations`
--

CREATE TABLE `formations` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `prix` decimal(10,2) NOT NULL,
  `duree_mois` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `formations`
--

INSERT INTO `formations` (`id`, `nom`, `description`, `prix`, `duree_mois`) VALUES
(12, 'DevOps (Cloud & CI/CD)', 'Apprenez à automatiser le cycle de vie du développement logiciel, de l\'intégration continue au déploiement continu, en utilisant les outils incontournables du marché et le Cloud.', 1500.00, 4),
(13, 'Développement Full Stack JavaScript (Next.js & NestJS)', 'Maîtrisez le développement d\'applications web modernes et performantes en utilisant Next.js pour le frontend (React) et NestJS pour le backend (Node.js/TypeScript).', 1400.00, 4),
(14, 'Développement Mobile Cross-Platform avec Flutter', 'Créez des applications mobiles natives performantes pour iOS et Android à partir d\'une seule base de code en utilisant le framework Flutter et le langage Dart.', 1200.00, 3),
(15, 'Web 3.0 : Blockchain, Smart Contracts et DApps', 'Explorez l\'architecture décentralisée du Web 3.0. Apprenez à coder des Smart Contracts et à créer des Applications Décentralisées (DApps) sur la Blockchain Ethereum.', 1800.00, 5);

-- --------------------------------------------------------

--
-- Table structure for table `inscriptions`
--

CREATE TABLE `inscriptions` (
  `id` int(11) NOT NULL,
  `etudiant_id` int(11) NOT NULL,
  `formation_id` int(11) NOT NULL,
  `date_inscription` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inscriptions`
--

INSERT INTO `inscriptions` (`id`, `etudiant_id`, `formation_id`, `date_inscription`) VALUES
(11, 41, 15, '2025-11-30 13:37:28');

-- --------------------------------------------------------

--
-- Table structure for table `programme_formation`
--

CREATE TABLE `programme_formation` (
  `id` int(11) NOT NULL,
  `formation_id` int(11) NOT NULL,
  `titre_module` varchar(255) NOT NULL,
  `details` text DEFAULT NULL,
  `ordre` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `programme_formation`
--

INSERT INTO `programme_formation` (`id`, `formation_id`, `titre_module`, `details`, `ordre`) VALUES
(54, 12, 'Introduction à Linux et Shell Scripting', 'Commandes de base, gestion des processus, scripting Bash pour l\'automatisation des tâches.', 1),
(55, 12, 'Conteneurisation avec Docker et Kubernetes', 'Concepts Docker, création d\'images, déploiement d\'applications, orchestration avec Kubernetes (K8s).', 2),
(56, 12, 'Gestion de Configuration avec Ansible', 'Principes d\'Ansible, Playbooks, gestion des inventaires, déploiement d\'infrastructures en tant que code (IaC).', 3),
(57, 12, 'CI/CD avec Jenkins et GitLab CI', 'Mise en place de pipelines d\'intégration continue, tests automatisés, automatisation du déploiement (CD).', 4),
(58, 13, 'Frontend : React et les Fondamentaux de Next.js', 'Hooks, Composants, Routage, Rendering (SSR, SSG, ISR) dans Next.js.', 1),
(59, 13, 'Backend : Introduction à NestJS', 'Architecture MVC/Modules, Contrôleurs, Providers, Services, Typescript.', 2),
(60, 13, 'Bases de Données et ORM (TypeORM/Prisma)', 'Modélisation de données, CRUD, intégration d\'une base de données SQL/NoSQL.', 3),
(61, 13, 'APIs RESTful et Authentification', 'Conception d\'API, gestion des erreurs, mise en place de JWT et Passport.', 4),
(62, 14, 'Fondamentaux de Dart et Introduction à Flutter', 'Syntaxe Dart, installation de l\'environnement, Widgets de base (Stateless/Stateful).', 1),
(63, 14, 'Conception d\'Interface Utilisateur (UI/UX)', 'Widgets de mise en page (Rows, Columns, Containers), Navigation, Thèmes et Design Material.', 2),
(64, 14, 'Gestion d\'État (State Management)', 'Utilisation de Provider ou Bloc pour gérer l\'état complexe des applications.', 3),
(65, 14, 'Intégration de Services et APIs', 'Requêtes HTTP, gestion des données JSON, stockage local avec SharedPreferences ou Hive.', 4),
(66, 15, 'Concepts Fondamentaux de la Blockchain', 'Cryptographie, Hachage, Ledger, Consens, Bitcoin vs Ethereum, Wallets.', 1),
(67, 15, 'Programmation de Smart Contracts avec Solidity', 'Variables, Fonctions, Modificateurs, Mapping, Événements, environnement Remix.', 2),
(68, 15, 'Outils de Développement (Truffle et Ganache)', 'Mise en place de l\'environnement de développement, compilation et déploiement local.', 3),
(69, 15, 'Création d\'Applications Décentralisées (DApps', 'Interaction entre le Front-end (React) et le Smart Contract via Web3.js ou Ethers.js.', 4);

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `formation_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`id`, `user_id`, `room_id`, `start_time`, `end_time`, `formation_id`) VALUES
(26, 40, 4, '2025-12-01 08:00:00', '2025-12-01 11:00:00', 15),
(27, 39, 4, '2025-12-01 12:00:00', '2025-12-01 14:00:00', 13),
(29, 40, 5, '2025-12-02 08:00:00', '2025-12-02 10:00:00', 15),
(33, 39, 4, '2025-12-01 16:00:00', '2025-12-01 17:00:00', 13);

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `capacity` int(11) NOT NULL,
  `type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`id`, `name`, `capacity`, `type`) VALUES
(4, 'Labo Informatique 1', 29, 'Salle de Cours'),
(5, 'Atelier IOT 1', 60, 'Atelier'),
(7, 'Conférence C1', 50, 'Salle de Conférence');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','USER','STUDENT','FORMATEUR') NOT NULL DEFAULT 'STUDENT',
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `role`, `first_name`, `last_name`, `phone_number`) VALUES
(2, 'admin@gmail.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN', 'moez', 'kraiem', '24376647'),
(39, 'firas.kraiem@gmail.com', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'FORMATEUR', 'firas', 'kraiem', '21365874'),
(40, 'islem.kraiem@gmail.com', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'FORMATEUR', 'Islem', 'Kraiem', '52145874'),
(41, 'oussama.kraiem@gmail.com', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'STUDENT', 'Oussama', 'kraieme', '98745632');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `formateur_formation`
--
ALTER TABLE `formateur_formation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_formateur_formation` (`formateur_id`,`formation_id`),
  ADD KEY `fk_formation` (`formation_id`);

--
-- Indexes for table `formations`
--
ALTER TABLE `formations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inscriptions`
--
ALTER TABLE `inscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `etudiant_id` (`etudiant_id`),
  ADD KEY `formation_id` (`formation_id`);

--
-- Indexes for table `programme_formation`
--
ALTER TABLE `programme_formation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `formation_id` (`formation_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `formation_id` (`formation_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `unique_phone` (`phone_number`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `formateur_formation`
--
ALTER TABLE `formateur_formation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `formations`
--
ALTER TABLE `formations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `inscriptions`
--
ALTER TABLE `inscriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `programme_formation`
--
ALTER TABLE `programme_formation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `formateur_formation`
--
ALTER TABLE `formateur_formation`
  ADD CONSTRAINT `fk_formateur` FOREIGN KEY (`formateur_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_formation` FOREIGN KEY (`formation_id`) REFERENCES `formations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `inscriptions`
--
ALTER TABLE `inscriptions`
  ADD CONSTRAINT `inscriptions_ibfk_1` FOREIGN KEY (`etudiant_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inscriptions_ibfk_2` FOREIGN KEY (`formation_id`) REFERENCES `formations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `programme_formation`
--
ALTER TABLE `programme_formation`
  ADD CONSTRAINT `programme_formation_ibfk_1` FOREIGN KEY (`formation_id`) REFERENCES `formations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_3` FOREIGN KEY (`formation_id`) REFERENCES `formations` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
