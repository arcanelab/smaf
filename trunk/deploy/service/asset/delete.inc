<? 
	$assetFolderPath = "../../asset/";
	
	$mysqlConnection->processQuery("DELETE FROM asset WHERE uid = '".$_POST['uid']."'");
	if (file_exists($assetFolderPath.$_POST['uid']))
	{
		unlink($assetFolderPath.$_POST['uid']);
	}
?>
