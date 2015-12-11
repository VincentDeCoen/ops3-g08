#Windows Server 2012: Basis Configuratie

#Rename The Machine
$newname = "AsSv1"
	Rename-Computer -NewName $newname -force

#IP Settings: Static IP
function SetIP{
    Add-windowsfeature RSAT-AD-Tools
    $ipaddress = "192.168.210.11"
	$ipprefix = "24"
	$ipgw = "192.168.210.1"
	$ipdns = "192.168.210.11"
    $IntAlias = "Ethernet"
	New-NetIPAddress -IPAddress $ipaddress -Interfacealias $IntAlias -PrefixLength $ipprefix -DefaultGateway $ipgw
}

#Restart The Server (To complete the rename)
	Restart-Computer
