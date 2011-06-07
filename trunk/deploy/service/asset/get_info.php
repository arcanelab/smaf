<? 
	require("../mysql/connect_to_mysql.inc");

	echo('<response>');

	$queryResults = $mysqlConnection->processQuery("SELECT filename, type, filesize FROM asset WHERE uid = '" . $_POST['uid'] . "'");
	echo('<filename><![CDATA[' . $queryResults[0][0] . ']]></filename>');
	echo('<type><![CDATA[' . $queryResults[0][1] . ']]></type>');
	echo('<filesize>' . $queryResults[0][2] . '</filesize>');

	echo('</response>');
?>