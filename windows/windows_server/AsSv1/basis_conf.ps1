<#Windows Server 2012: Basis Configuratie
 Basic configuration of the Server
 - Rename
 - IP settings
 - Activate
 - Firewall
 - Restart
#>

function basiscommandos
{
    Write-Host "Execute Server Rename function, SetIP function, SetFirewall function and Restart function"
    Start-Sleep -s 2
    
    Rename
    SetIP
    setFirewall
    Restart
}

#Rename The Machine
function Rename{
Write-Host "Server is getting a new name AsSv1"
    Start-Sleep -s 2
$newname = "AsSv1"
	Rename-Computer -NewName $newname -force

}
#IP Settings: Static IP
function SetIP{
    Write-Host "Server is getting IP Settings"
    Start-Sleep -s 2
    Add-windowsfeature RSAT-AD-Tools
    $ipaddress = "192.168.210.10"
    $ipgw = "192.168.0.1"
    $ipdns = "192.168.210.11"
    $ippref = "16"
 
    
    New-NetIPAddress -InterfaceIndex 12  -IPAddress $ipaddress -PrefixLength $ippref -DefaultGateway $ipgw -AddressFamily IPv4


}

<#
Activate the server
 function{
	slmgr.vbs -ipk<productkey>
	slmgr.vbs -ato
 }
#>


#Firewall
function setFirewall{
    Write-Host "Server is getting Firewall Settings"
    Start-Sleep -s 2

Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow –NotifyOnListen True -AllowUnicastResponseToMulticast True –LogFileName %SystemRoot%\System32\LogFiles\Firewall\pfirewall.log


}

#Restart The Server (To complete the rename)
function Restart{
Write-Host "Server is getting a Reboot"
    Start-Sleep -s 2
	Restart-Computer
}
