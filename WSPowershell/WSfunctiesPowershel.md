Handleiding Windows Server installatie met Powershell

#Active Directory installeren
function Install-AD {
    param( 
        [Parameter(Mandatory=$true)][string]$domein
    )

    Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
    Import-Module ADDSDeployment
 
    Install-addsforest -creatednsdelegation:$false -domainMode "win2012" -DomainName $domein -forestmode "win2012" `
    -NorebootOnCompletion:$false -InstallDns:$true


}


Met deze functie wordt een AD geïnstalleerd op de Windows Server 2012 Core installatie.
Hieronder verklaar ik even de gebruikte commando's.
    1)Install-windowsfeature -name AD-Domain-Services: Dient om de module AD te installeren.
    2)De optie -IncludeManagementTools: dient om de Server admin tools toe te voegen aan de local server.

Wanneer je een commando niet begrijpt, of voorbeelden/uitleg wil,
kan je gebruikmaken van Powershell Help System (zie les 2 uit de Microsoft Virtual Academy).
Het commando om de help aan te roepen is: Get-help <cmdlet name>.

Gebruikte bronnen:
https://technet.microsoft.com/en-us/library/hh472162.aspx