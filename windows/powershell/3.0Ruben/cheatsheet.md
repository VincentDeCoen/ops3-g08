# Cheatsheet Powershell 3.0 First Steps
###### Author: Ruben
=======================================

## Chapter 1: Overview of Powershell 3.0
----------------------

|Cmdlet|Description|
|------|-----------|
|Get-Process|Shows a list of all running processes on the system|
|Get-Hotfix -description update |Shows all the installed hotfixes with the description 'update'|
|Get-NetAdapter|Shows a list of all network adapters, only on windows 8 and windows server 2012|
|Get-Culture|Shows the language settings of the system|
|Get-UICulture|Shows the language settings of the User Interface|
|Get-Date|Returns the current date/time|
|Get-Random|Shows a random number|
|Get-Random 21|Shows a random number(max 21)|
|Update-Help -Force|Force an update of the help system|

## Chapter 2: Using Windows Powershell cmdlets
----------------------------------------------

|Cmdlet|Description|
|------|-----------|
|Get-Help|Displays help about Windows Powershell cmdlets and concepts|
|Get-Command|Gets all the commands, installed on the current system|
|Get-Member|Command that gets the properties and methods of objects|
|Show-Command|Shows a graphical input control|
|Stop-Process|Stops a specific process|
|Start-Transcript|Starts a transcript, a special outputfile (transcript) has been created|
|Stop-Transcript| Stops a transcript|


## Chapter 3: Filtering, grouping and sorting
----------------------------------------------

|Cmdlet|Description|
|------|-----------|
|Get-Process \| Sort-Object -Property VM | Sorts the output of the Get-Process command, on virtual memory|
|Get-Service \| Sort-Object status \| Group-Object -Property status| Groups objects, after sorting|
|Get-HotFix \| Where installedon -gt 12/1/12 \| sort installedon| Shows the installed hotfixes afther December 1 2012|

## Chapter 4: Formatting output
----------------------------------------------
|Get-Process \| Format-List -Property VM| Creates a list|
