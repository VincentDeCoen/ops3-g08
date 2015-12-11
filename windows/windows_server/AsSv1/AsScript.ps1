#Windows Server 2012 Core Install Script (AD, DNS, DHCP,...)

#Rename the machine
$newname = "AsSv1"
	Rename-Computer -NewName $newname -force

#restart the computer
	Restart-Computer

#Set a static ip
function SetIP{
    Add-windowsfeature RSAT-AD-Tools
    $ipaddress = "192.168.210.11"
	$ipprefix = "24"
	$ipgw = "192.168.210.1"
	$ipdns = "192.168.210.11"
    $IntAlias = "Ethernet"
	New-NetIPAddress -IPAddress $ipaddress -Interfacealias $IntAlias -PrefixLength $ipprefix -DefaultGateway $ipgw
}

#AD
function InstallAD{
    Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
    Import-Module ADDSDeployment
    Install-addsforest -creatednsdelegation:$false -domainMode "win2012" -DomainName "Assengraaf.nl" -SafeModeAdministratorPassword (ConvertTo-SecureString  Admin123 -AsPlainText -Force ) -forestmode "win2012" `
    -NorebootOnCompletion:$false -InstallDns:$true
}

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


#OU
function CreateOU{
    New-ADOrganizationalUnit -Name AsAfdelingen -Path 'DC=Assengraaf,DC=NL' -Description "Overkoepeldende OU voor het domein Assengraaf.nl" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Beheer -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -Description "Groep voor de Beheerders" -ProtectedFromAccidentalDeletion $False
		Set-GPInheritance -Target 'OU=Beheer,OU=AsAfdelingen,DC=Assengraaf,DC=nl' -IsBlocked Yes
    New-ADOrganizationalUnit -Name Directie -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -Description "Groep voor de Directie" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Verzekeringen -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -Description "Groep voor de verzekeringen" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Financieringen -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -Description "Groep voor de Financieringen" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Staf -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -Description "Groep voor de Stafmedewerkers" -ProtectedFromAccidentalDeletion $False
}

#CSV Import
function Add-Users {
    $Users = Import-CSV -Delimiter "," -Path "AsCSV.csv"
	ForEach($User in $Users) {
	    $DisplayName = $User.GivenName + " " + $User.Surname
	    $UserFirstname = $User.GivenName
	    $FirstLetterFirstname = $UserFirstname.substring(0,1)
	    $UserSurname = if($User.Surname.contains(" ")){$User.Surname -replace ' ', '_'} else {$User.Surname}
	    $SurName = $User.Surname
	    $GivenName = $User.GivenName
	    $SAM = $FirstLetterFirstname + $UserSurname
	    $Password = ConvertTo-SecureString -AsPlainText $Pass -force
	    $Department = $User.Department
        $OuPath = 'OU=' + $User.Department + ',DC=Assengraaf,DC=NL'

    switch ($Department)
    {
      "Directie" {$U = "OU = Directie, OU=AsAfdelingen, DC=Assengraaf, DC=nl"} 
      "Staf" {$U = "OU = Staf, OU=AsAfdelingen, DC=Assengraaf, DC=nl"} 
      "Verzekeringen" {$U = "OU = Verzekeringen, OU=AsAfdelingen, DC=Assengraaf, DC=nl"} 
      "Financieringen" {$U = "OU = Financieringen, OU=AsAfdelingen, DC=Assengraaf, DC=nl"} 
    }	
    
        New-ADUser -Name $DisplayName -SamAccountName $SAM -UserPrincipalName $SAM -DisplayName $DisplayName
        -GivenName $GivenName -SurName $SurName -Path $OuPath -AccountPassword $Password -ChangePasswordAtLogon $true -enable $true -HomeDirectory "\\users\$FullName\HomeDir" -Path $U
    

	}
}

function Add-FolderPerUser{

}

function Add-Printers {
    Add-WindowsFeature Print-Server -IncludeManagementTools
    Add-PrinterPort -Name AsPr1Port -PrinterHostAddress "192.168.210.131"
    Add-PrinterDriver -Name "HP LaserJet 5200 PS Class Driver"
    Add-Printer -Name AsPr1 -DriverName "HP LaserJet 5200 PS Class Driver" -PortName AsPr1Port
    Set-Printer -Name AsPr1 -Shared $true -Published $true
    Add-PrinterPort -Name AsPr2Port -PrinterHostAddress "192.168.210.132"
    Add-PrinterDriver -Name "HP LaserJet 5200 PS Class Driver"
    Add-Printer -Name AsPr2 -DriverName "HP LaserJet 5200 PS Class Driver" -PortName AsPr2Port
    Set-Printer -Name AsPr2 -Shared $true -Published $true
    New-ADGroup -Name "T_AsPr1" -SamAccountName T_AsPr1 -GroupCategory Security -GroupScope DomainLocal `
    -Path "OU=AsAfdelingen,DC=Assengraaf,DC=nl" -Description "Toegangsgroep voor AsPr1"
    New-ADGroup -Name "T_AsPr2" -SamAccountName T_AsPr2 -GroupCategory Security -GroupScope DomainLocal `
    -Path "OU=AsAfdelingen,DC=Assengraaf,DC=nl" -Description "Toegangsgroep voor AsPr2"
}
