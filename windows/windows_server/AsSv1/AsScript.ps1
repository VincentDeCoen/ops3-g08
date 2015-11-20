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
	$ipgw = "192.168.0.1"
	$ipdns = "192.168.210.11"
	$ipif = (Get-NetAdapter).ifIndex
	new-NetIPAddress -IPAddress $ipaddress -InterfaceAlias "AssengraafConnectie" -PrefixLength $ipprefix 
	-InterfaceIndex $ipif -DefaultGateway $ipgw
}

#AD
function InstallAD{
    param( 
        [Parameter(Mandatory=$true)][string]$domain
    )
    Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
    Import-Module ADDSDeployment
    Install-addsforest -creatednsdelegation:$false -domainMode "Assengraaf.nl" -DomainName $domain -forestmode "Assengraaf.nl" `
    -NorebootOnCompletion:$false -InstallDns:$true
}

#DHCP
function InstallDHCP{
    Install-WindowsFeature –Name DHCP
    Install-WindowsFeature –Name RSAT-DHCP
    Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias "AssengraafConnectie"
    Add-DhcpServerInDC -DnsName AsSv1.Assengraaf.nl
    Add-DhcpServerv4Scope -Name "Assengraafscope" -StartRange 192.168.210.30 -EndRange 192.168.210.230 -SubnetMask 255.255.255.0
}

#Update
function Update{
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\AUoptions" 
}

#OU
function CreateOU{
    New-ADOrganizationalUnit -Name AsAfdelingen -Path 'DC=Assengraaf,DC=NL' -Description"Overkoepeldende OU voor het domein Assengraaf.nl" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Beheer -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -Description"Groep voor de Beheerders" -ProtectedFromAccidentalDeletion $False #nog block inheritance
    New-ADOrganizationalUnit -Name Directie -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -Description"Groep voor de Directie" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Verzekeringen -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -Description"Groep voor de verzekeringen" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Financieringen -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -Description"Groep voor de Financieringen" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name Staf -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -Description"Groep voor de Stafmedewerkers" -ProtectedFromAccidentalDeletion $False
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
            $OuPath = 'OU=' + $User.Department + ',DC=Assengraaf,DC=NL'
    
        New-ADUser -Name $DisplayName -SamAccountName $SAM -UserPrincipalName $SAM -DisplayName $DisplayName 
        -GivenName $GivenName -SurName $SurName -Path $OuPath -AccountPassword $Password -ChangePasswordAtLogon $true -enable $true
    }
}

function Add-FolderPerUser{
	
}

