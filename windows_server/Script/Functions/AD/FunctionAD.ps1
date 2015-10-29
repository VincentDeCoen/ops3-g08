#Active Directory installeren

function ADInstallation
{
    param( 
        [Parameter(Mandatory=$true)][string]$domein
    )

    Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
    Import-Module ADDSDeployment
 
    Install-addsforest -creatednsdelegation:$false -domainMode "g08Server" -DomainName $domein -forestmode "g08Server" `
    -NorebootOnCompletion:$false -InstallDns:$true
}