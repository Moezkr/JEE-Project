package com.projetjee.model;

import java.sql.Timestamp;


public class Inscription {
    private int id;
    private int etudiantId;
    private int formationId;
    private Timestamp dateInscription;



    private String studentName;
    private String studentEmail;
    private String formationName;


    public Inscription() {}


    public Inscription(int id, int etudiantId, int formationId, Timestamp dateInscription) {
        this.id = id;
        this.etudiantId = etudiantId;
        this.formationId = formationId;
        this.dateInscription = dateInscription;
    }


    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getEtudiantId() { return etudiantId; }
    public void setEtudiantId(int etudiantId) { this.etudiantId = etudiantId; }

    public int getFormationId() { return formationId; }
    public void setFormationId(int formationId) { this.formationId = formationId; }

    public Timestamp getDateInscription() { return dateInscription; }
    public void setDateInscription(Timestamp dateInscription) { this.dateInscription = dateInscription; }


   
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }

    public String getFormationName() { return formationName; }
    public void setFormationName(String formationName) { this.formationName = formationName; }
}