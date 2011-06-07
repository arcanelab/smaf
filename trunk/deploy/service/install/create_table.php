<? 
	require("../mysql/connect_to_mysql.inc");            
	$file = fopen ("smaf_schema.sql", "r", false);
	if (!$file) {
		$success = false;
	    exit;
	} else {
		while (!feof ($file)) {
		    $query_string .= fgets ($file, 1024);
		}           
	}               
	fclose($file);                                
	
	$mysqlConnection->processQuery($query_string);
?>