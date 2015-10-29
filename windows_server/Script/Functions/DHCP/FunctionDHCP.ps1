#DHCP installeren

function DHCPInstallation 
{
    Add-windowsfeature RSAT-AD-Tools
    Install-WindowsFeature –Name DHCP
    Install-WindowsFeature –Name RSAT-DHCP
    Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias ConnectieAssengraaf
    Add-DhcpServerInDC -DnsName AsSv1.Assengraaf.nl
    Add-DhcpServerv4Scope -Name "Assengraafscope" -StartRange 192.168.210.30 -EndRange 192.168.210.130 -SubnetMask 255.255.255.0
}