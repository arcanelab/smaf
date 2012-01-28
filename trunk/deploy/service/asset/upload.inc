<?
	$uploadFieldName = "Filedata";
	$assetFolderPath = "../../asset/";

	$_FILES[$uploadFieldName]['type'] = "image/jpeg";

	$notYetSet = true;
	while ($notYetSet) {
		$id = generateUniqueID();
		$queryResults = $mysqlConnection->processQuery("SELECT uid FROM asset WHERE uid='$id'");
		if ($queryResults[0][0] != $id) {
			$notYetSet = false;
		}
	}

	if (move_uploaded_file($_FILES[$uploadFieldName]['tmp_name'], $assetFolderPath . $id)) {
		$mysqlConnection->processQuery("INSERT INTO asset (uid, filename, type, filesize) VALUES ('$id','".$_FILES[$uploadFieldName]['name']."','".$_FILES[$uploadFieldName]['type']."', ".$_FILES[$uploadFieldName]['size'].")");
	
		echo("<asset>");
		echo("	<uid>" . $id . "</uid>");
		echo("	<filename><![CDATA[" . $_FILES[$uploadFieldName]['name'] . "]]></filename>");
		echo("	<type><![CDATA[" . $_FILES[$uploadFieldName]['type'] . "]]></type>");
		echo("	<filesize>" . $_FILES[$uploadFieldName]['size'] . "</filesize>");
		echo("</asset>");
	}
?>