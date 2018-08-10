/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 *
 * @author Angelos
 */
public class User {
    
    private String username;
    private int id;
    private int[] wins = new int[2];

    public int[] getWins() {
        String sql = "SELECT id,cwins,twins FROM users where id = '"+this.id+"';";
        final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
        final String DB_URL="jdbc:mysql://localhost/chess";
        final String USER = "root";
        final String PASS = "nbuser";
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            if (rs.next()) {
                this.wins[0] = rs.getInt("cwins");
                this.wins[1] = rs.getInt("twins");
            }
        } catch(Exception e) {
            //Do nothing
        }   
        return this.wins;
    }
    
    public User(){
        this.setUsername("");
        this.setId(0);
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
        
}
