### Setting the Script Execution Policy
-------------- -------------------------
###### Author: Ruben

####A Policy

If you have administrator rights on your system, you can set the script execution policy.
The command that is used to set the execution policy is ```Set-ExecutionPolicy```.
The Policies you can use, are shown below.

##### 1. Restricted 
Does not load configuration files or run scripts. Restricted is the default.
##### 2. AllSigned 
Requires that a trusted publisher sign all scripts and configuration files, including scripts that you write on the local computer.
##### 3. RemoteSigned 
Requires that a trusted publisher sign all scripts and configuration
files downloaded from the Internet.
##### 4.Unrestricted 
Loads all configuration files and runs all scripts. 
If you run an unsigned script that was downloaded from the Internet, you are prompted for permission before
it runs.
##### 5. Bypass 
Nothing is blocked and there are no warnings or prompts.
##### 6. Undefined Removes the currently assigned execution policy from the current scope.
This parameter does not remove an execution policy that is set in a Group Policy
scope.

#### The Scope Of A Policy

##### 1. Process
The policy only affects the current process
##### 2. CurrentUser
The policy only affects the current user
##### 3. LocalMachine
The policy affects all the users of the machine

######Example:
```SetExecutionPolicy -Scope CurrentUser -ExecutionPolicy remotesigned```
