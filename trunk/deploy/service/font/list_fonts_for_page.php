<? 
	require("../mysql/connect_to_mysql.inc");
		
	echo('<response>');    
	$parameterArray = explode(",", $_POST['parameters']);
	$_POST['parameters'] = "";      
	$counter = 0;
	foreach ($parameterArray as $parameter) {
		$_POST['parameters'] .= "'".$parameter."'";
		if ($counter < (count($parameterArray) - 1)) {
			$_POST['parameters'] .= ",";
		}
		$counter++;
	}
	$queryResults = $mysqlConnection->processQuery("SELECT uid, fontname, asset FROM font WHERE uid IN (".stripslashes($_POST['parameters']).") ORDER BY fontname");
	foreach($queryResults as $queryResult) {
		echo('<font id="'.$queryResult[0].'" url="http://'.$_SERVER['SERVER_NAME'].'/asset/'.$queryResult[2].'"><![CDATA['.$queryResult[1].']]></font>');
	}

	echo('</response>');
?>
