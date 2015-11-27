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

This can be done conveniently when the print server holds the printer driver. This means we don't need to install the driver on all the client machines.

```
##Install the print driver
Add-PrinterDriver -name "HP LaserJet 9000 PS Class Driver"

##List the installed printers to determine the name needed
Get-Printer

##Change the driver
Get-Printer -Name "Accounting HP" | Set-Printer -DriverName "HP LaserJet 9000 PS Class Driver"

##Confirm the printer is using the new driver
Get-Printer | Format-Table –AutoSize
```

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

In this example, we will be using the printer set up in [Setting up and sharing printers](#setting-up-and-sharing-printers).

```
##Retrieve the SID for the user/group being granted permissions
$User = "CORP\Accounting Users"
$UserSID = (new-object security.principal.ntaccount $User).Translate([security.principal.securityidentifier]).Value

##Construct the Security Descriptor Definition Language (SDDL)
$SDDL = "O:BAG:DUD:PAI(A;OICI;FA;;;DA)(A;OICI;0x3D8F8;;;$UserSID)"

##Retrieve the printer object
$myPrinter = Get-Printer -Name "Accounting HP"

##Set the permissions
$myPrinter | Set-Printer -PermissionSDDL $SDDL

```

1. Retrieve the SID (Security ID) for the user/group being granted permissions  
  - We first create a `Security.Principal.NtAccount` object for our target user.
  - We then translate this account object into a `Security.Principal.SecurityIdentifier` object.
  - We return the SID value and store it in a variable.
2. Construct the Security Descriptor Definition Language (SDDL)  
  - An SDDL is a Security Descriptor Definition Language that allows us to describe our security settings in a string form. More information in [this technet article](http://blogs.technet.com/b/askds/archive/2008/05/07/the-security-descriptor-definition-language-of-love-part-2.aspx).
  - The permissions are stored inside the braces "(",")": the first set of permissions provides full control to Domain Administrators, the second provides Print and Read permissions to the group CORP\Accounting Users.
3. Retrieve the printer object
4. Set the permissions  
  !! This method replaces all existing permissions on the printer! Use caution when using this in production environments!
5. Use the script in [Reporting on printer security](#reporting-on-printer-security) to confirm the new printer permissions.

### Mapping clients to printers

With Server 2012, there are two automated methods of mapping clients to printers: logon scripts and Group Policy. Logon scripts are the traditional deployment method for printers. Group Policies are a newer method of configuring printers and utilize the existing OU infrastructure in your organization. However, much of the deployment process when using this method is still manual.

#### Using logon script

This example shows 3 methods to map printers, set default printers, and delete printers:

- using PrintUI.dll
- using WMI
- using WScript

Executing these steps on a client system will map to a shared printer on our print server.

```
##Map a printer by using Printui.dll
$PrinterPath = "\\PrntSrv\Accounting HP"
rundll32.exe printui.dll,PrintUIEntry /q /in /n$PrinterPath

##Set the default printer by using Printui.dll
$PrinterPath = "\\PrntSrv\Accounting HP"
rundll32 printui.dll,PrintUIEntry /y /n$PrinterPath

##Delete a printer by using Printui.dll
$PrinterPath = "\\PrntSrv\Accounting HP"
rundll32.exe printui.dll,PrintUIEntry /q /dn /n$PrinterPath

##Map a printer by using WMI
$PrinterPath = "\\PrntSrv\Accounting HP"
([wmiclass]"Win32_Printer").AddPrinterConnection($PrinterPath)

##Set the default printer by using WMI
$PrinterPath = "\\PrntSrv\Accounting HP"
$filter = "DeviceID='$($PrinterPath.Replace('\','\\'))'"
(Get-WmiObject -Class Win32_Printer -Filter $filter).
SetDefaultPrinter()

##Remove a printer by using WMI
$PrinterPath = "\\PrntSrv\Accounting HP"
$filter = "DeviceID='$($PrinterPath.Replace('\','\\'))'"
(Get-WmiObject -Class Win32_Printer -Filter $filter).Delete()

##Map a printer by using WScript
$PrinterPath = "\\PrntSrv\Accounting HP"
(New-Object -ComObject WScript.Network).AddWindowsPrinterConnectio
n($PrinterPath)

##Set the default printer by using WScript
$PrinterPath = "\\PrntSrv\Accounting HP"
(New-Object -ComObject WScript.Network).
SetDefaultPrinter($PrinterPath)

##Remove a printer by using WScript
$PrinterPath = "\\PrntSrv\Accounting HP"
(New-Object -ComObject WScript.Network).RemovePrinterConnection($P
rinterPath)
```

1. Map a printer by using Printui.dll  
  - We assign the UNC path to the printer to a variable.
  - `Printui.dll` is the library used by Windows to manage printers and view print server properties.
  - We access the dll functions by using `rundll32.exe`.
  - `/q`: quiet (no interface shown)
  - `/in`: add a network printer
  - `/n`: identify UNC path
2. Set the default printer by using Printui.dll  
  - `/y`: define a printer as default
3. Delete a printer by using Printui.dll  
  - `/dn`: delete a network printer
4. Map a printer by using WMI  
  - This is the same action as in step 1, but this time using WMI.
  - We create a wmiclass reference to the `Win32_Printer` class. With the WMI reference, we can execute the `AddPrinterConnection` method and pass the printer UNC path as a parameter.
5. Set the default printer by using WMI  
  - Here, we create a WMI filter based on the DeviceID of the WMI object. The DeviceID is essentially the same as the UNC path. However, because WMI uses the backslash character as an escape character, we have to replace every backslash with two backslashes.
  - We then call `Get-WmiObject` to query the `Win32_Printer` class using our filter to return the printer object.
  - We call `SetDefaultPrinter` to set our printer as the default.
6. Remove a printer by using WMI  
  - See step 5 for the initial steps.
  - The last step is calling the `Delete` method to delete the printer.
7. Map a printer by using WScript  
  - We create a `WScript.Network` ComObject.
  - Using this object, we execute the `AddWindowsPrinterConnection` method and pass the printer UNC path as an attribute.
8. Set the default printer by using WScript  
  - Same as step 7, except for the last step: use method `SetDefaultPrinter`.
9. Remove a printer by using WScript  
  - Same as step 7, except for the last step: use method `RemovePrinterConnection`.

More information on the many options for `PrintUI.dll`: execute `rundll32.exe printui.dll,PrintUIEntry` in command prompt.

#### Using Group Policy

1. Create a new group policy and link it to the domain, site, or appropriate OU:

        New-GPO -Name "Accounting Print"
        New-GPLink -Name "Accounting Print" -Target corp

2.	 Open the Print Management console.
3.	 Right-click on the printer and select Deploy with Group Policy...
4.	 Click Browse and select the target GPO.
5.	 Select per User and/or per Machine as appropriate for the environment, and then click on Add.

The group policy will take effect once it is refreshed for the user or target computer.

### Enabling Branch Office Direct Printing

### Reporting on printer usage

Information about printer usage can be very useful in guiding the decisions on which locations need printer upgrades, and locations that can be downsized.

This example assumes the existence of a print server with one or more shared printers attached to it. Additionally, we need one or more clients to print to the print server.

```
##Enable logging on the print server by using the wevutil.exe utility
wevtutil.exe sl "Microsoft-Windows-PrintService/Operational" /enabled:true

##Query the event log for successful print jobs
Get-WinEvent -LogName Microsoft-Windows-PrintService/Operational | `
Where-Object ID -eq 307
```

1. Enable logging on the print server by using the `wevutil.exe` utility.  
  - wevutil.exe is a command-line utility that allows us to view and change the configuration of the event logs on a server.
  - we use the utility to enable the `Microsoft-Windows-PrintService/Operational` log. This log exists by default, but doesn't track any printing events until it is enabled.
  - The log can be viewed in the Event Viewer > Application and Services Log > Microsoft > Windows > PrintService > Operational
2. Query the event log for successful print jobs.  
  - We use Get-WinEvent to query our event log for successful print jobs. Successfully-printed jobs are recorded as event ID 307.

Each event log entry contains a Properties object, which contains many of the event details. We can use this object to retrieve more detailed information about the print jobs.

For example, the following script will return a concise report about who created a successful print job when, where from, and how large the print jobs were.

```
Get-WinEvent -LogName Microsoft-Windows-PrintService/Operational | `
Where-Object ID -eq 307 | `
Select-Object TimeCreated, `
@{Name="User";Expression={$_.Properties[2].Value}}, `
@{Name="Source";Expression={$_.Properties[3].Value}}, `
@{Name="Printer";Expression={$_.Properties[4].Value}}, `
@{Name="Pages";Expression={$_.Properties[7].Value}}
```
