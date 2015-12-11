
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
