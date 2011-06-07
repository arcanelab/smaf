<?
function generateFlexCommand($filename, $fontname, $cfg_application_root) {
	$response = $cfg_application_root . '/flex4sdk/bin/mxmlc  -o ' . $cfg_application_root . '/asset/'.$filename.'_compiled -sp ' . $cfg_application_root . '/asset    -default-size 544 306 -default-frame-rate 36 -default-background-color 0x000000   -library-path ' . $cfg_application_root . '/flex4sdk/frameworks/libs/flex.swc  -library-path ' . $cfg_application_root . '/flex4sdk/frameworks/libs/framework.swc  -library-path ' . $cfg_application_root . '/flex4sdk/frameworks/libs/rpc.swc  -library-path ' . $cfg_application_root . '/flex4sdk/frameworks/libs/utilities.swc -library-path ' . $cfg_application_root . '/flex4sdk/frameworks/locale/en_US  -target-player=10.0.0   -debug=false   -- ' . $cfg_application_root . '/asset/'.$filename.'.as';

	return $response;
}

function generateTemporaryClass($filename, $fontname) {
	$response = "";
	
	$response = '	package {';
	$response .= '';
	$response .= '			import flash.text.Font;';
	$response .= '			import flash.display.Sprite;';
	$response .= '';
	$response .= '			public class '.$filename.' extends Sprite {';
	$response .= '';
	$response .= '			    [Embed(source="'.$filename.'", mimeType="application/x-font-truetype", fontFamily="'.$fontname.'", fontWeight="", unicodeRange="U+0020-U+007E")]';
	$response .= '			    public static var '.$fontname.':Class;';
	$response .= '				'.$fontname.';';
	$response .= '';
	$response .= '				public function '.$filename.'() {}';
	$response .= '';
	$response .= '			}';
	$response .= '		}';

	return $response;
}

	require("../mysql/connect_to_mysql.inc");
	require("../user/authenticate.inc");		                                
	require("../utility/unique_id.inc");		

	$uploadFieldName = "Filedata";
	$assetFolderPath = "../../asset/";
	
	$_FILES[$uploadFieldName]['type'] = "image/jpeg";

	echo("<response>");
	
	$temp_filename = "____uploaded__";
	if (move_uploaded_file($_FILES[$uploadFieldName]['tmp_name'], $assetFolderPath . $temp_filename)) {

		$notYetSet = true;
		while ($notYetSet) {
			$fontID = generate256BitUniqueID();
			$queryResults = $mysqlConnection->processQuery("SELECT uid FROM font WHERE uid = '".$fontID."'");
			if ($queryResults[0][0] != $fontID) {
				$notYetSet = false;
			}
		}
		$fontname = $fontID;
		
		if (substr($_FILES[$uploadFieldName]['name'], - 4, 4) == ".swf") {
			$fontname = substr($_FILES[$uploadFieldName]['name'], 0, -4);
			$fontID = $fontname;
			
			$notYetSet = true;
			while ($notYetSet) {
				$assetID = generate256BitUniqueID();
				$queryResults = $mysqlConnection->processQuery("SELECT uid FROM asset WHERE uid = '".$assetID."'");
				if ($queryResults[0][0] != $assetID) {
					$notYetSet = false;
				}
			}
			$mysqlConnection->processQuery("INSERT INTO asset (uid, filename, type, filesize) VALUES ('".$assetID."', '".$fontname."', '', '')");
			rename($assetFolderPath . $temp_filename, $assetFolderPath.$assetID);

			$mysqlConnection->processQuery("INSERT INTO font (uid, fontname, asset) VALUES ('".$fontID."', '".$_FILES[$uploadFieldName]['name']."', '".$assetID."')");
			echo("<success>1</success>");
		} else {
			$temporaryClassPath = $assetFolderPath . $temp_filename.".as";
			$fh = fopen($temporaryClassPath, 'w') or die("can't open file");
			$classString = generateTemporaryClass($temp_filename, $fontname);
			fwrite($fh, $classString);
			fclose($fh);   
			$commandString = generateFlexCommand($temp_filename, $fontname, $cfg_application_root);

			$shell_response = shell_exec($commandString);      
			if (strpos($shell_response, $temp_filename."_compiled") === false) {
				echo("<success>0</success>");
			} else {
				$notYetSet = true;
				while ($notYetSet) {
					$assetID = generate256BitUniqueID();
					$queryResults = $mysqlConnection->processQuery("SELECT uid FROM asset WHERE uid = '".$assetID."'");
					if ($queryResults[0][0] != $assetID) {
						$notYetSet = false;
					}
				}
				$mysqlConnection->processQuery("INSERT INTO asset (uid, filename, type, filesize) VALUES ('".$assetID."', '".$fontname."', '', '')");
				rename($assetFolderPath . $temp_filename."_compiled", $assetFolderPath.$assetID);

				$mysqlConnection->processQuery("INSERT INTO font (uid, fontname, asset) VALUES ('".$fontID."', '".$_FILES[$uploadFieldName]['name']."', '".$assetID."')");
				echo("<success>1</success>");
			}
			echo("<shellResponse><![CDATA[".$shell_response."]]></shellResponse>");
			unlink($assetFolderPath . $temp_filename);
			unlink($assetFolderPath . $temp_filename.".as");
		}

	} else {
		echo("<success>0</success>");
	}
	
	echo("</response>");
?>