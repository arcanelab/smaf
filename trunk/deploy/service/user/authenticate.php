<? 
	require("../mysql/connect_to_mysql.inc");
	require("authenticate.inc");
		
	echo('<response><success>'.$success.'</success><p><![CDATA['.$_POST['pass'].']]></p><id><![CDATA['.$user_id.']]></id><username><![CDATA['.$username.']]></username><level><![CDATA['.$level.']]></level></response>');
?>
