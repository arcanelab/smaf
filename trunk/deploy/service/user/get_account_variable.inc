<?                     
	if ($variable)
	{
		$queryResults = $mysqlConnection->processQuery("SELECT value FROM account WHERE (user_id = '" . $user_id . "') AND (variable = '".$variable."')");
		$value = $queryResults[0][0];
	}
?>