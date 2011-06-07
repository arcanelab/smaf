<? 
	require("../mysql/connect_to_mysql.inc");

	$queryResults = $mysqlConnection->processQuery("SELECT ip FROM session WHERE uid='".$_POST['pass']."'");
	if (($queryResults[0][0] == $_POST['userip']) && ($queryResults[0][0] != "")) {
		$success = true;
	} else {
		$success = false;		
	}
	
	echo('<success>'.$success.'</success>');
?>