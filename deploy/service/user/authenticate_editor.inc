<? 
	$postdata = http_build_query(array('pass' => $_POST['pass'],'userip' => $_SERVER['REMOTE_ADDR']));
	$opts = array('http' => array('method' => 'POST','header' => 'Content-type: application/x-www-form-urlencoded','content' => $postdata));
	$context = stream_context_create($opts);
                   
                          
	$file = fopen($cfg_edit_service.$cfg_publish_authenticate, "r", false, $context);
	if (!$file) {
		$success = false;
	    exit;
	} else {
		while (!feof ($file)) {
		    $content .= fgets ($file, 1024);
		}                          
		$chunks = explode("<success>", $content);
		$content = $chunks[1];
		$chunks = explode("</success>", $content);		
	}               
	fclose($file);                                
	
	if ($chunks[0] == "1") {
		$mysqlConnection->processQuery("INSERT INTO session (uid, ip) VALUES ('".$_POST['pass']."', '".$_SERVER['REMOTE_ADDR']."')");
		$success = true;
	} else {
		$success = false;
	}
?>