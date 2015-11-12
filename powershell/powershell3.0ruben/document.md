# Powershell 3.0 First Steps
------------------------------
###### Author: Ruben

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

######Example:
```SetExecutionPolicy -Scope CurrentUser -ExecutionPolicy remotesigned```

### 2 Sorting, Filtering, Grouping
---------------------------------------
#### 2.1 Sorting output from a cmdlet
---------------------------------------
To sort the output from a cmdlet, you have to use pipelines.
The ```Get-Process``` command shows a nice table view of process information. 
The default view appears in ascending alphabetical process name order. 
If you want to sort the process information on for example virtual memory, 
then you can use the pipeline: ```Get-Process | Sort-Object -Property VM -Descending```.
A tip: the command ```Sort``` is an alias for ```Sort-Object```

//AFB 1//

#### 2.1 Sorting output from a cmdlet
---------------------------------------
