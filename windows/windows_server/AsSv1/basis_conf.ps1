#Windows Server 2012: Basis Configuratie

#Rename The Machine
$newname = "AsSv1"
	Rename-Computer -NewName $newname -force

#IP Settings: Static IP
function SetIP{
    Add-windowsfeature RSAT-AD-Tools
    $ipaddress = "192.168.210.11"
    $ipgw = "192.168.0.1"
    $ipdns = "192.168.210.11"
    $ippref = "24"
    $IntAlias = "Ethernet"
    
    New-NetIPAddress -InterfaceIndex 12  -IPAddress $ipaddress -Interfacealias $IntAlias -PrefixLength $ippref -DefaultGateway $ipgw
}

#Activate the server
#function{
#	slmgr.vbs -ipk<productkey>
#	slmgr.vbs -ato
#}

#Restart The Server (To complete the rename)
function rename{
	Restart-Computer
}

#Firewall
function setFirewall{

Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow –NotifyOnListen True -AllowUnicastResponseToMulticast True –LogFileName %SystemRoot%\System32\LogFiles\Firewall\pfirewall.log

}

