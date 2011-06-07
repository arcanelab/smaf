<?
	class MysqlConnection {
		var $host;
		var $userName;
		var $password;
		var $database;
		
		function MysqlConnection($host, $userName, $password, $database) {
			$this->host = $host;
			$this->userName = $userName;
			$this->password = $password;
			$this->database = $database;
			$this->establishConnection();
		}
	
		function establishConnection() {
			mysql_connect ($this->host, $this->userName, $this->password);
			mysql_select_db ($this->database);
		}
	
		function processQuery($p_queryString) {
			$queryResult = mysql_query($p_queryString);
			if (gettype($queryResult) == "resource") {
				$results = array();
				while ($resultItem = mysql_fetch_array($queryResult)) {
					array_push($results, $resultItem);
				}
			} else {
				if (gettype($queryResult) == "boolean") {
					$results = array();
					array_push($results, $queryResult);
				} else {
					$results = $queryResult;
				}
			}
			return $results;
		}
	}
	
	require("../configuration/configuration.inc");
	$mysqlConnection = new MysqlConnection($mysql_host, $mysql_user, $mysql_pass, $mysql_database);
?>