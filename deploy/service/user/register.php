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

	$username = $_POST['username'];
	$email = $_POST['email'];
  	$password = $_POST['password'];

	$notYetSet = true;
	while ($notYetSet) {
		$id = generate256BitUniqueID();
		$queryResults = $mysqlConnection->processQuery("SELECT uid FROM user WHERE uid='$id'");
		if ($queryResults[0][0] != $id) {
			$notYetSet = false;
		}
	}

	send_mail($email, $admin_email, $registration_subject, $registration_body.$username.$registration_body_2.$password.$registration_body_3.$activateURL.$id);
	
	send_mail($supervisor_email, $admin_email, $user_registration_subject.$username, $username.$user_registration_body.$email);
	

	$password = pw_encode($password);


	$mysqlConnection->processQuery("INSERT INTO user (uid, username, password, email) VALUES ('".$id."','".$username."','".$password."','".$email."')");
	
	echo('<response></response>');
?>