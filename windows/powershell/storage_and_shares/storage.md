## Managing storage with PowerShell

### Managing NTFS File Permissions

#### Editing permissions on a file

```
$acl = Get-Acl M:\Sales\goals.xls
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule "joe.smith","FullControl","Allow"
$acl.SetAccessRule($ace)
$acl | Set-Acl M:\Sales\goals.xls
```

- Read the permissions (Access Control List) for the file and save them into a variable called $acl
- Create new FileSystemAccessRule (Access Control Entry) for the new user with the appropriate permissions
- Append the permissions (ACE) to the ACL
- Apply the permissions to the file

#### Cloning permissions for a new folder

```
New-Item M:\Marketing2 -ItemType Directory
$SrcAcl = Get-Acl M:\Marketing
Set-Acl -Path M:\Marketing2 $SrcAcl
```

- Create the new folder
- Get the permissions from an existing folder
- Set the permissions on the new folder  
  This overwrites all existing permissions, leaving only the copied permissions

#### Taking ownership and reassigning permissions

```
$folder = "M:\Groups\Projections"
takeown /f $folder /a /r /d Y
$acl = Get-Acl $folder
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule "joe.smith","FullControl","Allow"
$acl.SetAccessRule($ace)
Set-Acl $folder $acl
Get-ChildItem $folder -Recurse -Force |ForEach {
Get-Acl $acl | Set-Acl -Path $_.FullName
}
```

- Take ownership of the folder  
  - takeown is not a PS command
  - This step is only required if the previous user was the only one with access to the file (no access for administrators)
- Add permission for another person (append new ACE to ACL)
- Recursively overwrite permissions on the folder (applying the new ACL to each item)

#### Enabling and disabling inheritance

```
$acl = Get-Acl M:\Groups\Imaging
## Enabling/Disabling inheritance
#first option is to disable inheritance - true=disable
#second option is to keep inherited permissions - false=discard
$acl.SetAccessRuleProtection($True, $False)
Set-Acl M:\Groups\Imaging $acl
```

- Gather the current permissions
- Enable or disable inheritance  
  - SetAccessRuleProtection takes 2 arguments: the first to enable or disable inheritance, and the second to keep or discard inherited permissions.
  - In this example, the result is to discard all inherited permissions and keep only the permissions applied directly to the file
- Apply the permissions to the folder


### Managing NTFS alternate streams

Alternate streams = tagging applied by Windows to track the origin of files (and decide what additional security to apply to them).
For files downloaded from the Internet, Windows applies additional security. To access the files normally, you have to **unblock** them.
This is the process that affects the execution policy RemoteSigned, for instance.

#### View the file and stream information on the downloaded files

Suppose you have downloaded a file from the internet named WMF 3 Release Notes.docx (downloaded to the default Downloads folder).

```
Get-Item C:\Users\Ed\Downloads\*.* -Stream *
Get-Content 'C:\Users\Ed\Downloads\WMF 3 Release Notes.docx:Zone.Identifier'
Unblock-File 'C:\Users\Ed\Downloads\WMF 3 Release Notes.docx'
```

- The -Stream switch applied with Get-Item returns both the files and all streams attached to the files.  
  - The :$DATA stream is the content of the file itself.
  - The Zone.Identifier stream identifies where the file originated.
- Get-Content: referencing the filename, followed by a colon (':') and Zone.Identifier returns the contents of the zone identifier stream.  
  - The alternate stream is actually a hidden text file in the filesystem.
  - Zone ID: a code denoting the origin of a file (3 = Internet)  
- Unblock-File removes the alternate stream from the file. Only the :$DATA stream remains and Windows now trusts the file.  
  In the GUI, this can be done by pressing the 'Unblock' button in the File Properties dialog.


List of Zone IDs:

- NoZone = -1
- MyComputer = 0
- Intranet = 1
- Trusted = 2
- Internet = 3
- Untrusted = 4

You can create your own alternate streams by creating a filename.
