<? 
	require("../mysql/connect_to_mysql.inc");
		
	echo('<response>');

	$queryResults = $mysqlConnection->processQuery("SELECT uid, fontname, asset FROM font WHERE 1 ORDER BY fontname");
	foreach($queryResults as $queryResult) {
		echo('	<font id="'.$queryResult[0].'" url="http://'.$_SERVER['SERVER_NAME']."/asset/".$queryResult[2].'"><![CDATA['.$queryResult[1].']]></font>');
	}

	echo('</response>');
?>
