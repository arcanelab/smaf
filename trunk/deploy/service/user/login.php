<? 
	require("../mysql/connect_to_mysql.inc");
	require("../utility/unique_id.inc");		

	function pw_check($password, $stored_value)
	{
	   if (strlen($stored_value) != 50)
	      return FALSE;
	   $stored_seed = substr($stored_value,40,10);
	   if (sha1($stored_seed.$password.$stored_seed).$stored_seed == $stored_value)
	     return TRUE;
	   else
	     return FALSE;
	}
	
	$username = $_POST['username'];
	$queryResults = $mysqlConnection->processQuery("SELECT password, uid, level, active FROM user WHERE username='$username'");
	$level = $queryResults[0][2];

	if (pw_check($_POST['password'], $queryResults[0][0])) {
		if ($queryResults[0][3])
		{
			$user_id = $queryResults[0][1];
			$success = true;
			$notYetSet = true;
			while ($notYetSet) {
				$pass = generate256BitUniqueID();
				$queryResults = $mysqlConnection->processQuery("SELECT uid FROM session WHERE uid='$pass'");
				if ($queryResults[0][0] != $pass) {
					$notYetSet = false;
				}
			}
			$mysqlConnection->processQuery("DELETE FROM session WHERE user_id='".$user_id."'");
			$mysqlConnection->processQuery("INSERT INTO session (uid, user_id, ip, last_active) VALUES ('$pass', '".$user_id."', '".$_SERVER['REMOTE_ADDR']."', NOW())");
		} else {
			$success = false;		
			$inactive = true;		
		}
	} else {
		$success = false;		
	}
	
	echo('<response><success>'.$success.'</success><inactive>'.$inactive.'</inactive><id><![CDATA['.$user_id.']]></id><username><![CDATA['.$username.']]></username><pass><![CDATA['.$pass.']]></pass><level><![CDATA['.$level.']]></level></response>');
?>
