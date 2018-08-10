package services;

import model.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.sql.Timestamp;
import javax.servlet.RequestDispatcher;

@WebServlet(name = "updategame", urlPatterns = {"/registerWinner"})
public class UpdateGameService extends HttpServlet {

    // JDBC driver name and database URL
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
    static final String DB_URL="jdbc:mysql://localhost/chess";

    //  Database credentials
    static final String USER = "root";
    static final String PASS = "nbuser";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            response.setContentType("text/html");
      
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);

                String sql;
                PreparedStatement pstmt = null;
                sql = "UPDATE games SET winner = ?, winnerid = ? WHERE wtoken = ? ";
                pstmt = conn.prepareStatement(sql);
                String winner, wtoken;
                int winnerId = 0;
                String gameType = "";
                winner = request.getParameter("winner");
                wtoken = request.getParameter("wtoken");
                boolean isAlreadyRegistered = false;
                
                if (winner.equals("WHITE")) {
                    ResultSet rs = conn.prepareStatement("select wplayerid,gametype,winnerid from games where wtoken = '" + wtoken + "';")
                            .executeQuery();
                    if (rs.next()) {
                        winnerId = rs.getInt("wplayerid");
                        gameType = rs.getString("gametype");
                        if (rs.getInt("winnerid") != 0) isAlreadyRegistered = true;
                        rs.close();
                    }
                } else {
                    ResultSet rs = conn.prepareStatement("select bplayerid,gametype,winnerid from games where wtoken = '" + wtoken + "';")
                            .executeQuery();
                    if (rs.next()) {
                        winnerId = rs.getInt("bplayerid");
                        gameType = rs.getString("gametype");
                        if (rs.getInt("winnerid") != 0) isAlreadyRegistered = true;
                        rs.close();
                    }
                }
                
                pstmt.setString(1,winner);
                pstmt.setInt(2,winnerId);
                pstmt.setString(3,wtoken);
                pstmt.executeUpdate();
                
                if (!isAlreadyRegistered) {
                    if (gameType.equals("tournament")) {
                        conn.prepareStatement("UPDATE users SET twins = twins + 1 WHERE id="+winnerId+";")
                                .executeUpdate();
                    } else {
                        conn.prepareStatement("UPDATE users SET cwins = cwins + 1 WHERE id="+winnerId+";")
                                .executeUpdate();
                    }
                }
                
                if (gameType.equals("tournament")) {
                
                    String round = "";
                    int tourId = 0;
                    String winnerName = "TBD";
                    ResultSet rs = conn.prepareStatement("select tour_id, round from games where wtoken = '" + wtoken + "';")
                                .executeQuery();
                    if (rs.next()) {
                        round = rs.getString("round");
                        tourId = rs.getInt("tour_id");
                        rs.close();
                    }
                    
                    rs = conn.prepareStatement("select username from users where id = " + winnerId + ";")
                                .executeQuery();
                    if (rs.next()) {
                        winnerName = rs.getString("username");
                        rs.close();
                    }

                    switch (round) {
                        case "QF1" : sql = "UPDATE games SET wplayerid = "+winnerId+" where round = 'SF1' and tour_id="+tourId+";";
                                     break;
                        case "QF2" : sql = "UPDATE games SET bplayerid = "+winnerId+" where round = 'SF1' and tour_id="+tourId+";";
                                     break;
                        case "QF3" : sql = "UPDATE games SET wplayerid = "+winnerId+" where round = 'SF2' and tour_id="+tourId+";";
                                     break;
                        case "QF4" : sql = "UPDATE games SET bplayerid = "+winnerId+" where round = 'SF2' and tour_id="+tourId+";";
                                     break;
                        case "SF1" : sql = "UPDATE games SET wplayerid = "+winnerId+" where round = 'F' and tour_id="+tourId+";";
                                     break;
                        case "SF2" : sql = "UPDATE games SET bplayerid = "+winnerId+" where round = 'F' and tour_id="+tourId+";";
                                     break;  
                        case "F" :   sql = "UPDATE tournaments SET winner = '"+winnerName+"' where id="+tourId+";";  
                                     break;
                    }
                    pstmt = conn.prepareStatement(sql);
                    pstmt.executeUpdate();
                }

                response.sendRedirect("/chess/home");

                // Clean-up environment
                
                pstmt.close();
                conn.close();
                } catch(SQLException se) {
                //Handle errors for JDBC
                out.println(se.toString());
                
            } catch(Exception e) {
                //Handle errors for Class.forName
                out.println(e.toString());
            } 
        } //end try

    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
