# Powershell 3.0 First Steps

------------------------------

###### Author: Ruben

###Table of Contents
####1 Setting The Script Execution Policy
#####1.1 A Policy
#####1.2 The Scope of a Policy
####2 Sorting, Grouping, Filtering
##### 2.1 Sorting output from a cmdlet
#####2.2 Grouping afther sorting
##### 2.3 Filtering output from one cmdlet
#### 3 Formatting Output
####4 Powershell Remoting
#####4.1 Configuring Remoting
####5 Functions
####5.1 Creating a function
####5.2 Using multiple input parameters


### 1 Setting the Script Execution Policy

---------------------------------------

#### 1.1 A Policy

If you have administrator rights on your system, you can set the script execution policy.
The command that is used to set the execution policy is ```Set-ExecutionPolicy```.
The Policies you can use, are shown below.

##### a. Restricted

Does not load configuration files or run scripts. Restricted is the default.

##### b. AllSigned

Requires that a trusted publisher sign all scripts and configuration files, including scripts that you write on the local computer.

##### c. RemoteSigned

Requires that a trusted publisher sign all scripts and configuration
files downloaded from the Internet.

##### d.Unrestricted

Loads all configuration files and runs all scripts.
If you run an unsigned script that was downloaded from the Internet, you are prompted for permission before
it runs.

##### e. Bypass

Nothing is blocked and there are no warnings or prompts.

##### f. Undefined

Removes the currently assigned execution policy from the current scope.
This parameter does not remove an execution policy that is set in a Group Policy
scope.

#### 1.2 The Scope Of A Policy

##### a. Process

The policy only affects the current process

##### b. CurrentUser

The policy only affects the current user

##### c. LocalMachine

The policy affects all the users of the machine

###### Example:

```SetExecutionPolicy -Scope CurrentUser -ExecutionPolicy remotesigned```

### 2 Sorting, Grouping, Filtering

---------------------------------------

#### 2.1 Sorting output from a cmdlet

---------------------------------------

To sort the output from a cmdlet, you have to use pipelines.
The ```Get-Process``` command shows a nice table view of process information.
The default view appears in ascending alphabetical process name order.
If you want to sort the process information on for example virtual memory,
then you can use the pipeline: ```Get-Process | Sort-Object -Property VM -Descending```.

A tip: the command `Sort` is an alias for `Sort-Object`.

![Afbeelding1](/windows/powershell/3.0Ruben/afb/afb1.PNG )

#### 2.2 Grouping after sorting

---------------------------------------

After you have sorted the objects through the pipeline, you can group them.
You can group objects with the ```Group-Object``` command, used in a pipeline with the Sort-Object from above.

Do the following command in the Windows Powershell console:
```Get-Service | Sort-Object status | Group-Object -Property status```

![Afbeelding2](/windows/powershell/3.0Ruben/afb/afb2.PNG )

#### 2.3 Filtering output from one cmdlet

------------------------------------------

Sorting and grouping is very useful to create an easy to read overview of the data,
but we still need something that dives in the data, to show the relevant data in very short time.
To achieve this, we need to use filters.

#### Example

```Get-HotFix | Where installedon -gt 12/1/12```
This command returns all hotfixes, installed after December 1, 2012.

![Afbeelding3](/powershell/3.0Ruben/afb/afb3.PNG )

### 3 Formatting Output

---------------------------------------

#### 3.1 Creating a list

```|Get-Process | Format-List -Property VM```

![Afbeelding4](/windows/powershell/3.0Ruben/afb/afb4.PNG )

### 4 Powershell Remoting

---------------------------------------

#### 4.1 Configuring Remoting

------------------------------------------

Windows Server 2012 installs with Windows Remote Management (WinRm) configured and
running to support remote Windows PowerShell commands. WinRm is the Microsoft implementation
of the industry standard WS-Management Protocol. As such, WinRM provides a
firewall-friendly method of accessing remote systems in an interoperable manner.
As soon as Windows Server 2012 is up and
running, you can make a remote connection and run commands or open an interactive Windows
PowerShell console. A Windows 8 client, on the other hand, ships with WinRm locked
down. Therefore, the first step is to use the Enable-PSRemoting function to configure remoting.
When running the Enable-PSRemoting function, the following steps occur:


1. Starts or restarts the WinRM service.

2. Sets the WInRM service startup type to Automatic.

3. Creates a listener to accept requests from any Internet Protocol (IP) address.

4. Enables inbound firewall exceptions for WS_Management traffic.

5. Sets a target listener named Microsoft.powershell.

6. Sets a target listener named Microsoft.powershell.workflow.

7. Sets a target listener named Microsoft.powershell32.

###5. Functions
####5.1 Creating a function
1) choose a good functionname.
   The function is going to retrieve information, so the best verb to use, 
is a verb that is already in the listing of the cmdlets verbs (best practice)
```
Function Function-Name
{
  #insert your code here
}
```
To execute script, use the command ```get-'functionname'```


####5.2 Using multiple input parameters
To use multiple input parameters, it's a best practise to modify the way the 
function is structured. This is a visual change that makes the function easier to read.
In the function pattern shown below, the function accepts three input parameters.

```
	Function Function-Name
	{
	Param(
	[int]$Parameter1,
	[String]$Parameter2 = "DefaultValue",
	$Parameter3
	)
	#Function code goes here
	} #end Function-Name
```

another example
```
	Function Format-IPOutput($IP)
	{
	"IP Address: " + $IP.IPAddress[0]
	"Subnet: " + $IP.IPSubNet[0]
	"GateWay: " + $IP.DefaultIPGateway
	"DNS Server: " + $IP.DNSServerSearchOrder[0]
	"FQDN: " + $IP.DNSHostName + "." + $IP.DNSDomain
	} #end Format-IPOutput
```
