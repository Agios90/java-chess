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

@WebServlet(name = "registergame", urlPatterns = {"/registerGame"})
public class RegisterGame extends HttpServlet {

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
                
                String wtoken,btoken;
                int playerId = 0;
                
                try{
                    User user = (User) request.getSession().getAttribute("user");
                    playerId = (int) request.getSession().getAttribute("id");
                }catch (Exception e){
                    if (playerId == 0) {
                        response.sendRedirect("/chess/pages/errors/GenericError.html");
                    }
                }
                
                String playerColor = request.getParameter("playerColor");
                wtoken = request.getParameter("wtoken");
                btoken = request.getParameter("btoken");
                
                ResultSet rs = conn.prepareStatement("select id from games where wtoken = '" + wtoken + "';")
                            .executeQuery();
                try { 
                    rs.next();
                    int gameid = rs.getInt("id");
                    if (playerColor.equals("WHITE")) {
                        sql = "UPDATE games set wplayerid = "+playerId+" where id="+gameid+";";
                    } else {
                        sql = "UPDATE games set bplayerid = "+playerId+" where id="+gameid+";";
                    }
                } catch (Exception e) {
                    if (playerColor.equals("WHITE")) {
                        sql = "INSERT INTO games (wplayerid,wtoken,btoken) values ('"+playerId+"','"+wtoken+"','"+btoken+"');";
                    } else {
                        sql = "INSERT INTO games (bplayerid,wtoken,btoken) values ('"+playerId+"','"+wtoken+"','"+btoken+"');";
                    }
                }
                
                pstmt = conn.prepareStatement(sql);
                pstmt.executeUpdate();
                
                if (playerColor.equals("WHITE")) {
                    response.sendRedirect("http://51.15.98.160/play#/"+wtoken);
                } else {
                    response.sendRedirect("http://51.15.98.160/play#/"+btoken);
                }

                // Clean-up environment
                rs.close();
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
