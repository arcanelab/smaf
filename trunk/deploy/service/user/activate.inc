<?

require("../mysql/connect_to_mysql.inc");

$uid = $_GET['uid'];
$queryResults = $mysqlConnection->processQuery("SELECT uid, username FROM user WHERE uid='$uid'");

if ($queryResults[0][0])
{                  
	$mysqlConnection->processQuery("UPDATE user SET active = '1' WHERE uid = '".$uid."'");
}

?>