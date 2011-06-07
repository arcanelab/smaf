<? 
	require("../mysql/connect_to_mysql.inc");
		
	echo('<response>');

	$queryResults = $mysqlConnection->processQuery("SELECT asset FROM font WHERE uid = '".$_POST['uid']."'");
	$mysqlConnection->processQuery("DELETE FROM font WHERE uid = '".$_POST['uid']."'");
	$_POST['uid'] = $queryResults[0][0];
	require("../asset/delete.inc");		

	echo('</response>');
?>
