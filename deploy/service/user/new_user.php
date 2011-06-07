<?php
$debug = 0;









// if($debug){
//    if (!($_SERVER['REQUEST_METHOD'] == "GET" || $_SERVER['REQUEST_METHOD'] == "POST"))
//       die("ERROR:  This script should only be referenced from a GET or POST METHOD.<br>");
// } else {
//    if ($_SERVER['REQUEST_METHOD'] != "POST")
//       die("ERROR:  This script should only be referenced from POST METHOD.<br>");
// }


// foreach ($_REQUEST as $key => $value) {
//    if (preg_match("/[^0-9a-zA-Z\|\.\-\/\@\_]/", $_REQUEST[$key])) {
//      header("X-Powered-By: http://www.epoch.com", true, 500);
//      echo "<Font color=red size=4>Please make sure there are no special characters in your
// request.</FONT><BR>";
//      echo  "\$_REQUEST[$key] : ".htmlspecialchars ($_REQUEST[$key])." <BR>";
//      die();
//    } 
// }


  
/* These variables must be customized */
// Host on which the database server is running.
$db['host'] = 'localhost';

// The name of the schema or database where the authentication information is stored.
$db['schema'] = 'postprs_post';

// The table that holds the users' authentication information.
$db['table'] = 'user';

// User to connect to the database as.
$db['user'] = 'postprs_post';

// Password for the connection.
$db['password'] = 'p0st4g3';

/* 
   Below here is where the configurationuration for the column names in the table goes.
   If Epoch is the only one accessing the authentication tables, then this information does not need to
   be changed.  However, if it is a shared table, it may need to be updated.
 */

$db['username_column'] = 'username';
$db['password_column'] = 'password';

// This can be changed to reflect the encryption function that is used in MySQL to encrypt the database.
$db['password_encryption_function'] = '';

/* End of configurationuration */

// if ( $debug ) {
// 
//    if ($_SERVER['REQUEST_METHOD'] == "GET" || $_SERVER['REQUEST_METHOD'] == "POST")
//      {
//       // Assign the necessary values to variables.
//       $username = $_REQUEST['username'];
//       $password = $_REQUEST['password'];
//       $command  = $_REQUEST['command'];
//       $ht_file  = $_REQUEST['ht_file'];
//    }
//    else
//       die("ERROR:  This script should only be referenced from a GET or POST METHOD.\n");
// 
// } else {
//    if ($_SERVER['REQUEST_METHOD'] != "POST")
//       die("ERROR:  This script should only be referenced from POST METHOD.\n");
// 
//    // Assign the necessary values to variables.
//    $username = "shino"; //$_POST['username'];
//    $password = "4"; //$_POST['password'];
//    $command  = "ADD"; //$_POST['command'];
//    $ht_file  = ""; //$_POST['ht_file'];
// }

$username = "phil"; //$_POST['username'];
$password = "p0p0ff"; //$_POST['password'];
$command  = "ADD"; //$_POST['command'];
$ht_file  = ""; //$_POST['ht_file'];


if ( $debug == 1 ) { echo "DATA is $command, $username, $password, $ht_file\n"; }


// Get the connection to the database.
$dbh = getDbConnection();

switch ($command) {

  /* CHECK if the user exists */
 case 'CHECK':
   echo userExists($username) ? "FOUND" : "NOT_FOUND";
   break;

 /* ADD a new user */
 case 'ADD':
   addUser( $username, $password );
   echo "ADDED";
   break;

   /* DELETE a user */
 case 'DELETE':
   deleteUser( $username );
   echo "DELETED $username";
   break;

}

// Close the database connection.
mysql_close ($dbh);


/* Functions */
function generate256BitUniqueID() {
	for ($i = 0; $i < 64; $i++)
       $id .= substr('0123456789abcdefghijklmnopqrstuvwxyz', rand(0,35), 1);
		return $id;
}

function userExists( $username ) {
  global $dbh, $db;
  $sql = "SELECT " . $db['password_column'] . " FROM " . $db['table'] . " WHERE " . $db['username_column'] . " = '" . mysql_escape_string($username) . "'";
  $sql_result = mysql_query($sql,$dbh) or die ("Couldn't execute query.");
  $row = mysql_fetch_array($sql_result);

  return empty($row[$db['password_column']]) ? false : true;
}

function addUser( $username, $password ) {
  global $dbh;
  global $db;
  // Check to see if the password is being stored using an encryption function, and if so add that function around the password.
	$password_value = pw_encode($password);
  if (!empty($db['password_encryption_function'])) {
    $password_value = $db['password_encryption_function'] . "('" . mysql_escape_string($password_value) . "')";
  } else {
    $password_value = "'" . mysql_escape_string($password_value) . "'";
  }  

	$notYetSet = true;
	while ($notYetSet) {
		$id = generate256BitUniqueID();
		$queryResults = mysql_query("SELECT uid FROM user WHERE uid='$id'",$dbh);
		if ($queryResults[0][0] != $id) {
			$notYetSet = false;
		}
	}


  $sql = "REPLACE INTO " . $db['table'] . " (" . $db['username_column'] . ", " . $db['password_column'] . ", uid) VALUES ('" . mysql_escape_string($username) . "', " . $password_value . ", '" . $id . "')";
  $res = mysql_query($sql,$dbh) or die ("Couldn't add user.");
  
  return $res;
}

function deleteUser( $username ) {
  global $dbh;
  global $db;
  $sql = "DELETE FROM " . $db['table'] . " WHERE " . $db['username_column'] . " = '" . mysql_escape_string($username) . "'";
  $res = mysql_query($sql,$dbh) or die ("Couldn't delete user.");        
  return $res;
}

function getDbConnection() {
  global $db;
  // This creates the database connection
  $conn = mysql_connect($db['host'], $db['user'], $db['password']) or die ("Couldn't connect to the server.");

  // This selects the database
  mysql_select_db($db['schema'], $conn) or die ("Couldn't select database.");

  return $conn;
}

function pw_encode($password)
{
   for ($i = 1; $i <= 10; $i++)
       $seed .= substr('0123456789abcdef', rand(0,15), 1);
   return sha1($seed.$password.$seed).$seed;
}


?>
