<? 
	$assetFolderPath = "../../asset/";
	
	echo('<response>');
	echo('<success>');
	if ($success) {		
		$mysqlConnection->processQuery("DELETE FROM asset WHERE uid = '".$_POST['uid']."'");
		unlink($assetFolderPath.$_POST['uid']);
		echo('1');
	} else {
		echo('0');
	}
	echo('</success>');
	echo('</response>');
?>
