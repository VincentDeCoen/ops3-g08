##############################################################################
##
## Get-PrinterSecurity
##
## From Packt Publishing Windows Server 2012 Automation Cookbook
##
##############################################################################

<#

.SYNOPSIS

This script reports on the printer security on the print server. It will iterate
through each printer on the server and return the security attributes assigned to each user.

#>

##Create a hash table containing printer permissions
$pace = DATA {
ConvertFrom-StringData -StringData @'
131072 = ReadPermissions
131080 = Print
262144 = ChangePermissions
524288 = TakeOwnership
983052 = ManagePrinters
983088 = ManageDocuments
'@
}

##Create an array of available permissions
$flags = @(131072,131080,262144,524288,983052,983088)

##Return a list of all printers
$myPrinters = Get-WmiObject -Class Win32_Printer
ForEach ($printer in $myPrinters){
Write-Host "`nPrinter: $($printer.DeviceId)"

##Get the Security Descriptor and Discretionary Access Control Lists (DACL) for each printer
$sd = $printer.GetSecurityDescriptor()
$myDACLs = $sd.Descriptor.DACL
ForEach ($dacl in $myDACLs) {

##Iterate through each DACL and return
Write-Host "`n$($dacl.Trustee.Domain)\$($dacl.Trustee.Name)"
ForEach ($flag in $flags){
If ($dacl.AccessMask -cge $flag){
Write-Host $pace["$($flag)"]
}
}
}
}
