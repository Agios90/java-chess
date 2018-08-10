<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <meta charset="UTF-8"/>
	<title>Register</title>
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
            <li><a href="login">Sign In</a></li>
            <li class="active"><a href="#">Register</a></li>
          </ul>
        </div>
    </nav>

    <div class="container">
        <form class="form-signin" action="registeruser" method="post">
            <input type="text" name ="inputName" id="inputName" class="form-control" placeholder="Username" required autofocus>
            <input onkeyup='check();' type="password" name="inputPassword" id="inputPassword" class="form-control" placeholder="Password" required>
            <input onkeyup='check();' type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Confirm Password" required>

            <button id="searchbtn" class="btn btn-lg btn-primary btn-block btn-signin" type="submit">Register</button>
        </form>
    </div>
    
    <script>
        var check = function() {
            let btn = document.getElementById("searchbtn");
            if (document.getElementById('inputPassword').value ==
              document.getElementById('confirmPassword').value) {
              btn.disabled = false;
            } else {
              btn.disabled = true;
            }
          }
    </script>

</body>
</html>