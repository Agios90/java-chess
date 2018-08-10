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

@WebServlet(name = "loginuser", urlPatterns = {"/loginuser"})
public class LoginService extends HttpServlet {

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
                sql = "SELECT id FROM users where username = ? and password = SHA1(?);";
                pstmt = conn.prepareStatement(sql);
                String username,password;
                username = request.getParameter("inputName");
                password = request.getParameter("inputPassword");
                pstmt.setString(1,username);
                pstmt.setString(2,password);
                ResultSet rs = pstmt.executeQuery();

                if(rs.next()){

                   int id = rs.getInt("id");

                   User user = new User();
                   user.setUsername(username);
                   user.setId(id);
                   
                   request.getSession().setAttribute("user", user);
                   request.getSession().setAttribute("id", id);
                   response.sendRedirect("home");

                }
                else{
                     response.sendRedirect("/chess/pages/errors/UserNotFound.html");

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
