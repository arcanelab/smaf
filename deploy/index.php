<? require("service/configuration/configuration.inc"); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<title><? =$browserTitle ?></title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" type="text/css" media="screen" href="css/global.css"/>
		<script type="text/javascript" src="js/swfobject.js"></script>
		<script type="text/javascript" src="js/swfaddress.js"></script>
		<script type="text/javascript">

		var flashvars = {
		  country: "us",
		  debug: "<? echo($_GET['d']); ?>",
		  lang_locale: "en_US",
		  preloadercolor: "<? =$preloaderColor ?>",
		  // siteConfigurationPath: "<? echo($cfg_configuration_path); ?>"
		  siteConfigurationPath: "<? =$siteConfigurationPath ?>"
		};

		var params = {
		  bgcolor: "#ffffff",
		  menu: "false",
		  scale: "noscale",
		  salign: "TL",
		  quality: "best",
		  allowscriptaccess: "always",
		  allowfullscreen: "true"
		};
		var attributes = {
		  id: "flash",
		  name: "flash"
		};
		swfobject.embedSWF("bin/shell.swf", "flash", "100%", "100%", "10.1.0", "bin/expressInstall.swf", flashvars, params, attributes);
		</script>
	</head>
	<body>
		<div id="flash">
		   Please download the latest Flash Player to view this page by <a href="http://www.adobe.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" target="_top">clicking here</a>. 
		</div>
	</body>
</html>