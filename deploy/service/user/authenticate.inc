<? 
	$queryResults = $mysqlConnection->processQuery("SELECT ip, user_id FROM session WHERE uid='".$_POST['pass']."'");
	$levelResults = $mysqlConnection->processQuery("SELECT level, username FROM user WHERE uid='".$queryResults[0][1]."'");
	if (($queryResults[0][0] == $_SERVER['REMOTE_ADDR']) && ($queryResults[0][0] != "")) {
		$success = true;
		$user_id = $queryResults[0][1];
		$level = $levelResults[0][0];
		$username = $levelResults[0][1];
		require("update_session.inc");
	}
	// flypress
	//
	// if ($success != true) {
	// 	require("authenticate_editor.inc");
	// }
?>