#Windows Server 2012 Core Install Script (AD, DNS, DHCP,...)

#Rename the machine
$newname = "AsSv1"
	Rename-Computer -NewName $newname -force

#restart the computer
	Restart-Computer
	
#Set a static ip
function SetIP{
    Add-windowsfeature RSAT-AD-Tools
    $ipaddress = "192.168.0.10"
	$ipprefix = "24"
	$ipgw = "192.168.0.1"
	$ipdns = "192.168.0.10"
	$ipif = (Get-NetAdapter).ifIndex
	New-NetIPAddress -IPAddress $ipaddress -InterfaceAlias "AssengraafConnectie" -PrefixLength $ipprefix 
	-InterfaceIndex $ipif -DefaultGateway $ipgw
}

#AD
function InstallAD{
    Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
    Import-Module ADDSDeployment
    Install-addsforest -creatednsdelegation:$false -domainMode "Assengraaf.nl" -DomainName $domein -forestmode "Assengraaf.nl" `
    -NorebootOnCompletion:$false -InstallDns:$true
}

#DHCP
function InstallDHCP{
    Install-WindowsFeature –Name DHCP
    Install-WindowsFeature –Name RSAT-DHCP
    Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias "AssengraafConnectie"
    Add-DhcpServerInDC -DnsName AsSv1.Assengraaf.nl
    Add-DhcpServerv4Scope -Name "Assengraafscope" -StartRange 192.168.0.30 -EndRange 192.168.0.130 -SubnetMask 255.255.255.0
}

#Update
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\AUoptions" 
    
#OU
function CreateOU{
    New-ADOrganizationalUnit -Name AsAfdelingen -Path 'DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Beheer -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $False #nog block inheritance
    New-ADOrganizationalUnit -Name Directie -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Verzekeringen -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Financieringen -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Staf -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $False
}

#CSV Import
function Add-Users {
    $Users = Import-CSV -Delimiter "," -Path ".\AsCSV.csv" 
	ForEach($User in $Users) {
        $i++
	    $DisplayName = $User.GivenName + " " + $User.Surname
	    $UserFirstname = $User.GivenName
	    $FirstLetterFirstname = $UserFirstname.substring(0,1)
	    $UserSurname = if($User.Surname.contains(" ")){$User.Surname -replace ' ', '_'} else {$User.Surname}
	    $SurName = $User.Surname
	    $GivenName = $User.GivenName
	    $SAM = $FirstLetterFirstname + $UserSurname
	    $City = $User.City
	    $Password = ConvertTo-SecureString -AsPlainText $Pass -force
        $OuPath = 'OU=' + $User.Afdeling + ',DC=Assengraaf,DC=NL'
    
        New-ADUser -Name $DisplayName -SamAccountName $SAM -UserPrincipalName $SAM -DisplayName $DisplayName 
        -GivenName $GivenName -SurName $SurName -AccountPassword $Password -ChangePasswordAtLogon $true -enable $true
    }
}

