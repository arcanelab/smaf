<? 
	require("../mysql/connect_to_mysql.inc");
	require("authenticate.inc");

	echo('<response>');
	if ($success) {
		$queryResults = $mysqlConnection->processQuery("SELECT user_id, last_active, uid FROM session WHERE 1");
		foreach ($queryResults as $queryResult) {
			$lastActiveStamp = new DateTime($queryResult[1]);
			$timeoutStamp = new DateTime("now");
			$timeoutStamp->modify("-30 seconds");

			if ($lastActiveStamp < $timeoutStamp) {
				$mysqlConnection->processQuery("DELETE FROM session WHERE user_id='".$queryResult[0]."'");
			} else {
				echo('<contact id="'.$queryResult[0].'" lastActive="'.$lastActiveStamp->format("H:i:s").'"></contact>');
			}
		}
	}
	echo('</response>');
?>