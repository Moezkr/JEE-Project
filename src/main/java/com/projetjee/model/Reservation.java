package com.projetjee.model;

import java.sql.Timestamp;


public class Reservation {
    private int id;
    private int userId;
    private int roomId;
    private int formationId;
    private Timestamp startTime;
    private Timestamp endTime;

  
    private String userName;
    private String roomName;
    private String formationNom;

    public Reservation() {}

    public Reservation(int id, int userId, int roomId, int formationId, Timestamp startTime, Timestamp endTime) {
        this.id = id;
        this.userId = userId;
        this.roomId = roomId;
        this.formationId = formationId;
        this.startTime = startTime;
        this.endTime = endTime;
    }

   
    public int getId() { return id; }  
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }

    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }

  
    public int getFormationId() { return formationId; }
    public void setFormationId(int formationId) { this.formationId = formationId; }

   
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public String getFormationNom() { return formationNom; }
    public void setFormationNom(String formationNom) { this.formationNom = formationNom; }
}