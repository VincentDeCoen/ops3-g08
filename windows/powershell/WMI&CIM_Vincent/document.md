## Windows PowerShell 3.0 Step by step
--------------------------------------
###### Author: Vincent
----------------------
### Using WMI
-------------

Microsoft Windows Management Instrumentation (WMI) is included in almost every operating system
 released by Microsoft, that should give you an idea of the importance of this underlying technology.
 
From a network management perspective, many useful tasks can be
accomplished using just Windows PowerShell, but to begin to truly unleash the power of scripting,
you need to bring in additional tools. This is where WMI comes into play. WMI provides access to
many powerful ways of managing Windows systems.

#### The WMI model
------------------

WMI is a hierarchical namespace, in which the layers build on one another, like the Lightweight
Directory Access Protocol (LDAP) directory used in Active Directory, or the file system structure on
your hard drive.

The WMI model has three sections—resources, infrastructure, and
consumers—with the following uses:

1. **WMI resources** Resources include anything that can be accessed by using WMI—the file
system, networked components, event logs, files, folders, disks, Active Directory, and so on.

2. **WMI infrastructure** The infrastructure consists of three parts: the WMI service,
 the WMI repository, and the WMI providers. WMI providers are the most important because they provide 
 a way to access needed information.
 
3. **WMI consumers** A consumer provides a way to process data from WMI. A consumer can be a PowerShell
cmdlet, a VBScript script, or some other tool/utility that executes WMI queries. 

#### Working with objects and namespaces
----------------------------------------

You can think of a
namespace as a way to organize or collect data related to similar items. Visualize an old-fashioned filing
cabinet. Each drawer can represent a particular namespace. Inside this drawer are hanging folders
that collect information related to a subset of what the drawer actually holds. For example, at home
in my filing cabinet, I have a drawer reserved for information related to my woodworking tools. Inside
this particular drawer are hanging folders for my table saw, my planer, my joiner, my dust collector,
and so on.

We will work with three components; **namespaces, providers, and classes**. The namespaces are the
file cabinets. The providers are the drawers in the file cabinet. The folders in the drawers of the file
cabinet are the WMI classes.

Note: Namespaces can contain other namespaces, as well as other objects, and these objects contain properties
 you can manipulate.
 
Example: ```Get-WmiObject -class __Namespace -namespace root```

- The **Get-WmiObject** command is used to make the connection into WMI. 
- The **class** argument specifies the name of the class
- **__Namespace** is the name of the WMI class from which all WMI namespaces come from
- The *namespace* argument is root because it specifies the root level (the top namespace) in the
WMI namespace hierarchy.

The Get-WmiObject cmdlet returns a collection of management objects. 

Because of nesting (one namespace inside another namespace) the Get-WmiObject command returns portion
 of the namespaces on the computer. To avoid this situation, we can make a function:
 
 ```Get-WmiNameSpace
Function Get-WmiNameSpace
{
Param(
$nameSpace = "root",
$computer = "localhost"
)
Get-WmiObject -class __NameSpace -computer $computer `
-namespace $namespace -ErrorAction "SilentlyContinue" |
Foreach-Object `
-Process```

This function does the following: The **Get-WmiObject cmdlet** queries WMI. The **class parameter** 
limits the WMI query to the
__provider class. The **-namespace argument** tells the Get-WmiObject cmdlet to look only in the
Root\cimv2 WMI namespace. The array of objects returned from the **Get-WmiObject cmdlet** pipelines
to the Sort-Object cmdlet, where the listing of objects is alphabetized based on the name property.
After this process is completed, the reorganized objects pipeline to the **Select-Object cmdlet**, where
the name of each provider is displayed.


#### Working with WMI classes
-----------------------------

There are three classes in WMI, core classes, common classes, and dynamic classes. **Core classes** represent
 managed objects that apply to all areas of management. These classes providea basic vocabulary for analyzing
 and describing managed systems.**Two examples** of core classes are
**parameters** and the **SystemSecurity** class. Common classes are extensions to the core classes and represent
managed objects that apply to specific management areas. The **CIM_UnitaryComputerSystem** class is
an example of a common class.

To produce a simple listing of WMI classes, you can use the Get-WmiObject cmdlet and specify the
-list argument. In code: ```Get-WmiObject -list``` 

One of the big problems with WMI is finding the WMI class needed to solve a particular problem.
With literally thousands of WMI classes installed on even a basic Windows installation, searching
through all the classes is difficult at best.

The best solution is to stay focused on a single WMI namespace, and to use wildcard characters to
assist in finding appropriate WMI classes. For example, you can use the wildcard pattern "*bios*" to
find all WMI classes that contain the letters bios in the class name. In code: ```Get-WmiObject -List
 "*bios*"``` 

#### Querying WMI
-----------------

In most situations, when you use WMI, you are performing some sort of query. Even when you are
going to set a particular property, you still need to execute a query to return a data set that enables
you to perform the configuration.

A very simple example: **Get-WmiObject**

```gwmi win32_bios```

This command will give you more information about the BIOS on the host system.

Another example:

```gwmi win32_desktop | select name```

This command will give you all the names of the users on the host system.

#### Obtaining service information
----------------------------------

The command **Get-Service** shows all the services and their associated status.

We can sort on different ways:

**Get-Service |sort -property status** will sort on the property 'status', alphabetically.

**Get-Service |sort -property name** will sort on the property 'name', alphabetically.

**Get-Service |sort status, name** will first sort on the property 'status', then on the property
'name', and both alphabetically.

**Get-Service | where DisplayName -match "server"** will return all the services with "server" in 
the DisplayName.
 
### Querying WMI
----------------

**Get-WmiObject WIN32_computersystem** will return the default properties of the WIN32_ComputerSystem 
WMI class.

**Get-WmiObject WIN32_computersystem | Format-List name,model, manufacturer** will return the name,
 model and manufacturer from the WIN32_ComputerSystem WMI class (in this case the host system).
 
 If you want to retrieve ALL the properties from the WIN32_computersystem class, than you can use
 the following command:
 
 **Get-WmiObject WIN32_ComputerSystem | Format-List * **

We can find aliases by using the following command: **Get-Alias**

For example: **Get-Alias | where definition -eq 'Get-WmiObject'**

#### Tell me everything about everything!
-----------------------------------------

When novices first write WMI scripts, they nearly all begin by asking for every property from
every instance of a class. That is, the queries will essentially say, “Tell me everything about every
process.” (This is also referred to as the infamous select * query.) This approach can often return
an overwhelming amount of data, particularly when you are querying a class such as installed
software or processes and threads. Rarely would one need to have so much data. Typically, when
looking for installed software, you’re looking for information about a particular software package.

There are, however, several occasions when you may want to use the “Tell me everything
about all instances of a particular class” query, including the following:

- During development of a script to see representative data
- When troubleshooting a more directed query—for example, when you’re possibly trying
to filter on a field that does not exist
- When the returned items are so few that being more precise doesn’t make sense.

To return all information from all instances, perform the following steps:

1. Make a connection to WMI by using the Get-WmiObject cmdlet.
2. Use the **-query** argument to supply the WQL query to the Get-WmiObject cmdlet.
3. In the query, use the **Select** statement to choose everything: Select *.
4. In the query, use the **From** statement to indicate the class from which you wish to
retrieve data. For example, **From Win32_Share**.

#### Working with running processes
-----------------------------------

Use the **Get-Process** cmdlet to obtain a listing of processes on your machine.

To return information about the Explorer process, use the **-name** argument:
**Get-Process -name explorer**.

Use the Get-WmiObject cmdlet to retrieve information about processes on the machine. Pipe
the results into the more function: **Get-WmiObject win32_process | more**

To retrieve information only about the Explorer.exe process, use the -filter argument and
specify that the name property is equal to Explorer.exe: **Get-WmiObject win32_process 
-Filter "name='explorer.exe'"**

**Caution** When using the -filter argument of the Get-WmiObject cmdlet, pay attention to
the use of quotation marks. The -filter argument is surrounded by double quotation marks.
The value being supplied for the property is surrounded by single quotes—for example,
-Filter "name='explorer.exe'". This can cause a lot of frustration if not followed exactly.

#### Choosing specific instances
--------------------------------

In many situations, you will want to limit the data you return to a specific instance of a particular
WMI class in the data set. If you go back to your query and add a Where clause to the Select statement,
you’ll be able to greatly reduce the amount of information returned by the query. Notice that in the value 
associated with the WMI query, you added a dependency that indicated you wanted only information with share
 name C$. This value is not case sensitive, but it must be surrounded with single
quotation marks, as you can see in the WMI Query string in the following script. These single quotation
marks are important because they tell WMI that the value is a string value and not some other
programmatic item.

To limit specific data, do the following:

1. Make a connection to WMI by using the Get-WmiObject cmdlet.
2. Use the Select statement in the WMI Query argument to choose the specific property you are
interested in—for example, Select name.
3. Use the From statement in the WMI Query argument to indicate the class from which you
want to retrieve data—for example, From Win32_Share.
4. Add a Where clause in the WMI Query argument to further limit the data set that is returned.
Make sure the properties specified in the Where clause are first mentioned in the Select statement—
for example, Where name.
5. Add an evaluation operator. You can use the equal sign (=), or the less-than (<) or greater-than
(>) symbols—for example, Where name = 'C$'.

#### Utilizing an operator
--------------------------

One of the nice things you can do is use greater-than and less-than operators in your evaluation
clause. What is so great about greater-than? It makes working with some alphabetic and numeric
characters easy. If you work on a server that hosts home directories for users (which are often named
after their user names), you can easily produce a list of all home directories from the letters D through
Z by using the > D operation. Keep in mind that D$ is greater than D, and if you really want shares
that begin with the letter E, then you can specify “greater than or equal to E.” This command would
look like >='E'.

##### Identifying service accounts
----------------------------------

We want to make a script that gives us the name and startname from the WMI class 'WIN32_Service'.

The script looks like this:

```$strComputer = "."
$wmiNS = "root\cimv2"
$wmiQuery = "Select startName, name from win32_service"
$objWMIServices = Get-WmiObject -computer $strComputer `
-namespace $wmiNS -query $wmiQuery
$objWMIServices | Sort-Object startName, name |
Format-List name, startName```

##### Where is the where?
----------------------------------

To more easily modify the Where clause in a WMI query, substitute the Where clause with a variable.
This configuration can be modified to include command-line input as well.

```$strComputer = "."
$wmiNS = "root\cimv2"
$strWhere = "'ipc$'"
$wmiQuery = "Select * from win32_Share where name="+$strWhere
"Properties of Share named: " + $strWhere
$objWMIServices = Get-WmiObject -computer $strComputer `
-namespace $wmiNS -query $wmiQuery
$objWMIServices |
Format-List -property [a-z]*```

####Working with software
-------------------------

#####Using WMI to find installed software
-----------------------------------------

We want to make a script that counts the amount of programmes installed on our computer.

1. First we declare a variable to indicate we want to connect to WMI on our local machine:
```$strComputer = "."``` 
2. On the next line we use the root namespace: ```$wmiNS = "root\cimv2"``` 
3. We create our query: ```$wmiQuery = "Select * from win32_product"```
4. We inform the user what the computer is doing: ```Write-Host "Counting Installed Products. This" `
"may take a little while. " -foregroundColor blue `n```
5. ```$objWMIServices = Get-WmiObject -computer $strComputer``` 
6. Here we specify the WMI namespace: ```-namespace $wmiNS -query $wmiQuery``` 
7. We will use a for statement to print out the progress indicator: 
```for ($i=1; $i -le $objWMIServices.count;$i++)```
8. ```{Write-Host "/\" -noNewLine -foregroundColor red}```
9. ```Write-Host `n`n "There are " $objWMIServices.count `
" products installed."```

Now we add a timer to know how long the script took to run completely:

10. ```$dteStart = Get-Date```
11. ```$dteEnd = Get-Date```
12. ```$dteDiff = New-TimeSpan $dteStart $dteEnd```
13. ```Write-Host "It took " $dteDiff.totalSeconds " Seconds" `
" for this script to complete"```

Here is an example of output the script can return:
```Counting Installed Products. This may take a little while.
/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
/\/\/\/\/\/\/\
There are 87 products installed.
It took 120.3125 Seconds for this script to complete```

#####Windows environment variables
-----------------------------------------

Use the Get-WmiObject cmdlet to view the common properties of the WIN32_Environment
WMI class.

```gwmi win32_environment``` 

To view all the properties of the WIN32_Environment class, we can use this command:

```gwmi win32_environment | Format-List *```

We can create a table-view to have a better view:

```gwmi win32_environment | Format-Table name, variableValue, userName```

### Remoting WMI
----------------

Microsoft Windows Management Instrumentation (WMI) remoting is an essential part of Windows
PowerShell. In fact, way back in Windows PowerShell 1.0, WMI remoting was one of the primary ways
of making configuration changes on remote systems. Windows Server 2012 permits remote WMI by
default. The Windows 8 client does not. The best way to manage the Windows 8 client is to use group
policy to permit the use of WMI inbound. Keep in mind, the issue here is the Windows firewall, not
WMI itself.

####Supplying alternate credentials for the remote connection
-------------------------------------------------------------

A low-level user can make a remote WMI connection by supplying credentials that have local admin
rights on the target system. The Get-WMIObject Windows PowerShell cmdlet accepts a credential
object. There are two common ways of supplying the credential object for the remote connection.
The first way is to type the domain and the user name values directly into the credential parameter.
When the Get-WMIObject cmdlet runs, it prompts for the password.

For example:

```gwmi win32_bios -cn w8s504 -Credential Vincent\administrator``` 

So in this command we try to make a connection to a computer named 'w8s504'.

When we run the command, a dialog box appears prompting for the password to use for the connection.

####Storing the credentials for a remote connection
---------------------------------------------------

There is only one problem with supplying the credential directly to the credential parameter for the
Get-WMIObject cmdlet—it requires you to supply the credential each time you run the command.
This requirement is enforced when you use the up arrow key to retrieve the command, as well as for
any subsequent connections to the same remote system.

To store your credentials
for later consumption, use the Get-Credential Windows PowerShell cmdlet to retrieve your credentials
and store the resulting credential object in a variable.

```$credential = Get-Credential -Credential iammred\administrator```
```gwmi win32_bios -cn w8s504 -Credential $credential```

Now we are able to see information about the BIOS from the computer named 'w8s504'.

We are able to do this on multiple computers at the same time:

```$credential = Get-Credential -Credential iammred\administrator```
```$cn = "w8s504","hyperv2","hyperv3"```
```gwmi win32_bios -cn $cn -Credential $credential```

One problem with the preceding output is that it does not contain the name of the remote system.

To fix this we pipe the output to a select command:

```gwmi win32_bios -cn $cn -Credential $credential | select
smbiosbiosversion, manufacturer, name, serialnumber, __server```

This is an example output:

```smbiosbiosversion : 090004
manufacturer : American Megatrends Inc.
name : BIOS Date: 03/19/09 22:51:32 Ver: 09.00.04
serialnumber : 0385-4074-3362-4641-2411-8229-09
__SERVER : W8S504

smbiosbiosversion : A11
manufacturer : Dell Inc.
name : Phoenix ROM BIOS PLUS Version 1.10 A11
serialnumber : BDY91L1
__SERVER : HYPERV2

smbiosbiosversion : BAP6710H.86A.0072.2011.0927.1425
manufacturer : Intel Corp.
name : BIOS Date: 09/27/11 14:25:42 Ver: 04.06.04
serialnumber :
__SERVER : HYPERV3```

#### Using Windows PowerShell remoting to run Wmi
-------------------------------------------------

Use of the Get-WMIObject cmdlet is a requirement for using WMI to talk to down-level systems—
systems that will not even run Windows PowerShell 2.0. There are several disadvantages to using
native WMI remoting:

- WMI remoting requires special firewall rules to permit access to client systems.
- WMI remoting requires opening multiple holes in the firewall.
- WMI remoting requires local administrator rights.
- WMI remoting provides no support for alternate credentials on a local connection.
- WMI remoting output does not return the name of the target system by default.

As shown here, you can run WMI commands against remote systems
with a single command, and engage multiple operating systems. The nice thing is the inclusion of
the PSComputerName property. Because the Invoke-Command cmdlet accepts an array of computer
names, the command is very simple.

```$credential = Get-Credential iammred\administrator```
```$cn = "dc1","dc3","hyperv1","W8s504"```
```Invoke-Command -cn $cn -cred $credential -ScriptBlock {gwmi win32_
operatingsystem}```

Example output:

```
SystemDirectory : C:\Windows\system32
Organization :
BuildNumber : 8504
RegisteredUser : Windows User
SerialNumber : 00184-70000-00072-AA253
Version : 6.2.8504
PSComputerName : W8s504

SystemDirectory : C:\Windows\system32
Organization :
BuildNumber : 7601
RegisteredUser : Windows User
SerialNumber : 55041-507-3502855-84574
Version : 6.1.7601
PSComputerName : hyperv1

SystemDirectory : C:\Windows\system32
Organization :
BuildNumber : 6002
RegisteredUser : Windows User
SerialNumber : 55041-222-5263084-76207
Version : 6.0.6002
PSComputerName : dc1

SystemDirectory : C:\Windows\system32
Organization :
BuildNumber : 7601
RegisteredUser : Windows User
SerialNumber : 55041-507-0212466-84605
Version : 6.1.7601
PSComputerName : dc3
```

#### Using CIM classes to query WMI classes
-------------------------------------------

There are several ways of using the **Common Information Model (CIM)** classes to perform remote
WMI queries. The most basic way is to use the Get-CimInstance cmdlet. In fact, this generic method
is required if no specific CIM implementation class exists. There are steps required to use the
Get-CimInstance cmdlet to query a remote system.

#####Using CIM to query remote WMI data
---------------------------------------

Use the New-CimSession cmdlet to create a new CIM session. Store the returned session in a variable.
Supply the stored CIM session from the variable to the -cimsession parameter when querying with
the Get-CIMInstance cmdlet.

```$w8s504 = New-CimSession -ComputerName w8s504
-Credential iammred\administrator```

```Get-CimInstance -CimSession $w8s504 -ClassName win32_bios```

The code above creates a new CIM session with a target computer of W8s504 and a user name of Iammred\administrator. The cmdlet returns a CIM session
that it stores in the $w8s504 variable. Next, the Get-CimInstance cmdlet uses the CIM session to connect
to the remote w8s504 system and to return the data from the Win32_bios WMI class. The output
is displayed in the Windows PowerShell console.

Example output:

```
SMBIOSBIOSVersion : 090004
Manufacturer : American Megatrends Inc.
Name : BIOS Date: 03/19/09 22:51:32 Ver: 09.00.04
SerialNumber : 0385-4074-3362-4641-2411-8229-09
Version : VRTUAL - 3000919
PSComputerName : w8s504
```

#### Running WMI jobs
---------------------

To do this, use the Get-WMIObject cmdlet and specify the
-asjob parameter. Once you do this, use the Get-Job cmdlet to check on the status of the job, and
use Receive-Job to receive the job results.

```gwmi win32_bios -ComputerName dc3 -AsJob```

In this command the Get-WMIObject cmdlet retrieves information
from the Win32_Bios WMI class from a machine named dc3. The -asjob switched parameter is used to
ensure that the command runs as a job.

```Get-Job -id 2```

The Get-Job cmdlet is used to retrieve the status of the WMI job. From the output appearing here,
it is apparent that the job with an ID of 2 has completed, and that the job has more data to deliver.

```Receive-Job -id 2```

As with any other job in Windows PowerShell, to receive the results of the WMI job, use the
Receive-Job cmdlet.

Example output: 

```
SMBIOSBIOSVersion : 090004
Manufacturer : American Megatrends Inc.
Name : BIOS Date: 03/19/09 22:51:32 Ver: 09.00.04
SerialNumber : 8994-9999-0865-2542-2186-8044-69
Version : VRTUAL - 3000919
```

If you do not have DCOM and RPC access to the remote system, you can use the Invoke-Command
cmdlet to run the WMI command on the remote system as a job.

```$credential = Get-Credential iammred\administrator```
```Invoke-Command -ComputerName w8s504 -Credential $credential
-ScrtBlock {gwmi win32_service} -AsJob```

#### Using Windows PowerShell remoting and WMI
----------------------------------------------

#####Using PowerShell remoting to retrieve remote information
-------------------------------------------------------------

1. Log on to your computer with a user account that does not have administrator rights.
2. Open the Windows PowerShell console.
3. Use the Get-CimInstance cmdlet to retrieve process information from a remote system that
has WMI remoting enabled on it. Do not supply alternate credentials. The command appears
here:
```Get-CimInstance -CimSession w8s504 -ClassName win32_process```
4. The command fails due to an Access Denied error. Now create a new CIM session to the
remote system and connect with alternate credentials. Store the CIM session in a variable
named $session. This command appears following. (Use a remote system accessible to you and
credentials appropriate to that system.)
```$session = New-CimSession -Credential iammred\administrator -ComputerName w8s504```
5. Use the stored CIM session from the $session variable to retrieve process information from the
remote system. The command appears here:
```Get-CimInstance -CimSession $session -ClassName win32_process```
6. Use the stored CIM session from the $session variable to retrieve the name and the status of
all services on the remote system. Sort the output by state, and format a table with the name
and the state. The command appears here:
```Get-CimInstance -CimSession $session -ClassName win32_service -Property name, state |
sort state | ft name, state -AutoSize```
7. Use the Get-WMIObject cmdlet to run a WMI command on a remote system. Use the Win32_
Bios WMI class and target the same remote system you used earlier. Specify appropriate
credentials for the connection. Here is an example:
```$credential = Get-Credential iammred\administrator
Get-WmiObject -Class win32_bios -ComputerName w8s504 -Credential $credential```
8. Use Windows PowerShell remoting by using the Invoke-Command cmdlet to run a WMI
command against a remote system. Use the credentials you stored earlier. Use the Get-
CimInstance cmdlet to retrieve BIOS information from WMI. The command appears here:
```Invoke-Command -ComputerName w8s504 -ScriptBlock {Get-CimInstance win32_bios} -Credential
$credential```

##### Creating and reveiving WMI jobs
-------------------------------------

1. Open the Windows PowerShell console as a non-elevated user.
2. Use the Get-WMIObject cmdlet to retrieve BIOS information from a remote system. Use the
-asjob parameter to run the command as a job. Use the credentials you stored in the $credential
variable in the previous exercise.
```Get-WmiObject win32_bios -ComputerName w8s504 -Credential $credential -AsJob```
3. Check on the success or failure of the job by using the Get-Job cmdlet. Make sure you use the
job ID from the previous command. A sample appears here:
```Get-Job -Id 10```
4. If the job was successful, receive the results of the job by using the Receive-Job cmdlet. Do
not bother with storing the results in a variable or keeping the results because you will not
need them.
5. Create a new PowerShell session object by using the New-PSSession cmdlet. Store the results
in a variable named $psSession. The command appears following. (Use appropriate computer
names and credentials for your network.)
```$PSSession = New-PSSession -Credential iammred\administrator -ComputerName w8s504```
6. Use the Invoke-Command cmdlet to make the Get-WMIObject cmdlet retrieve BIOS information
from the remote system. Use the session information stored in the $psSession variable.
Make sure you use the -asjob parameter with the command. The command appears here:
```Invoke-Command -Session $PSSession -ScriptBlock {gwmi win32_bios} -AsJob```
7. Use the Get-Job cmdlet with the job ID returned by the previous command to check on the
status of the job. The command will be similar to the one shown here:
```Get-Job -id 12```
8. Use the Receive-Job cmdlet to retrieve the results of the WMI command. Store the returned
information in a variable named $bios. The command appears here (ensure you use the job ID
number from your system):
```$bios = Receive-Job -id 12```
9. Now query the BIOS version by accessing the version property from the $bios variable. This
appears here:
```$bios.Version```

### Calling WMI Methods on WMI Classes
--------------------------------------

There are actually several ways to call Microsoft Windows Management Instrumentation (WMI)
methods in Windows PowerShell. One reason for this is that some WMI methods are instance methods,
which means they only work on an instance of a class. Other methods are static methods, which
mean they do not operate on an instance of the class.

First we create an instance from notepad.

```Start-Process notepad```

```gwmi win32_process -Filter "name = 'notepad.exe'"```

Once you have the instance of the Notepad process you want to terminate, there are at least four
choices to stop the process:

- You can call the method directly using dotted notation (because there is only one instance of
notepad).
- You can store the reference in a variable and then terminate it directly.
- You can use the Invoke-WmiMethod cmdlet.
- You can use the [wmi] type accelerator.

#### Using the terminate method directly
---------------------------------------

```(gwmi win32_process -Filter "name = 'notepad.exe'").terminate()```

#### Using the dotted notation
-----------------------------

```
notepad
notepad
$a = gwmi win32_process -Filter "name = 'notepad.exe'"
$a.terminate()
```

#### Using the Invoke-WmiMethod cmdlet
--------------------------------------

```
notepad
$a = gwmi win32_process -Filter "name = 'notepad.exe'"
$a.__RELPATH Win32_Process.Handle="1872"
Invoke-WmiMethod -Path $a.__RELPATH -Name terminate
```

#### Using the WMI type accelerator
-----------------------------------

Another way to call an instance method is to use the [wmi] type accelerator. The [wmi] type accelerator
works with WMI instances. Therefore, if you pass a path to the [wmi] type accelerator, you can call
instance methods directly.

#### Stopping several instances of a process using Wmi
------------------------------------------------------

1. Log on to your computer with a user account that does not have administrator rights.
2. Open the Windows PowerShell console.
3. Start five copies of Notepad. The command appears here:
```1..5 | % {notepad}```
4. Use the Get-WmiObject cmdlet to retrieve all instances of the notepad.exe process. The command
appears here:
```gwmi win32_process -Filter "name = 'notepad.exe'"```
5. Now pipeline the resulting objects to the Remove-WmiObject cmdlet.
```gwmi win32_process -Filter "name = 'notepad.exe'" | Remove-WmiObject```
6. Start five instances of notepad. The command appears here:
```1..5 | % {notepad}```
7. Use the up arrow key to retrieve the Get-WmiObject command that retrieves all instances of
Notepad.exe. The command appears here:
```gwmi win32_process -Filter "name = 'notepad.exe'"```
8. Store the returned WMI objects in a variable named $process. This command appears here:
```$process = gwmi win32_process -Filter "name = 'notepad.exe'"```
9. Call the terminate method from the $process variable. The command appears here:
```$process.terminate()```
10. Start five copies of notepad back up. The command appears here:
```1..5 | % {notepad}```
11. Use the up arrow key to retrieve the Get-WmiObject command that retrieves all instances of
Notepad.exe. The command appears here:
```gwmi win32_process -Filter "name = 'notepad.exe'"```
12. Call the terminate method from the above expression. Put parentheses around the expression,
and use dotted notation to call the method. The command appears here:
```(gwmi win32_process -Filter "name = 'notepad.exe'").terminate()```


#### Executing static WMI methods
---------------------------------

1. Open the Windows PowerShell console as a user that has admin rights on the local computer.
To do this, you can right-click the Windows PowerShell console shortcut and select Run As
Administrator from the menu.
2. Create a test folder off of the root named testshare. Here is the command using the MD alias
for the mkdir function:
```MD c:\testshare```
3. Create the Win32_Share object and store it in a variable named $share. Use the [wmiclass]
type accelerator. The code appears here:
```$share = [wmiclass]"win32_share"```
4. Call the static create method from the Win32_Share object stored in the $share variable. The
arguments are path, name, type, maximumallowed, description, password, and access. However,
you only need to supply the first three. type is 0, which is a disk drive share. The syntax of the
command appears here:
```$share.Create("C:\testshare","testshare",0)```
5. Use the Get-WmiObject cmdlet and the Win32_Share class to verify that the share was properly
created. The syntax of the command appears here:
```gwmi win32_share```
6. Now add a filter so that the Get-WmiObject cmdlet only returns the newly created share. The
syntax appears here:
```gwmi win32_share -Filter "name = 'testshare'"```
7. Remove the newly created share by pipelining the results of the previous command to the
Remove-WmiObject cmdlet. The syntax of the command appears here:
```gwmi win32_share -Filter "name = 'testshare'" | Remove-WmiObject```
8. Use the Get-WmiObject cmdlet and the Win32_Share WMI class to verify that the share was
properly removed. The command appears here:
```gwmi win32_share```

### Using the CIM Cmdlets
-------------------------

#### Using the CIM cmdlets to explore WMI classes
------------------------------------------------

In Microsoft Windows PowerShell 3.0, the Common Information Model (CIM) exposes a new application
programming interface (API) for working with Windows Management Instrumentation (WMI)
information. The CIM cmdlets support multiple ways of exploring WMI.

**Note** The default WMI namespace on all operating systems after Windows NT 4.0 is Root/
Cimv2. Therefore, all of the CIM cmdlets default to Root/Cimv2. The only time you need to
change the default WMI namespace (via the namespace parameter) is when you need to
use a WMI class from a nondefault WMI namespace.

```Get-CimClass -ClassName *computer*```

#### Finding WMI class methods
------------------------------

```Get-CimClass -ClassName *process* -MethodName term*```

To find all WMI classes related to processes that expose any methods, you would use the command
appearing here:

```Get-CimClass -ClassName *process* -MethodName *```

To find any WMI class in the root/cimv2 WMI namespace that expose a method called create, use
the command appearing here:

```Get-CimClass -ClassName * -MethodName create```

#### Retrieving WMI instances
-----------------------------

To query for WMI data, use the Get-CimInstance cmdlet. The easiest way to use the Get-CimInstance
cmdlet is to query for all properties and all instances of a particular WMI class on the local machine.

```Get-CimInstance win32_bios```

#### Working with associations
------------------------------

The first thing to do when attempting to find a WMI association class is retrieve a CIM instance
and store it in a variable. In the example that follows, instances of the Win32_LogonSession WMI
class are retrieved and stored in the $logon variable. Next, the Get-CimAssociatedInstance cmdlet is
used to retrieve instances associated with this class. To see what type of objects will return from the
command, pipe the results to the Get-Member cmdlet.

```$logon = Get-CimInstance win32_logonsession```
```Get-CimAssociatedInstance $logon | Get-Member```

#### Retrieving WMI instances
-----------------------------

##### Exloring WMI video classes
--------------------------------

1. Log on to your computer with a user account that does not have administrator rights.
2. Open the Windows PowerShell console.
3. Use the Get-CimClass cmdlet to identify WMI classes related to video. The command and
associated output appear here:
```Get-CimClass *video*```
4. Filter the output to only return dynamic WMI classes related to video. The command and
associated output appear here:
```Get-CimClass *video* -QualifierName dynamic```
5. Display the cimclassname and the cimclassqualifiers properties of each found WMI class. To do
this, use the Format-Table cmdlet. The command and associated output appear here:
```Get-CimClass *video* -QualifierName dynamic | ft cimclassname, cimclassqualifiers```
6. Change the $FormatEnumerationLimit value from the original value of 4 to 8 to permit viewing
of the truncated output. Remember that you can use tab expansion to keep from typing
the entire variable name. The command appears here:
```$FormatEnumerationLimit = 8```
7. Now use the up arrow key to retrieve the previous Get-CimClass command. Add the autosize
command to the table. The command and associated output appear here:
```Get-CimClass *video* -QualifierName dynamic | ft cimclassname, cimclassqualifiers
-autosize```
8. Query each of the three WMI classes. To do this, pipeline the result of the Get-CimClass command
to the ForEach-Object command. Inside the script block, call Get-CimInstance and pass
the cimclassname property. The command appears here:
```Get-CimClass *video* -QualifierName dynamic | % {Get-CimInstance $_.cimclassname}```

##### Retrieving associated WMI classes
---------------------------------------

1. Open the Windows PowerShell console as a non-elevated user.
2. Use the Get-CimInstance cmdlet to retrieve the Win32_VideoController WMI class. The command
appears following. Store the returned WMI object in the $v variable.
```$v = gcim Win32_VideoController```
3. Use the Get-CimAssociatedInstance cmdlet and supply $v to the inputobject parameter. The
command appears here:
```Get-CimAssociatedInstance -InputObject $v```
4. Use the up arrow key to retrieve the previous command. Pipeline the returned WMI objects to
the Get-Member cmdlet. Pipeline the results from the Get-Member cmdlet to the Select-Object
cmdlet and use the -unique switched parameter to limit the amount of information returned.
The command appears here:
```Get-CimAssociatedInstance -InputObject $v | Get-Member | select typename -Unique```
5. Use the up arrow key to retrieve the previous command and change it so that it only returns
instances of Win32_PNPEntity WMI classes. The command appears here:
```Get-CimAssociatedInstance -InputObject $v -ResultClassName win32_PNPEntity```
6. Display the complete information from each of the associated classes. To do this, pipeline the
result from the Get-CimAssociatedInstance cmdlet to a ForEach-Object cmdlet, and inside the
loop, pipeline the current object on the pipeline to the Format-List cmdlet. The command
appears here:
```Get-CimAssociatedInstance -InputObject $v | ForEach-Object {$input | Format-List*}```

























