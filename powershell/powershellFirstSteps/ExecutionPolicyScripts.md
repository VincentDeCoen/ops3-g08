### Setting the Script Execution Policy
-------------- -------------------------
###### Author: Ruben

If you have administrator rights on your system, you can set the script execution policy.
The command that is used to set the execution policy is ```Set-ExecutionPolicy```.
The Policies you can use, are shown below.

#####1. Restricted 
..Does not load configuration files or run scripts. Restricted is the default.
#####2. AllSigned 
..Requires that a trusted publisher sign all scripts and configuration files, including scripts that you write on the local computer.
#####4. RemoteSigned 
..Requires that a trusted publisher sign all scripts and configuration
files downloaded from the Internet.
#####5.Unrestricted 
..Loads all configuration files and runs all scripts. 
..If you run an unsigned script that was downloaded from the Internet, you are prompted for permission before
it runs.
#####6. Bypass 
..Nothing is blocked and there are no warnings or prompts.
#####7. Undefined Removes the currently assigned execution policy from the current scope.
..This parameter does not remove an execution policy that is set in a Group Policy
scope.

