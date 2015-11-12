# Cheatsheet Windows PowerShell 3.0 Step by step
###### Author: Vincent
======================

## WMI
------

|Cmdlet|Description|
|------|-----------|
|Get-WmiObject|Returns a collection of management objects|
|gwmi win32_bios|Returns BIOS information from the local computer|
|gwmi -List "*bios*"|Returns all WMI Objects with bios in it|
|gwmi win32_bios|Returns BIOS information from the host system|
|gwmi win32_desktop ```|``` select name|Returns the names of the users on the host system|
|gwmi win32_desktop ```|``` select name, ScreenSaverExecutable|Returns the name of the screensaver|
|Get-Service ```|``` Where-Object {$_.status -eq "running"}|Returns all the services that are running|
|Get-Alias ```|``` where definition -eq 'Get-WmiObject'|Returns the alias for the 'Get-WmiObject' command|
|Get-WmiObject WIN32_ComputerSystem ```|``` Format-List *|Returns all the properties from the hostsystem|
|gwmi win32_environment```|```Returns the common properties of the WIN32_Environment WMI class|
|gwmi win32_environment ```|``` Format-List *|Returns all the properties of the WIN32_Environment class|
|gwmi win32_environment ```|``` Format-Table name, variableValue, userName| Creates a table view with columns name, variableValue and userName|


By using aliases we can make commands shorter.

For example:

```Get-WmiObject -List "*bios*" | Where-Object { $_.name -match '^win32'} |
ForEach-Object { Get-WmiObject -Class $_.name }``` 

After using aliases:

```gwmi -list "*bios*" | ? name -match '^win32' | % {gwmi $_.name}``` 


