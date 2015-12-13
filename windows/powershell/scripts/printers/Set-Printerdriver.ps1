##Install the print driver
Add-PrinterDriver -name "HP LaserJet 9000 PS Class Driver"

##List the installed printers to determine the name needed
Get-Printer

##Change the driver
Get-Printer -Name "Accounting HP" | Set-Printer -DriverName "HP LaserJet 9000 PS Class Driver"

##Confirm the printer is using the new driver
Get-Printer | Format-Table –AutoSize
