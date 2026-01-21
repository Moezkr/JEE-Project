<h1 align="center"> 👩‍💻  Système de Gestion de Centre de Formation  👩‍💻 </h1>
Ce projet est un système de gestion complet pour un centre de formation, offrant des interfaces et des fonctionnalités distinctes adaptées aux rôles d'Administrateur, de Formateur et d'Étudiant.


# 🚀 Fonctionnalités du Projet )



---

## 👑 Administrateur (ADMIN)

L'administrateur dispose d'un contrôle total sur la plateforme et est responsable de la gestion des utilisateurs, des formations, des salles et de la planification globale.


Identifiants de Connexion par Défaut :

Email : admin@gmail.com

Mot de passe : admin123

* **Tableau de Bord Centralisé (Dashboard) :**
    * Affichage des statistiques clés : nombre total d'Étudiants, de Formateurs, de Formations, et revenus totaux.
* **Gestion des Utilisateurs :**
    * **CRUD** (Création, Modification, Suppression) des comptes Formateurs et Étudiants.
    * Liste paginée des Formateurs et des Étudiants (nom, email, téléphone, formation assignée).
* **Gestion des Formations :**
    * **CRUD** des formations complètes.
    * Gestion du **programme/des modules** associés à chaque formation (ajout, modification, suppression).
* **Gestion des Salles (Rooms) :**
    * **CRUD** des salles de cours et des laboratoires (nom, capacité, type).
* **Gestion des Affectations :**
    * Modification des formations affectées à chaque Formateur.
    * Modification de la formation à laquelle est inscrit chaque Étudiant.
* **Gestion des Réservations :**
    * Consultation et filtrage de **toutes les réservations de salles** (par date et par Formateur).
    * Possibilité d'**annuler** une session de cours planifiée.

---

## 👨‍🏫 Formateur (FORMATEUR)

Le Formateur gère ses propres cours et sessions en classe.

* **Tableau de Bord Personnel :**
    * Visualisation des statistiques d'activité (formations assignées, sessions/heures de cours prévues aujourd'hui).
* **Gestion des Formations Assignées :**
    * Consultation de la liste détaillée des formations qui lui sont attribuées.
    * Accès aux programmes/modules de chaque formation.
* **Planification des Sessions (Réservation de Salle) :**
    * Accès à la page de réservation.
    * Vérification des disponibilités des salles (calendrier sur 14 jours).
    * **Création d'une nouvelle réservation** pour une de ses formations.
    * Le système vérifie les **conflits de salles** et les **conflits d'emploi du temps personnels**.
* **Gestion des Réservations :**
    * Consultation et **annulation** des sessions de cours qu'il a planifiées.
* **Gestion du Profil :**
    * Modification de ses informations personnelles (nom, email, téléphone).

---

## 🧑‍🎓 Étudiant (STUDENT)

L'Étudiant a une vue simplifiée, axée sur son emploi du temps et son profil.

* **Tableau de Bord Simple :**
    * Vue d'ensemble de sa situation actuelle.
* **Emploi du Temps :**
    * Consultation de toutes les **sessions futures** planifiées pour la formation à laquelle il est inscrit (lieu, heure, formation).
* **Gestion du Profil :**
    * Modification de ses informations personnelles (nom, email, téléphone).
* **Catalogue Public :**
    * Consultation de la liste publique de toutes les formations disponibles sur la plateforme.





## 😄 Demo Pictures

### 👑 Home

|<img width="1903" height="941" alt="Screenshot 2025-11-30 200728" src="https://github.com/user-attachments/assets/26e1ed74-b826-4f57-95bb-e37378a14d3d" />|<img width="1905" height="940" alt="Screenshot 2025-11-30 200741" src="https://github.com/user-attachments/assets/1a194540-f757-464b-8558-e32031aee2ec" />|<img width="1919" height="939" alt="Screenshot 2025-11-30 200752" src="https://github.com/user-attachments/assets/7f8e5f4d-1783-4c00-a3e1-c4113232db32" />|
|---------|---------|---------|



### 👑 Administrateur (ADMIN)

|<img width="1919" height="943" alt="Screenshot 2025-11-30 200814" src="https://github.com/user-attachments/assets/dfc51b21-968b-4dc9-84d7-552592af7c52" />|<img width="1919" height="945" alt="Screenshot 2025-11-30 200837" src="https://github.com/user-attachments/assets/5bc1f7ef-8f58-4492-9d4f-ca508c57513d" />|<img width="1919" height="941" alt="Screenshot 2025-11-30 200903" src="https://github.com/user-attachments/assets/2f483303-426f-434c-be35-67880749ac4c" />|
|---------|---------|---------|

|<img width="1919" height="940" alt="Screenshot 2025-11-30 200917" src="https://github.com/user-attachments/assets/4356d790-601f-4eed-a20b-36218f0430fe" />|<img width="1919" height="944" alt="Screenshot 2025-11-30 200946" src="https://github.com/user-attachments/assets/ee0d4b51-16e7-46a0-af2a-f4389aa8944e" />|<img width="1903" height="944" alt="Screenshot 2025-11-30 201000" src="https://github.com/user-attachments/assets/b55dc93d-0f14-4fc7-8c28-d062217f6a36" />|
|---------|---------|---------|


|<img width="1919" height="943" alt="Screenshot 2025-11-30 201014" src="https://github.com/user-attachments/assets/f80e3a60-818f-43a1-820a-33852f78bd90" />|<img width="1919" height="941" alt="Screenshot 2025-11-30 201028" src="https://github.com/user-attachments/assets/f4ce0a76-a8b2-48c2-9b77-e82fe96252e2" />|<img width="1919" height="943" alt="Screenshot 2025-11-30 201435" src="https://github.com/user-attachments/assets/bc50798e-ea75-4ceb-9b92-b9b9ff7c7588" />|
|---------|---------|---------|




## 👨‍🏫 Formateur (FORMATEUR)

|<img width="1919" height="942" alt="Screenshot 2025-11-30 201141" src="https://github.com/user-attachments/assets/54193815-f1a2-4aa0-8e3d-f27e70c21321" />|<img width="1919" height="941" alt="Screenshot 2025-11-30 201150" src="https://github.com/user-attachments/assets/98e5f8e5-1c00-441c-b80b-3176f66dbcad" />|<img width="1903" height="942" alt="Screenshot 2025-11-30 201159" src="https://github.com/user-attachments/assets/7476b1f8-e752-440a-bfd7-ed5ef6aad71f" />|
|---------|---------|---------|



|<img width="1902" height="942" alt="Screenshot 2025-11-30 201250" src="https://github.com/user-attachments/assets/f485df95-d403-4372-80d9-bd24f590c4db" />|<img width="1900" height="941" alt="Screenshot 2025-11-30 201329" src="https://github.com/user-attachments/assets/a4a5e5b2-b1dd-4a4a-900c-7faaad4bc832" />|<img width="1902" height="945" alt="Screenshot 2025-11-30 201408" src="https://github.com/user-attachments/assets/7bf0e22d-d6e5-43f2-8c01-4671726c3822" />|
|---------|---------|---------|





## 🧑‍🎓 Étudiant (STUDENT)

|<img width="1919" height="943" alt="Screenshot 2025-11-30 201531" src="https://github.com/user-attachments/assets/0a16de2b-3e9e-4346-a263-786971876034" />|<img width="1919" height="941" alt="Screenshot 2025-11-30 201543" src="https://github.com/user-attachments/assets/cf0f03e7-03c1-49da-9917-e07dc21090e9" />|<img width="1919" height="944" alt="Screenshot 2025-11-30 201552" src="https://github.com/user-attachments/assets/0fa53d8b-7e02-4d06-b149-9711fca88f27" />|
|---------|---------|---------|


## 😄 Demo Video




https://github.com/user-attachments/assets/2a26f09b-2f9d-4f65-be63-22b1a7d3e448









































## 🚀 Acknowledgements


**- Jakarta EE**  

**- MySQL** 





 












⚡️ [![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
⚡️ [![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
⚡️ [![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)









## 📩 Contact

If you have any questions or the project source code or any need additional assistance, please feel free to contact me.

https://t.me/MoezKr/
