<? 
	require("../mysql/connect_to_mysql.inc");
	require("../utility/unique_id.inc");		

	$username = $_POST['username'];
	$email = $_POST['email'];
	
	$success = true;		

	$usernameResults = $mysqlConnection->processQuery("SELECT uid FROM user WHERE username='$username'");
	if ($usernameResults[0][0])
	{                  
		$success = false;		
		$usernameFound = true;  	
	}

	$emailResults = $mysqlConnection->processQuery("SELECT uid FROM user WHERE email='$email'");
	if ($emailResults[0][0])
	{                  
		$success = false;  
		$emailFound = true;  	
	}

	echo('<response><success>'.$success.'</success><email>'.$emailFound.'</email><username>'.$usernameFound.'</username></response>');
?>
