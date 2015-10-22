uit: OReilly Windows Powershell Cookbook 3rd edition (2013)

## Guided Tour

### PowerShell: an interactive shell

A few features:

* DOS-style + Unix-style commands to navigate file system
* 'classic' tools (such as `ipconfig`) are available, just as in cmd.exe
* PowerShell **cmdlets**:
  * these are native PowerShell commands
  * long form syntax: Verb-Noun form eg. Get-Process
  * pre-defined and user-defined aliases eg. gps = alias for Get-Process
  * **case-insensitive**
  * positional parameters supported (= position of supplied value determines which parameter the value is supplied for)

### PowerShell: integration of objects, XML, WMI, CIM, ADSI, COM objects

* All PowerShell commands that produce output generate that **output as objects** (.NET) -> can be stored in variables, have properties, have methods you can call, ... eg. Get-Process -> generates System.Diagnostics.Process object
* Variable names: start with '$'
* PowerShell supports XML
* PowerShell lets you work with Windows Management Instrumentation (WMI) and Common Information Model ([CIM](http://blogs.technet.com/b/heyscriptingguy/archive/2014/01/27/what-is-cim-and-why-should-i-use-it-in-powershell.aspx))  

          PS > Get-CimInstance Win32_Bios

### PowerShell: namespace navigation through providers

A Windows PowerShell provider is an abstraction layer that lets you navigate different types of data stores (filesystem, registry, SQL Server, ...) in a unified way.

### PowerShell: composable commands - scripting everywhere

* Command **pipelines**: `|` to pass output from one command through to another command
* cmdlets work in scripts - scripting techniques (eg. foreach) work on the command line
* objects from .NET framework are directly available on the command line eg. System.Net.WebClient
* `Get-History`: retrieve session history -> can be used to create a script based on the last commands you entered

```
PS > Get-History | Foreach-Object { $_.CommandLine } > c:\temp\script.ps1
```

=> blurs lines between interactive administration and scripting

Common discovery commands:

* `Get-Command WILDCARD` = find all commands that match WILDCARD pattern (eg. \*process\* -> all commands that contain the word 'process')
* `Get-Help COMMAND` = get information on function of COMMAND
* `Get-Member` = retrieve information about properties and methods supported by an object

## Fundamentals 1: The PowerShell interactive shell

### Run programs, scripts, batch files

##### Command name

To run an executable command: enter filename (path if the command is not in the system's path)

* If there is a **space in its name**: enclose filename in single quotes (') **and precede with an ampersand (&)**  
  This is different from cmd.exe: merely placing a program name in quotes is not enough to be able to execute it, because without the '&' (the invoke operator), it is just a string.
* Run command in **current directory**: place **.\** in front of filename  
  This is different from cmd.exe: in PowerShell, the current directory is not automatically considered part of the system's path. This is a security precaution: it prevents malicious users from placing programs in a directory that have the names of commands you might use in the directory.  
  If you want PowerShell to always look in the current directory when executing commands, add . to PATH.
  If you have utilities and scripts you use often, consider collecting them in one folder and adding that folder to PATH.

          $scope = "User"
      $pathElements = @([Environment]::GetEnvironmentVariable("Path", $scope)
      -split ";")
      $pathElements += "d:\tools"
      $newPath = $pathElements -join ";"
      [Environment]::SetEnvironmentVariable("Path", $newPath, $scope)

* Security policies may prevent your script from running. If so, you may have to configure the correct execution policy (cmdlet Set-ExecutionPolicy)

##### Command arguments

To specify an argument to a command: just type it

Dynamic arguments (eg. result of user input): store them in a variable and pass that variable to the command

Careful when using cmdlet Invoke-Expression: this treats the entire string you give it as a complete PowerShell script! Eg. filenames are allowed to contain ';' but in a script this is treated as a new line.

### Run PowerShell commands

##### Execute

To execute a cmdlet: type its name at the prompt.

Command name syntax is predictable: Verb-Noun, where Verb describes the action the command takes and Noun describes what it acts on.

##### Find information

Finding cmdlets: Get-Command
* summary information: `Get-Command COMMANDNAME`
* detailed information: `Get-Command COMMANDNAME | Format-List`
* search for commands containing TEXT: `Get-Command *TEXT*`
* search for command containing verb 'Get': `Get-Command -Verb Get`
* search for command acting on a particular service: `Get-Command -Noun SERVICENAME`

Finding information about cmdlets: Get-Help
* summary information: `Get-Help COMMANDNAME` or `COMMANDNAME -?`
* detailed information: `Get-Help COMMANDNAME -Detailed` (includes parameter descriptions and examples)
* full help information: `Get-Help COMMANDNAME -Full`
* get only examples: `Get-Help COMMANDNAME -Examples`
* get online version (most up-to-date): `Get-Help COMMANDNAME -Online`
* show graphical view (searchable): `Get-Help COMMANDNAME -ShowWindow`
* like Get-Command, Get-Help supports wildcards

Finding information about topics: `Get-Help KEYWORD`

##### Making sure information is up-to-date

Updating help: `Update-Help`

Out of the box: help contains only information built into commands themselves (name, syntax, parameters, default values). To get more, you have to run Update-Help (downloads content from the Internet by default, or a specified path if you use the -SourcePath parameter).
