#Installation of AD and OU's and Users with CSV-file
function InstallAD{
	
    Write-Host "Server is getting AD"
    Start-Sleep -s 2
	
    Import-Module ADDSDeployment
    Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
    
    Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "Win2012R2" `
    -DomainName "Assengraaf.nl" `
    -DomainNetbiosName "ASSENGRAAF" `
    -ForestMode "Win2012R2" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath: "C:\Windows\SYSVOL" `
    -Force:$true `
    -SafeModeAdministratorPassword (ConvertTo-SecureString  Admin123 -AsPlainText -Force ) -forestmode "win2012" `
    -NorebootOnCompletion:$false -InstallDns:$true
}

#OU
function CreateOU{
	
	Write-Host "Server is getting the ASSENGRAAF OU's "
    Start-Sleep -s 2
	
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
	
	Write-Host "Server is importing the CSV file"
   Start-Sleep -s 1
	
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
     

    switch ($Department)
    {
      "Directie" {$U = "OU = Directie, OU=AsAfdelingen, DC=Assengraaf, DC=nl"} 
      "Staf" {$U = "OU = Staf, OU=AsAfdelingen, DC=Assengraaf, DC=nl"} 
      "Verzekeringen" {$U = "OU = Verzekeringen, OU=AsAfdelingen, DC=Assengraaf, DC=nl"} 
      "Financieringen" {$U = "OU = Financieringen, OU=AsAfdelingen, DC=Assengraaf, DC=nl"} 
    }	
    
        New-ADUser -Name $DisplayName -SamAccountName $SAM -UserPrincipalName $SAM -DisplayName $DisplayName
        -GivenName $GivenName -SurName $SurName -Path $U -AccountPassword $Password -ChangePasswordAtLogon $true -enable $true -HomeDirectory "\\users\$FullName\HomeDir"

	Write-Host "User $DisplayName is created"
    Start-Sleep -s 1
	
	}
}
