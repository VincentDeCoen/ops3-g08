#DHCP
function InstallDHCP{
    Install-WindowsFeature -Name DHCP
    Install-WindowsFeature -Name RSAT-DHCP
    Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias "Ethernet"
    Add-DhcpServerInDC -DnsName "AsSv1.Assengraaf.nl"
		Add-DhcpServerv4Scope -Name "Assengraafscope" -StartRange 192.168.210.31 -EndRange 192.168.210.130 -SubnetMask 255.255.255.0
    Set-DhcpServerv4DnsSetting -ScopeId 192.168.210.0 -DynamicUpdates OnClientRequest -DeleteDnsRROnLeaseExpiry $true
    Set-DhcpServerv4OptionValue -ScopeId 192.168.210.0 -DnsServer 192.168.210.11 -DnsDomain Assengraaf.nl -Router 192.168.210.11
}