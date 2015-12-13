## Managing Network Shares with PowerShell

Uit: Windows Server 2012 Automation with PowerShell Cookbook (Ed Goad, Packt Publishing 2013) - Hoofdstuk 6

Prerequisites: none (no installation/configuration of services required)  
  Window Server automatically includes the necessary features to enable file sharing over CIFS (=SMB).

### Creating and securing SMB shares

#### Creating a share

cmdlet: New-SmbShare

```
New-Item -Path E:\Share2 -ItemType Directory
New-SmbShare -Name Share2 -Path E:\share2 -ReadAccess Everyone -FullAccess Administrator -Description "Test share"
```

1. Create the folder that will be shared (if it doesn't exist)
2. Create the share for this folder
  - Name and Path are mandatory, can be supplied as positional parameters
  - default value for ReadAccess: Everyone
  - Description (optional): seen by users when browsing shares
  - parameters that concern access rights: ReadAccess, FullAccess, ChangeAccess, NoAccess

#### Granting or revoking access to an existing share

cmdlets: Grant-SmbShareAccess, Block-SmbShareAccess, Unblock-SmbShareAccess

```
Grant-SmbShareAccess -Name Share1 -AccountName CORP\Joe.Smith -AccessRight Full -Confirm:$false
```

- Mandatory: share -Name (may be positional) or -InputObject <CimInstance[]>
- AccessRight: Full, Modify, Read
- Block-SmbShareAccess = 'explicit deny': access list will show AccessControlType 'Deny'

#### Getting share information

`Get-SmbShare`: view current shares (name, path, description)

`Get-SmbShare | Get-SmbShareAccess`: view current share permissions (AccountName, AccessControlType, AccessRight)

#### Accessing and mapping SMB shares

cmdlets: Get-ChildItem, New-PSDrive

```
Get-ChildItem \\server1\share2
New-PSDrive -Name S -Root \\server1\share1 -Persist -PSProvider FileSystem
```

- Get-ChildItem: view share contents
- New-PSDrive: mapping a persisent share  
  - By default, a share is mapped to the current user session
  - Name: drive letter
  - Persist: re-establish connection on next login

```
$secPass = ConvertTo-SecureString 'P@$$w0rd11' -AsPlainText –Force
$myCred = New-Object -TypeName PSCredential `
-ArgumentList "CORP\Administrator",$secPass
New-PSDrive -Name S -Root \\server1\share1 -Persist `
-PSProvider FileSystem -Credential $myCred
```

- Mapping a share using alternative credentials  
  1. Convert password to secure string
  2. Create a PSCredential object that holds account name and secured password
  3. Map the drive, supplying the credential object as the Credential argument


### iSCSI virtual disks

Internet Small Computer System Interface, or iSCSI, is a storage technology that uses TCP/IP to link storage with computers.

A basic iSCSI connection consists of an iSCSI target and an iSCSI initiator. The target contains the storage resources that are presented to clients.
The initiator is the iSCSI client that accesses data on the remote target.
Unlike SMB/CIFS shares, which share files and objects, iSCSI presents disks from a block level. The virtual disk created on the server will be presented to the user as an internal disk, i.e. it has to be formatted to create a file system on it, the client is in charge of permissions,... iSCSI is typically intended for one host at a time to connect to the iSCSI target.

#### Setting up an iSCSI target

```
Install-WindowsFeature -Name FS-iSCSITarget-Server
New-iSCSIServerTarget -Targetname ContosoServers -InitiatorID IPAddress:10.10.10.10
New-iSCSIVirtualDisk "E:\iSCSIVirtualDisks\Drive1.vhd" -Size 20GB
Add-iSCSIVirtualDiskTargetMapping -Targetname ContosoServers –DevicePath "E:\iSCSIVirtualDisks\Drive1.vhd"
```

1. Install the iSCSI target feature
2. Identify iSCSI initiators that are allowed access
  - TargetName: creates a new client group
  - InitiatorID: one or more clients that will be able to see the resources  
      InitiatorID can be specified as an IP address, a DNS name, an interface MAC address or an iSCSI Qualified Name (IQN)
3. Create a new iSCSI virtual disk (vhd file)
4. Map the virtual disk to the iSCSI initiators  
  When an initiator in the TargetName client group queries the iSCSI target for available resources, the disk in DevicePath will be presented

#### Reviewing iSCSI mappings

`Get-IscsiServerTarget | Select-Object TargetName, Status, InitiatorIds, LunMappings`

- Returns target groups, connectivity status, initiator addresses and presented disks.

#### Setting up an iSCSI initiator

```
Start-Service MSiSCSI
Set-Service MSiSCSI -StartupType Automatic
New-IscsiTargetPortal -TargetPortalAddress 10.10.10.100
$tar = Get-IscsiTarget
Connect-IscsiTarget -NodeAddress $tar.NodeAddress
```

0. iSCSI initiator functionality is pre-installed, but set to manual startup
1. Start the iSCSI initiator and set it to start up automatically
2. Connect to the iSCSI portal  
  This command adds the address of the portal to the list of addresses to be used in the future.
3. Identify the available targets  
  This command queries the portal for available targets.
4. Connect to the target  
  All the resources available to the client will now be presented on the local system. If this is the first time the client is connecting, the drive will appear as an unformatted drive (Computer Management).

#### Review the connection information

`Get-IscsiSession`


#### Configuring and using iSNS

The Internet Storage Name Service (iSNS) is a central directory of iSCSI targets and iSCSI
initiators. Similar to the idea of a DNS, clients and servers register to the iSNS server, and
then perform a lookup for resources available on the network.  
You may configure multiple Discovery Domains on the iSNS server (to segment large iSCSI environments). Both targets and initiators may be members of multiple domains.

Prerequisites: an iSCSI disk has already been created on the target computer and exported to the initiator. However, no configuration has occurred on the initiator.

1. Install the iSNS server  
  The feature also includes a tool for managing the iSNS zones (Server Manager > Tools > iSNS Server or `isnsui.exe`)

  ```
  Add-WindowsFeature iSNS
  ```

2. (On targets) Configure the iSCSI targets to register with the iSNS server  
  The command accesses WMI on the server and adds an instance in WMI class `WT_iSNSServer`

  ```
  Set-WmiInstance -Namespace root\wmi -Class WT_iSNSServer -Arguments @{ServerName="corpdc1.corp.contoso.com"}
  ```

3. (On initiators) Configure iSCSI initiators to register with the iSNS server (similar to step 2)  

  ```
  Set-WmiInstance -Namespace root\wmi -Class MSiSCSIInitiator_iSNSServerClass -Arguments @{iSNSServerAddress="corpdc1.corp.contoso.com"}
  ```

4. (On initiators) Discover and register the targets
  Get-IscsiTarget is now executed against the iSNS server, and may return multiple targets. The script cycles through the nodes and attempts to connect to each one.

  ```
  Start-Service MSiSCSI
  Set-Service MSiSCSI -StartupType Automatic
  $tar = Get-IscsiTarget
  $tar | ForEach-Object{ Connect-IscsiTarget -NodeAddress $_.NodeAddress -IsPersistent $true }
  ```


### Making CIFS shares highly available: combining iSCSI and Cluster Shared Volumes

Prior to Windows Server 2012, the only solutions for making file servers redundant was to
use Clustering Services. In that case, if the primary server went offline, the backup server
would take ownership of the cluster resources. This active/passive configuration provided
redundancy during a failure, but forced the connections to be reestablished and caused
issues with some applications.  
In Windows Server 2012, we can now use Cluster Shared Volumes (CSV) to present highly
available file shares. This allows us to present a file share in an active/active configuration with multiple servers
providing the file share.

An iSCSI server will host the source drive. Two file servers will attach to the same virtual disk and present the clustered share to clients.

#### Set up iSCSI on the backend server

```
Install-WindowsFeature -Name FS-iSCSITarget-Server, iSCSITarget-VSS-VDS
New-iSCSIServerTarget -Targetname "FSCluster" -InitiatorID "IPAddress:10.10.10.103","IPAddress:10.10.10.104"
New-Item e:\iSCSIVirtualDisks -ItemType Directory
New-iSCSIVirtualDisk "e:\iSCSIVirtualDisks\Drive1.vhd" -Size 20GB
Add-iSCSIVirtualDiskTargetMapping -Targetname "FSCluster" –DevicePath "e:\iSCSIVirtualDisks\Drive1.vhd"
```

- We create target group FSCluster with the addresses of the file servers that will be presenting the share.
- We create a directory on the physical disk that will be holding our virtual disk, and we create the virtual disk inside it.
- We create a target mapping, mapping the disk to the cluster

#### Set up iSCSI clients on the file servers

```
Invoke-Command -ComputerName FS1, FS2 -ScriptBlock{
  Install-WindowsFeature -Name Failover-Clustering -IncludeManagementTools
  Start-Service MSiSCSI
  Set-Service MSiSCSI -StartupType Automatic
  New-IscsiTargetPortal -TargetPortalAddress 10.10.10.102
  $tar = Get-IscsiTarget
  Connect-IscsiTarget -NodeAddress $tar.NodeAddress
}
```

- We install `Failover-Clustering` on the file servers that will be clustering the shares.
- We start the iSCSI initiator service and register the iSCSI target server.
- We connect both servers to the iSCSI target.

#### Create the failover cluster

```
New-Cluster -Name FSCluster -Node "FS1","FS2" -StaticAddress 10.10.10.106
Get-Cluster FSCluster | Add-ClusterScaleOutFileServerRole -name CIFS1
Get-Cluster FSCluster | Test-Cluster
Get-Cluster FSCluster | Get-ClusterAvailableDisk
Get-Cluster FSCluster | Get-ClusterAvailableDisk | Add-ClusterDisk
Get-Cluster FSCluster | Add-ClusterSharedVolume -Name "Cluster Disk 1"
```
- We create the cluster and assign it a static IP.
- Adding server role Scale Out File Server to the cluster enables the servers to use Cluster Shared Volumes across the nodes.
- Test-Cluster performs validation tests on the cluster. Some errors are to be expected, but confirm that the CSV tests completed successfully.
- Get-ClusterAvailableDisk returns the disks available for clustering (if no disks are returned, something is wrong with the iSCSI or cluster configuration).
- Add-ClusterDisk adds the available disks into the cluster.
- Add-ClusterSharedVolume adds the disk as a CSV resource and mounts it (under C:\ClusterStorage\Volume1).

#### Create the clustered share

```
Invoke-Command -ComputerName FS1 -ScriptBlock{
  New-Item "C:\ClusterStorage\Volume1\Share1" -ItemType Directory
  New-SmbShare -Name Share1 -Path "C:\ClusterStorage\Volume1\Share1"
}
```

- We create a share on one of the file servers (see [Creating and securing SMB shares](#creating-and-securing-smb-shares)), this share is automatically included as a cluster resource.


### Creating and mounting NFS exports

Network File System, or NFS, is file sharing technology that is very common in Unix/Linux
environments. Microsoft has expanded share security in NFS to include Kerberos authentication.
For Unix/Linux environments, basic share access was traditionally based on IP addressing; file
level security was then used to further restrict access. NFS exports in Windows can still utilize IP-based security. This is useful
when working in heterogeneous environments with non-Windows systems.

#### Creating an NFS export with Kerberos authentication

Prerequisites: a basic AD environment for authentication.

```
Add-WindowsFeature FS-NFS-Service –IncludeManagementTools
New-Item C:\shares\NFS1 -ItemType Directory
New-NfsShare -Name NFS1 -Path C:\shares\NFS1
Grant-NfsSharePermission -Name NFS1 -ClientName Server1 -ClientType host -Permission readwrite -AllowRootAccess $true
```

1. Install the NFS server service  
  The install includes the administration tool Nfsadmin.
2. Create a new NFS share  
  - New-NfsShare requires a Name and a share path
  - Optionally, the authentication type (Kerberos, IP-based, anonymous) can be provided using option -Authentication
3. Grant access to a remote computer  
  - The default access rule is for all machines to be denied access
  - To grant access, we add the machine or network group and the appropriate type of access.

#### Reviewing NFS shares and share permissions

`Get-NfsShare -Name NFS1 | Format-List` (includes authentication type information)

`Get-NfsSharePermission -Name NFS1`

#### Mounting NFS exports

Prerequisites: the NFS export and AD environment as configured for [Creating an NFS export with Kerberos authentication](#creating-an-nfs-export-with-kerberos-authentication)

```
Install-WindowsFeature NFS-Client
New-PSDrive N -PSProvider FileSystem -Root \\corpdc1\NFS1
```

1. Install the NFS client
2. Mount the NFS share using the \\server\share naming scheme

In addition to the PowerShell commands, there is a built-in tool, C:\Windows\System32\Mount.exe, that can also be used to connect and manage NFS drives.

### Configuring DFS and DFSR replication

Distributed File System (DFS) and Distributed File System Replication (DFSR) allow for information to be replicated and accessed using a common namespace.
The most common usage of these technologies is Windows Active Directory, which stores and replicates user information among domain controllers.

#### Create a DFSR hierarchy

1. Create the shares for the DFS root on both servers simultaneously

  ```
  Invoke-Command -ComputerName FS1, FS2 -ScriptBlock{
  New-Item C:\Shares\Public -ItemType Directory
  New-SmbShare -Name Public -Path C:\Shares\Public -FullAccess Everyone
  }
  ```

2. Create the DFS root on each server

  ```
  New-DfsnRoot -TargetPath \\FS1\Public -Type DomainV2
  New-DfsnRootTarget -TargetPath \\FS2\Public
  ```

  - The domain DFS root type is more flexible and allows for replication and other location-aware features.

3. Create the shares for Marketing and Sales on both servers simultaneously

  ```
  Invoke-Command -ComputerName FS1, FS2 -ScriptBlock{
  New-Item C:\Shares\Marketing -ItemType Directory
  New-Item C:\Shares\Sales -ItemType Directory
  New-SmbShare -Name Marketing -Path C:\Shares\Marketing -FullAccess Everyone
  New-SmbShare -Name Sales -Path C:\Shares\Sales -FullAccess Everyone
  }
  ```

4. Add the new shares to the DFS root on each server

  ```
  New-DfsnFolder -Path \\corp\Public\Marketing -TargetPath \\FS1\Marketing
  New-DfsnFolder -Path \\corp\Public\Sales -TargetPath \\FS1\Sales
  New-DfsnFolderTarget -Path \\corp\Public\Marketing -TargetPath \\FS2\Marketing
  New-DfsnFolderTarget -Path \\corp\Public\Sales -TargetPath \\FS2\Sales
  ```

  - Note: It is possible to create folders directly inside the DFS root. This type of configuration limits the scalability and functions of DFS. Instead, it is best practice to create additional file shares and add them to the DFS tree.

#### Create replication policies

To manage replication we use the DfsrAdmin.exe tool found in the Windows directory. DfsrAdmin includes built-in help that can be viewed by calling `DfsrAdmin.exe /?`

5. Create a DFSR replication group

  ```
  DfsrAdmin RG New /RgName:Public /Domain:corp.contoso.com
  ```

  - A replication group is used to contain the servers, shares, and replication policies.

6. Add the file servers to the replication group:

  ```
  DfsrAdmin Mem New /RgName:Public /MemName:FS1 /Domain:corp.contoso.com
  DfsrAdmin Mem New /RgName:Public /MemName:FS2 /Domain:corp.contoso.com
  ```

7. Create replication folders:

  ```
  DfsrAdmin Rf New /RgName:Public /RfName:Marketing /RfDfspath:\\corp.contoso.com\Public\Marketing /force
  DfsrAdmin Rf New /RgName:Public /RfName:Sales /RfDfspath:\\corp.contoso.com\Public\Sales /force
  ```

8. Configure the replication folder paths:

  ```
  DfsrAdmin Membership Set /RgName:Public /RfName:Marketing /MemName:FS1 /LocalPath:C:\Shares\Marketing /MembershipEnabled:true /IsPrimary:true /force
  DfsrAdmin Membership Set /RgName:Public /RfName:Marketing /MemName:FS2 /LocalPath:C:\Shares\Marketing /MembershipEnabled:true /IsPrimary:false /force
  DfsrAdmin Membership Set /RgName:Public /RfName:Sales /MemName:FS1 /LocalPath:C:\Shares\Sales /MembershipEnabled:true /IsPrimary:true /force
  DfsrAdmin Membership Set /RgName:Public /RfName:Sales /MemName:FS2 /LocalPath:C:\Shares\Sales /MembershipEnabled:true /IsPrimary:false /force
  ```

  - This configures the replication folder with the local folder on the file server.
  - The /IsPrimary:true switch configures FS1 as the primary source of information for both shares.

9. Create connections between the servers:

  ```
  DfsrAdmin Conn New /RgName:Public /SendMem:corp\FS1 /Recvmem:corp\FS2 /ConnEnabled:true
  DfsrAdmin Conn New /RgName:Public /SendMem:corp\FS2 /Recvmem:corp\FS1 /ConnEnabled:true
  ```

  - we create replication connections between the file servers. Here, we create two connections: the first from FS1 to FS2 , and the second from FS2 to FS1

### Configuring BranchCache

BranchCache is a technology designed by Microsoft to ease file and website access in remote branch offices. These sites traditionally utilize slow WAN links, resulting in slow access to centralized services.
Similar to a proxy server, BranchCache intelligently caches information requests across a WAN link.
Once in the cache, subsequent requests are fulfilled by the cache instead of resending the information across the network.

There are two types of BranchCache: file servers and web servers. As the names suggest, BranchCache for file servers caches information accessed from CIFS shares, while BranchCache for web servers caches information accessed from web sites.
Windows clients utilize group policies to define if they should use BranchCache and how to discover the BranchCache resources.

In this recipe, we will be working in an Active Directory environment with two sites: site Corp and site Branch. In the corporate office, there is a file server FS1 , and at the remote office, there is a BranchCache server named BC1 . The two sites are joined by a WAN link.

#### Create and configure the GPO

1. Create a Group Policy (GPO) for the clients in the remote office

  ```
  New-GPO -Name "BranchCache Client"
  ```

2. Add the appropriate registry values to the GPO

  ```
  Set-GPRegistryValue -Name "BranchCache Client" -Key HKLM\SOFTWARE\Policies\Microsoft\PeerDist\Service -Valuename Enable -Value 1 -Type DWord
  Set-GPRegistryValue -Name "BranchCache Client" -Key HKLM\SOFTWARE\Policies\Microsoft\PeerDist\CooperativeCaching -Valuename Enable -Value 1 -Type DWord
  Set-GPRegistryValue -Name "BranchCache Client" -Key HKLM\SOFTWARE\Policies\Microsoft\PeerDist\HostedCache\Discovery -ValueName SCPDiscoveryEnabled -Value 1 -Type DWord
  ```

  - Service: enables the BranchCache server
  - CooperativeCaching: specifies caching type
  - Discovery: enables discovery of the BranchCache servers via DNS

3. Apply GPO to the branch site

  ```
  New-GPLink -Name "BranchCache Client" -Target Branch
  ```

#### Install and configure BranchCache

4. Install BranchCache on all participating systems in the following way

  ```
  Invoke-Command –ComputerName FS1, BC1, Client1 –ScriptBlock {
  Install-WindowsFeature BranchCache, FS-BranchCache
  -IncludeManagementTools
  }
  ```

  - This should be performed on the file and web servers that host the content, the BranchCache server, and the client systems
  - Windows 8 has the BranchCache client installed automatically and it just needs to be enabled.

5. Publish the BranchCache web server

  ```
  Publish-BCWebContent -Path C:\InetPub\WWWRoot
  ```

6. Publish the BranchCache file server

  ```
  Publish-BCFileContent -Path C:\Shares\Sales
  ```

7. Configure the BranchCache host

  ```
  Enable-BCHostedServer –RegisterSCP
  ```

8. Update BranchCache clients

```
GPUpdate /force
Restart-Service peerdistsvc
```

#### Confirm that data is being cached

On the BranchCache server: `Get-BCStatus`
