#DHCP
function DHCP{
    Install-WindowsFeature -Name DHCP
    Install-WindowsFeature -Name RSAT-DHCP
    
    Set-DhcpServerv4Binding -BindingState $true `
    -InterfaceAlias "Ethernet"
    
    Add-DhcpServerInDC -DnsName "AsSv1.Assengraaf.nl" `
	
    Add-DhcpServerv4Scope -Name "Assengraafscope" `
    -StartRange 192.168.210.81 `
    -EndRange 192.168.210.130 `
    -SubnetMask 255.255.255.0
    
    Set-DhcpServerv4DnsSetting -ScopeId 192.168.210.0 `
    -DynamicUpdates OnClientRequest `
    -DeleteDnsRROnLeaseExpiry $true
    
    Set-DhcpServerv4OptionValue -ScopeId 192.168.210.0 `
    -DnsServer 192.168.210.10 `
    -DnsDomain Assengraaf.nl `
    -Router 192.168.210.10

  }
