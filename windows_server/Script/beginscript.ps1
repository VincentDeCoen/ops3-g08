#BeginScriptWindowsServer
#static ip
    Add-windowsfeature RSAT-AD-Tools
    new-NetIPAddress -IPAddress "192.168.210.10" "Ethernet" -AddressFamily IPv4
    #interfaceNaam
    if(Get-NetAdapter -name like Ethernet) {
    get-netadapter -Name Ethernet|Rename-NetAdapter -NewName ConnectieAssengraaf
    }

#AD
    Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
    Import-Module ADDSDeployment
    Install-addsforest -creatednsdelegation:$false -domainMode "win2012" -DomainName $domein -forestmode "win2012" `
    -NorebootOnCompletion:$false -InstallDns:$true

#DHCP
    Install-WindowsFeature –Name DHCP
    Install-WindowsFeature –Name RSAT-DHCP
    Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias ConnectieAssengraaf
    Add-DhcpServerInDC -DnsName AsSv1.Assengraaf.nl
    Add-DhcpServerv4Scope -Name "Assengraafscope" -StartRange 192.168.210.30 -EndRange 192.168.210.130 -SubnetMask 255.255.255.0

#Update
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\AUoptions" 

