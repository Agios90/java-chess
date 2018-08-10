<%@ page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
User user = new User();
String username = "";
int id = 0;
try{
    user = (User) session.getAttribute("user"); 
    username = user.getUsername();
    id = (int) session.getAttribute("id");
}catch (Exception e){
    if (username == "" || id == 0) {
        response.sendRedirect("/chess/pages/errors/GenericError.html");
    }
}
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <title>Home</title>
        <style>
            body {
                background-color: #f6f7f8;
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
                <li class="active"><a href="#">Home</a></li>
                <li><a href="login">Sign In</a></li>
                <li><a href="register">Register</a></li>
                <li><a href="http://51.15.98.160:3000/#/">Play</a>
                <li><a href="tournaments">Tournaments</a></li>    
              </ul>
            </div>
        </nav>
        <div class="container">
            <div class="page-header">
                <h1>Welcome <%= username %>!</h1>      
            </div>
            <h4>You have <%= user.getWins()[0] %> casual wins and <%= user.getWins()[1] %> tournament wins.</h4>
        </div>
    </body>
</html>
