<? 
	require("../mysql/connect_to_mysql.inc");

	$queryResults = $mysqlConnection->processQuery("SELECT uid FROM session WHERE uid='".$_POST['pass']."'");
	if (($queryResults[0][0] == $_POST['pass']) && ($_POST['pass'] != "")) {
		$mysqlConnection->processQuery("DELETE FROM session WHERE uid='".$_POST['pass']."'");
		$success = true;
	} else {
		$success = false;		
	}
	echo('<response><success>'.$success.'</success></response>');
?>
