/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

/**
 *
 * @author Angelos
 */
public class Game {

    public Game(int id, String gameType, String wToken, String bToken, int wPlayerId,
            int bPlayerId, String winner, int winnerId, int tour_id, String round, String wPlayerName, String bPlayerName) {
        this.id = id;
        this.gameType = gameType;
        this.wToken = wToken;
        this.bToken = bToken;
        this.wPlayerId = wPlayerId;
        this.bPlayerId = bPlayerId;
        this.winner = winner;
        this.winnerId = winnerId;
        this.tour_id = tour_id;
        this.round = round;
        this.wPlayerName = wPlayerName;
        this.bPlayerName = bPlayerName;
    }
    
    
    
    private int id;
    private String gameType;
    private String wToken;
    private String bToken;
    private int wPlayerId;
    private int bPlayerId;
    private String winner;
    private int winnerId;
    private int tour_id;
    private String round;
    private String wPlayerName;
    private String bPlayerName;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getGameType() {
        return gameType;
    }

    public void setGameType(String gameType) {
        this.gameType = gameType;
    }

    public String getwToken() {
        return wToken;
    }

    public void setwToken(String wToken) {
        this.wToken = wToken;
    }

    public String getbToken() {
        return bToken;
    }

    public void setbToken(String bToken) {
        this.bToken = bToken;
    }

    public int getwPlayerId() {
        return wPlayerId;
    }

    public void setwPlayerId(int wPlayerId) {
        this.wPlayerId = wPlayerId;
    }

    public int getbPlayerId() {
        return bPlayerId;
    }

    public void setbPlayerId(int bPlayerId) {
        this.bPlayerId = bPlayerId;
    }

    public String getWinner() {
        return winner;
    }

    public void setWinner(String winner) {
        this.winner = winner;
    }

    public int getWinnerId() {
        return winnerId;
    }

    public void setWinnerId(int winnerId) {
        this.winnerId = winnerId;
    }

    public int getTour_id() {
        return tour_id;
    }

    public void setTour_id(int tour_id) {
        this.tour_id = tour_id;
    }

    public String getRound() {
        return round;
    }

    public void setRound(String round) {
        this.round = round;
    }

    public String getwPlayerName() {
        return wPlayerName;
    }

    public void setwPlayerName(String wPlayerName) {
        this.wPlayerName = wPlayerName;
    }

    public String getbPlayerName() {
        return bPlayerName;
    }

    public void setbPlayerName(String bPlayerName) {
        this.bPlayerName = bPlayerName;
    }
    
}
