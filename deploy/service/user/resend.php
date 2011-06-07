<? 
	require("../mysql/connect_to_mysql.inc");
	require("../utility/unique_id.inc");		

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
	$queryResults = $mysqlConnection->processQuery("SELECT email, uid FROM user WHERE username='$username'");


	send_mail($queryResults[0][0], $admin_email, $registration_subject, $registration_body.$username.$registration_body_3.$activateURL.$queryResults[0][1]);
	
	echo('<response></response>');
?>