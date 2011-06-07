<? 
	$mysqlConnection->processQuery("UPDATE session SET last_active = NOW() WHERE uid = '".$_POST['pass']."'");
?>