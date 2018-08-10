<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <meta charset="UTF-8"/>
	<title>Login</title>
        <style>
            .form-signin {
                margin: 0 auto;
                margin-top:25%;
                max-width:500px;
            }

            .form-signin > * {
                margin:0.7rem;
            }
            body {
                background-color: #f6f7f8;
            }
        </style>
</head>
<body>
    
    <nav class="navbar navbar-default">
        <div class="container-fluid">
          <div class="navbar-header">
            <a class="navbar-brand" href="#">Chess App</a>
          </div>
          <ul class="nav navbar-nav">
            <li class="active"><a href="#">Sign In</a></li>
            <li><a href="register">Register</a></li>
          </ul>
        </div>
    </nav>

    <div class="container">
        <form class="form-signin" action="loginuser" method="post">
            <input type="text" name ="inputName" id="inputName" class="form-control" placeholder="Username" required autofocus>
            <input type="password" name="inputPassword" id="inputPassword" class="form-control" placeholder="Password" required>

            <button id="searchbtn" class="btn btn-lg btn-primary btn-block btn-signin" type="submit">Sign in</button>
        </form>
    </div>
    
	
</body>
</html>