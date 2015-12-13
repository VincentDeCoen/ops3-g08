#Install Print Server feature
Add-WindowsFeature Print-Server –IncludeManagementTools

#Add TCP/IP printer port
Add-PrinterPort -Name Accounting_HP -PrinterHostAddress "10.0.0.200"

#Add printer driver
Add-PrinterDriver -Name "HP LaserJet 9000 PCL6 Class Driver"

#Add printer linked with driver and port
Add-Printer -Name "Accounting HP" -DriverName "HP LaserJet 9000 PCL6 Class Driver" -PortName Accounting_HP

#Publish printer
Set-Printer -Name "Accounting HP" -Shared $true -Published $true
