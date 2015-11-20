## Managing printers with PowerShell

From: Windows Server 2012 Automation with PowerShell Cookbook (Ed Goad, Packt Publishing 2013) - Chapter 8

In Windows Server 2012, there are two types
of printer drivers available: printer class and model-specific. Printer class drivers support a
wide range of devices with a single driver. Model-specific drivers are often distributed by the
printer manufacturer and support features specific to the printer. Custom drivers may provide more functionality, but they can cause conflicts in environments with many different types of printers. **It is best practice to only use the print drivers built-in to Windows or
provided via Windows Update.**

Additionally, the print server is no longer used to distribute print drivers to clients. Instead, clients use a point and print feature to send print jobs to the server.

### Setting up and sharing printers

The print server allows for a centralized location to configure and manage printers and change
configurations. Additionally, a print server provides end users
with a single location in which to look for available printers.

In this example, we configure a Windows Server 2012 machine to function as a print server. The printer is an HP LaserJet 9000 printer, which has already been assigned the IP of 10.0.0.200.

```
Add-WindowsFeature Print-Server –IncludeManagementTools
Add-PrinterPort -Name Accounting_HP -PrinterHostAddress
"10.0.0.200"
Add-PrinterDriver -Name "HP LaserJet 9000 PCL6 Class Driver"
Add-Printer -Name "Accounting HP" -DriverName "HP LaserJet 9000 PCL6 Class Driver" -PortName Accounting_HP
Set-Printer -Name "Accounting HP" -Shared $true -Published $true
```

1. Add-WindowsFeature: Install the print server  
  We include the Print Management tool and PS cmdlets in the install.
2. Add-PrinterPort: Create the printer port  
  Choose a port name that is easily recognizable to you, so you can find it later.
3. Add-PrinterDriver: Add the print driver  
  This installs the driver onto the server, but it isn't used until it is configured for a printer.
4. Add-Printer: Add the printer  
  This pairs the printer port (PortName) with the print driver (DriverName) and defines the printer name.  
  The printer is now functional, but since it isn't shared yet, it is only accessible from the print server.
5. Set-Printer: Share the printer  
  The -Shared switch is set to $true, which means other users on the network will now be able to send jobs to the printer.  
  The -Published switch set to $true means the printer is now published in AD.


### Changing printer drivers

### Reporting on printer security

We iterate through each printer en list the security attributes assigned to each printer user.

```
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
```

1. Create a hash table containing printer permissions  
  This table allows us to perform lookups between the decimal permissions used by the server and the
human-readable text.
2.  Create an array of available permissions  
  The $flags array provides a lookup method to compare permissions.
3. Return a list of all printers  
  We query WMI and return a list of all printers on the local system. We write each printer name to the console.
4. Get the Security Descriptor and Discretionary Access  
  First, we get the security descriptor from each printer (GetSecurityDescriptor() called on the printer object). Then, we extract the DACLs from the descriptor.
5. Iterate through each DACL  
  We display the user domain and name for each printer and we use our hash table ($pace) and our array ($flags) to translate the AccessMask in each successive DACL to a human-readable form.

### Adding and removing printer security

When sharing printers, the default configuration is to allow all domain users to print to all
printers. Occasionally this is not a desired configuration as there may be special-purpose
printers or printers in restricted areas.
To manage this need, we can apply security on the printers themselves to limit which users
can perform various functions. We can use permissions to restrict who can print to specific
printers, or delegate administrative permissions to certain users.

### Mapping clients to printers

### Enabling Branch Office Direct Printing

### Reporting on printer usage
