## Managing Network Shares with PowerShell

Uit: Windows Server 2012 Automation with PowerShell Cookbook (Ed Goad, Packt Publishing 2013) - Hoofdstuk 6

Prerequisites: none (no installation/configuration of services required)  
  Window Server automatically includes the necessary features to enable file sharing over CIFS (=SMB).

### Creating and securing SMB shares

#### Creating a share

cmdlet: New-SmbShare

        New-Item -Path E:\Share2 -ItemType Directory
        New-SmbShare -Name Share2 -Path E:\share2 -ReadAccess Everyone -FullAccess Administrator -Description "Test share"

1. Create the folder that will be shared (if it doesn't exist)
2. Create the share for this folder
  - Name and Path are mandatory, can be supplied as positional parameters
  - default value for ReadAccess: Everyone
  - Description (optional): seen by users when browsing shares
  - parameters that concern access rights: ReadAccess, FullAccess, ChangeAccess, NoAccess

#### Granting or revoking access to an existing share

cmdlets: Grant-SmbShareAccess, Block-SmbShareAccess, Unblock-SmbShareAccess

        Grant-SmbShareAccess -Name Share1 -AccountName CORP\Joe.Smith -AccessRight Full -Confirm:$false

- Mandatory: share -Name (may be positional) or -InputObject <CimInstance[]>
- AccessRight: Full, Modify, Read
- Block-SmbShareAccess = 'explicit deny': access list will show AccessControlType 'Deny'

#### Getting share information

`Get-SmbShare`: view current shares (name, path, description)
`Get-SmbShare | Get-SmbShareAccess`: view current share permissions (AccountName, AccessControlType, AccessRight)

### Accessing and mapping SMB shares

cmdlets: Get-ChildItem, New-PSDrive

        Get-ChildItem \\server1\share2
        New-PSDrive -Name S -Root \\server1\share1 -Persist -PSProvider FileSystem

        $secPass = ConvertTo-SecureString 'P@$$w0rd11' -AsPlainText –Force
        $myCred = New-Object -TypeName PSCredential `
        -ArgumentList "CORP\Administrator",$secPass
        New-PSDrive -Name S -Root \\server1\share1 -Persist `
        -PSProvider FileSystem -Credential $myCred

- Get-ChildItem: view share contents
- New-PSDrive: mapping a persisent share  
  - By default, a share is mapped to the current user session
  - Name: drive letter
  - Persist: re-establish connection on next login
- Mapping a share using alternative credentials  
  1. Convert password to secure string
  2. Create a PSCredential object that holds account name and secured password
  3. Map the drive, supplying the credential object as the Credential argument
