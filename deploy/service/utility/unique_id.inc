<? 
	function generateUniqueID() {
		for ($i = 0; $i < 8; $i++)
	       $id .= substr('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', rand(0,62), 1);
			return $id;
	}
?>
