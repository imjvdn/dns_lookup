$domain = $args[0]
$mxrecords = nslookup -q=MX $domain | Select-String "MX"
$mxrecords
