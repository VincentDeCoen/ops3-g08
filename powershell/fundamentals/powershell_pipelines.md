### Introduction

Pipeline = a series of commands where the output of one becomes the input of the next.

Separating stages of the pipeline: `|` (pipe character)

How pipelines in PowerShell differ from those in all other shells: PowerShell passes **objects** along the pipeline, **rather than plain-text output**. This means you don't have to know the specifics of the output formatting for a particular command (which columns is the information you're looking for in, ...) to correctly define processing.

### Filter Items in a list or command output

cmdlet: `Where-Object { CONDITION }`  
Aliases: where, ?

If the script block containing _condition_ returns `True`, the object is passed along.

In the script block, the current input object is represented by variable `$_` or `$PSItem`.

Starting in PS 3.0, you can also use [comparison statements] (https://technet.microsoft.com/en-us/library/hh849715.aspx) without using a script block (see example 4).

Starting in PS 3.0, you can also interactively filter lists. Use the `Out-GridView` cmdlet (alias ogv) with parameter -PassThru. This gives you an interactive pop-up where your output is displayed in a table. You can select the lines you want to keep before pressing OK. See example 5.

Examples

1. To list all running processes that have “search” in their name, use the -like operator to
compare against the process’s Name property:

  `Get-Process | Where-Object { $_.Name -like "*Search*" }`

2. To list all processes not responding, test the Responding property:  

  `Get-Process | Where-Object { -not $_.Responding }`

3. To list all stopped services, use the -eq operator to compare against the service’s Status
property:  

  `Get-Service | Where-Object { $_.Status -eq "Stopped" }`

4. For simple comparisons on properties, you can omit the script block syntax and use the
comparison parameters of Where-Object directly:  

  `Get-Process | Where-Object Name -like "*Search*"`

5. You can use Out-GridView -PassThru to create a simple script based on your PS command history:  

    PS > $script = Get-History | Foreach-Object CommandLine | Out-GridView -PassThru
    PS > $script | Set-Content c:\temp\script.ps1


### Group data by property name

cmdlet: `Group-Object -AsHash PROPERTY`

In some situations, you might find yourself repeatedly calling the Where-Object cmdlet to interact with the same list or output:

        PS > $processes = Get-Process
        PS > $processes | Where-Object { $_.Id -eq 1216 }

In this case, you can use Group-Object with the -AsHash parameter to create a hashtable that has the values for the property name provided to -AsHash as keys:

        PS > $processes = Get-Process | Group-Object -AsHash Id
        PS > $processes[1216]

You might encounter problems if some property values are null (not supported in hashtables in the .NET framework) or the data in the hashtables does not have the data type you expect. For these cases, Group-Object provides parameter -AsString to convert all the parameter values to their string equivalent.

        PS > $result = dir | Group-Object -AsHash -AsString Length
        PS > $result["746"]

### Work with each item in a list

cmdlet: `Foreach-Object { OPERATION }`
Aliases: foreach, %

This cmdlet runs the script block for each item in the input.
In the script block, the current input object is represented by variable `$_` or `$PSItem`.

You can specify script blocks to be run at the beginning and end of the pipeline with parameters `-Begin` and `-End`. See example 1.

Starting in PS 3.0, you can also use [operation statements] (https://technet.microsoft.com/en-us/library/hh849731.aspx) without using a script block (see examples 2-3).

Example:

1. Use Foreach-Object with -Begin and -End:

        $myArray = 1,2,3,4,5
        $myArray | Foreach-Object -Begin {
        $sum = 0 } -Process { $sum += $_ } -End { $sum }

2. Use Foreach-Object with a script block:

        Get-Process | Foreach-Object { $_.Name }

3. The same example, without a script block:

        Get-Process | Foreach-Object Name
