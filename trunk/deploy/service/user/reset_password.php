<? 
	require("../mysql/connect_to_mysql.inc");
	require("../utility/unique_id.inc");		

	function pw_encode($password)
	{
	   for ($i = 1; $i <= 10; $i++)
	       $seed .= substr('0123456789abcdef', rand(0,15), 1);
	   return sha1($seed.$password.$seed).$seed;
	}

	function send_mail($to, $from, $subject, $message, $headers = '') {
		$headers .= "From: $from\n";
		$headers .= "Content-Type: text/plain; charset=\"iso-8859-1\"\n";
		$headers .= "Content-Transfer-Encoding: 7bit\n\n";

		if(mail($to, $subject, $message, $headers)) {
			$success = true;
		} else {
			$success = false;
		}
		return $success;
	} 

	$reminder = $_POST['reminder'];
	$queryResults = $mysqlConnection->processQuery("SELECT uid, email FROM user WHERE (username='$reminder') OR (email='$reminder')");
	
	if ($queryResults[0][0])
	{                  
		$uid = $queryResults[0][0];
		$email = $queryResults[0][1];
		$success = true;		
		for ($i = 1; $i <= 8; $i++)
			$newPassword .= substr('0123456789abcdef', rand(0,15), 1);
			
		send_mail($email, $admin_email, $password_reset_subject, $password_reset_body.$newPassword);
			
		$newPassword = pw_encode($newPassword);
		$mysqlConnection->processQuery("UPDATE user SET password = '".$newPassword."' WHERE uid = '".$uid."'");
	} else {
		$success = false;		
	}

	echo('<response><success>'.$success.'</success></response>');
?>
