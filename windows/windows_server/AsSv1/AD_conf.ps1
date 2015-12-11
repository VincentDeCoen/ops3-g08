#AD
function InstallAD{
    Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
    Import-Module ADDSDeployment
    Install-addsforest -creatednsdelegation:$false -domainMode "win2012" -DomainName "Assengraaf.nl" -SafeModeAdministratorPassword (ConvertTo-SecureString  Admin123 -AsPlainText -Force ) -forestmode "win2012" `
    -NorebootOnCompletion:$false -InstallDns:$true
}
