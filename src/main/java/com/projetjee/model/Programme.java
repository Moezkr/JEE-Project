package com.projetjee.model;

public class Programme {
    private int id;
    private int formationId; 
    private String titreModule;
    private String details;
    private int ordre; 

  
    public Programme() {}

    public Programme(int id, int formationId, String titreModule, String details, int ordre) {
        this.id = id;
        this.formationId = formationId;
        this.titreModule = titreModule;
        this.details = details;
        this.ordre = ordre;
    }

  
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getFormationId() { return formationId; }
    public void setFormationId(int formationId) { this.formationId = formationId; }

    public String getTitreModule() { return titreModule; }
    public void setTitreModule(String titreModule) { this.titreModule = titreModule; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }

    public int getOrdre() { return ordre; }
    public void setOrdre(int ordre) { this.ordre = ordre; }
}