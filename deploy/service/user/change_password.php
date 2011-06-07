<? 
	require("../mysql/connect_to_mysql.inc");
	require("authenticate.inc");

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

	function pw_encode($password)
	{
	   for ($i = 1; $i <= 10; $i++)
	       $seed .= substr('0123456789abcdef', rand(0,15), 1);
	   return sha1($seed.$password.$seed).$seed;
	}

	echo('<response>');
	if ($success)
	{
		$queryResults = $mysqlConnection->processQuery("SELECT password FROM user WHERE uid='".$user_id."'");

		if (pw_check($_POST['oldPassword'], $queryResults[0][0])) {
			$newPassword = pw_encode($_POST['newPassword']);
			$mysqlConnection->processQuery("UPDATE user SET password = '".$newPassword."' WHERE uid = '".$user_id."'");
		} else {
			$success = false;
			$wrongPassword = true;
		}
		
	}

	echo('<success>'.$success.'</success>'.'<wrong>'.$wrongPassword.'</wrong>');
	echo('</response>');
?>
