<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page import="model.User"%>
<%@ page import="model.Tournament"%>
<%@ page import="model.Game"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
User user = new User();
String username = "";
int id = 0;
    
final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
final String DB_URL="jdbc:mysql://localhost/chess";
final String USER = "root";
final String PASS = "nbuser";
Class.forName("com.mysql.jdbc.Driver");
Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
String sql = "select * from tournaments";
String sql2,sql3;
ResultSet rs;

ArrayList<Tournament> tournaments = new ArrayList<Tournament>();
ArrayList<Game> games = new ArrayList<Game>();
try{
    user = (User) session.getAttribute("user"); 
    username = user.getUsername();
    id = (int) session.getAttribute("id");

    try {

        rs = conn.prepareStatement(sql).executeQuery();
        while (rs.next()) {
            tournaments.add(new Tournament(rs.getInt("id"),rs.getString("name"),rs.getInt("size"),rs.getString("winner"),rs.getDate("created")));
        }
    } catch(Exception e) {
        response.sendRedirect("/chess/pages/errors/GenericError.html");
    }   
        
}catch (Exception e){
    response.sendRedirect("/chess/pages/errors/GenericError.html");
}
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tournaments</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <style>
            .bold {
                font-weight: bold;
                
            }
            
            .bold:before {
                content: " > "
            }
            .bold:after {
                content: " < "
            }
           main{
             display:flex;
             flex-direction:row;
           }
           .round{
             display:flex;
             flex-direction:column;
             justify-content:center;
             width:200px;
             list-style:none;
             padding:0;
           }
             .round .spacer{ flex-grow:1; }
             .round .spacer:first-child,
             .round .spacer:last-child{ flex-grow:.5; }

             .round .game-spacer{
               flex-grow:1;
             }

           /*
            *  General Styles
           */
           body{
             background-color: #f6f7f8;
           }

           li.game{
             padding-left:20px;
           }

             li.game.winner{
               font-weight:bold;
             }
             li.game span{
               float:right;
               margin-right:5px;
             }

             li.game-top{ border-bottom:1px solid #aaa; }

             li.game-spacer{ 
               border-right:1px solid #aaa;
               min-height:40px;
             }

             li.game-bottom{ 
               border-top:1px solid #aaa;
             }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-default">
            <div class="container-fluid">
              <div class="navbar-header">
                <a class="navbar-brand">Chess App</a>
              </div>
              <ul class="nav navbar-nav">
                <li><a href="home">Home</a></li>
                <li><a href="login">Sign In</a></li>
                <li><a href="register">Register</a></li>
                <li><a href="http://localhost:3000/#/">Play</a>
                <li class="active"><a href="#">Tournaments</a></li>    
              </ul>
            </div>
        </nav>
        <div class="container">
            <div class="page-header">
                <h1>Tournaments</h1>
            </div>
            <% for(int i=0;i<tournaments.size();i++) {
                games = new ArrayList<Game>();
                sql = "select * from games where tour_id = " + tournaments.get(i).getId()+";";
                rs = conn.prepareStatement(sql).executeQuery();
                while (rs.next()) {
                    sql2 = "select username from users where id ="+rs.getInt("wplayerid")+";";
                    sql3 = "select username from users where id ="+rs.getInt("bplayerid")+";";
                    String wPlayerName = "TBD";
                    String bPlayerName = "TBD";
                    ResultSet rs2=conn.prepareStatement(sql2).executeQuery();
                    rs2.next();
                    if (rs.getInt("wplayerid")!=0) {
                        wPlayerName = rs2.getString("username");
                    }
                    ResultSet rs3=conn.prepareStatement(sql3).executeQuery();
                    rs3.next();
                    if (rs.getInt("bplayerid")!=0) {
                        bPlayerName = rs3.getString("username");
                    }
                    games.add(new Game(
                            rs.getInt("id"),
                            rs.getString("gametype"),
                            rs.getString("wtoken"),
                            rs.getString("btoken"),
                            rs.getInt("wplayerid"),
                            rs.getInt("bplayerid"),
                            rs.getString("winner"),
                            rs.getInt("winnerid"),
                            rs.getInt("tour_id"),
                            rs.getString("round"),
                            wPlayerName,
                            bPlayerName
                    ));
                }
                tournaments.get(i).setGames(games);
            }    
            %>
                
            <div class="panel-group" id="accordion">
                <% for(int i=0;i<tournaments.size();i++) { %>
                <div class="panel panel-default">
                  <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse<%=tournaments.get(i).getId() %>">
                            <b>
                            <%=tournaments.get(i).getId() %>.&nbsp;
                            <%=tournaments.get(i).getName() %>
                            </b>
                        </a>
                    </h4>
                  </div>
                  <div id="collapse<%=tournaments.get(i).getId() %>" class="panel-collapse collapse">
                    <div class="panel-body">
                        <h1 class="page-header"><%=tournaments.get(i).getName() %></h1>
                        <h4>Created on:&nbsp;<%=tournaments.get(i).getCreated() %></h4>
                        <h4>Size:&nbsp;<%=tournaments.get(i).getSize() %></h4>
                        <h4>Winner:&nbsp;<%=tournaments.get(i).getWinner() %></h4>
                        
                        <main id="tournament">
                                
                                <ul class="round round-2">
                                        <li class="spacer">&nbsp;</li>

                                        <li class="game game-top">
                                            <%= tournaments.get(i).getGames().get(0).getwPlayerName() %> 
                                            <% if (
                                                   tournaments.get(i).getGames().get(0).getwPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(0).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold" href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(0).getwToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>
                                        <li class="game game-spacer">&nbsp;</li>
                                        <li class="game game-bottom "><%= tournaments.get(i).getGames().get(0).getbPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(0).getbPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(0).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(0).getbToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>

                                        <li class="spacer">&nbsp;</li>

                                        <li class="game game-top"><%= tournaments.get(i).getGames().get(1).getwPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(1).getwPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(1).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(1).getwToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>
                                        <li class="game game-spacer">&nbsp;</li>
                                        <li class="game game-bottom "><%= tournaments.get(i).getGames().get(1).getbPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(1).getbPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(1).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(1).getbToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>

                                        <li class="spacer">&nbsp;</li>

                                        <li class="game game-top "><%= tournaments.get(i).getGames().get(2).getwPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(2).getwPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(2).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(2).getwToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>
                                        <li class="game game-spacer">&nbsp;</li>
                                        <li class="game game-bottom"><%= tournaments.get(i).getGames().get(2).getbPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(2).getbPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(2).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(2).getbToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>

                                        <li class="spacer">&nbsp;</li>

                                        <li class="game game-top "><%= tournaments.get(i).getGames().get(3).getwPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(3).getwPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(3).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(3).getwToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>
                                        <li class="game game-spacer">&nbsp;</li>
                                        <li class="game game-bottom"><%= tournaments.get(i).getGames().get(3).getbPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(3).getbPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(3).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(3).getbToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>

                                        <li class="spacer">&nbsp;</li>
                                </ul>
                                <ul class="round round-3">
                                        <li class="spacer">&nbsp;</li>

                                        <li class="game game-top"><%= tournaments.get(i).getGames().get(4).getwPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(4).getwPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(4).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(4).getwToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>
                                        <li class="game game-spacer">&nbsp;</li>
                                        <li class="game game-bottom "><%= tournaments.get(i).getGames().get(4).getbPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(4).getbPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(4).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(4).getbToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>

                                        <li class="spacer">&nbsp;</li>

                                        <li class="game game-top "><%= tournaments.get(i).getGames().get(5).getwPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(5).getwPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(5).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(5).getwToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>
                                        <li class="game game-spacer">&nbsp;</li>
                                        <li class="game game-bottom"><%= tournaments.get(i).getGames().get(5).getbPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(5).getbPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(5).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(5).getbToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>

                                        <li class="spacer">&nbsp;</li>
                                </ul>
                                <ul class="round round-4">
                                        <li class="spacer">&nbsp;</li>

                                        <li class="game game-top"><%= tournaments.get(i).getGames().get(6).getwPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(6).getwPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(6).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(6).getwToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>
                                        <li class="game game-spacer">&nbsp;</li>
                                        <li class="game game-bottom "><%= tournaments.get(i).getGames().get(6).getbPlayerName() %> 
                                        <% if (
                                                   tournaments.get(i).getGames().get(6).getbPlayerName().equals(username) &&
                                                   tournaments.get(i).getGames().get(6).getWinner().equals("TBD") 
                                                  ) 
                                                { %>
                                                <a class="bold"  href="http://localhost:3000/#/<%= tournaments.get(i).getGames().get(6).getbToken() %>">Enter Game</a>
                                            <% } %>
                                        </li>

                                        <li class="spacer">&nbsp;</li>
                                </ul>	
                                <ul class="round round-5">
                                        <li class="game game-top">
                                            <span > 
                                                <%=tournaments.get(i).getWinner() %> &nbsp;
                                                <b style="color:gold"> > Winner!</b>
                                                <img src="https://i.imgur.com/w6WlYEn.png" height="36" width="48"></img>
                                            </span>
                                        </li>
                                </ul>
                                <br />
                                <br />
                            </main>
                    </div>
                  </div>
                </div>
            <% } %>
            </div> 
           
        </div>
    </body>
</html>
