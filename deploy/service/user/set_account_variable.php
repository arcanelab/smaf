<? 
	require("../mysql/connect_to_mysql.inc");
	require("authenticate.inc");
	if ($success)
	{
		$variableResults = $mysqlConnection->processQuery("SELECT variable FROM account WHERE (variable = '".$_POST['variable']."') AND (user_id = '".$user_id."')");
		if ($variableResults[0][0] == $_POST['variable'])
		{
			$mysqlConnection->processQuery("UPDATE account SET value = '".$_POST['value']."' WHERE (variable = '".$_POST['variable']."') AND (user_id = '".$user_id."')");
		} else {
			$mysqlConnection->processQuery("INSERT INTO account (user_id, variable, value) VALUES ('".$user_id."','".$_POST['variable']."','".$_POST['value']."')");
		}
	}
	echo('<response><success>'.$success.'</success></response>');

?>
