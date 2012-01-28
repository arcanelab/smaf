<? 
	require("../mysql/connect_to_mysql.inc");
	require("../user/authenticate.inc");		

	echo('<response>');
	echo('<success>');

	require("delete.inc");		
	if ($success) {		
		echo('1');
	} else {
		echo('0');
	}
	echo('</success>');
	echo('</response>');
		
?>
