package com.projetjee.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Formation {
    private int id;
    private String nom;
    private String description;
    private BigDecimal prix;
    private int dureeMois;

    private List<Programme> programmes = new ArrayList<>();


    public Formation() {}


    public Formation(int id, String nom, String description, BigDecimal prix, int dureeMois) {
        this.id = id;
        this.nom = nom;
        this.description = description;
        this.prix = prix;
        this.dureeMois = dureeMois;
    }

    public Formation(String nom, String description, BigDecimal prix, int dureeMois) {
        this.nom = nom;
        this.description = description;
        this.prix = prix;
        this.dureeMois = dureeMois;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrix() { return prix; }
    public void setPrix(BigDecimal prix) { this.prix = prix; }

    public int getDureeMois() { return dureeMois; }
    public void setDureeMois(int dureeMois) { this.dureeMois = dureeMois; }

    public List<Programme> getProgrammes() {
        return programmes;
    }

    public void setProgrammes(List<Programme> programmes) {
        this.programmes = programmes;
    }
}