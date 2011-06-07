<? 
	function generate256BitUniqueID() {
		for ($i = 0; $i < 64; $i++)
	       $id .= substr('0123456789abcdefghijklmnopqrstuv', rand(0,31), 1);
			return $id;
	}
?>
