##############################################################################
##
## New-DfsrHierarchy
##
## From Packt Publishing Windows Server 2012 Automation Cookbook
##
##############################################################################

<#

.SYNOPSIS

This script creates a DFSR hierarchy, including defining DFS root on server, creating shares,
and configuring DFS replication. 

#>

#Create the shares for the DFS root on both servers simultaneously

  Invoke-Command -ComputerName FS1, FS2 -ScriptBlock{
  New-Item C:\Shares\Public -ItemType Directory
  New-SmbShare -Name Public -Path C:\Shares\Public -FullAccess Everyone
  }

#Create the DFS root on each server

  New-DfsnRoot -TargetPath \\FS1\Public -Type DomainV2
  New-DfsnRootTarget -TargetPath \\FS2\Public


#Create the shares for Marketing and Sales on both servers simultaneously

  Invoke-Command -ComputerName FS1, FS2 -ScriptBlock{
  New-Item C:\Shares\Marketing -ItemType Directory
  New-Item C:\Shares\Sales -ItemType Directory
  New-SmbShare -Name Marketing -Path C:\Shares\Marketing -FullAccess Everyone
  New-SmbShare -Name Sales -Path C:\Shares\Sales -FullAccess Everyone
  }

#Add the new shares to the DFS root on each server

  New-DfsnFolder -Path \\corp\Public\Marketing -TargetPath \\FS1\Marketing
  New-DfsnFolder -Path \\corp\Public\Sales -TargetPath \\FS1\Sales
  New-DfsnFolderTarget -Path \\corp\Public\Marketing -TargetPath \\FS2\Marketing
  New-DfsnFolderTarget -Path \\corp\Public\Sales -TargetPath \\FS2\Sales

#Create a DFSR replication group

    DfsrAdmin RG New /RgName:Public /Domain:corp.contoso.com

#Add the file servers to the replication group:

    DfsrAdmin Mem New /RgName:Public /MemName:FS1 /Domain:corp.contoso.com
    DfsrAdmin Mem New /RgName:Public /MemName:FS2 /Domain:corp.contoso.com

#Create replication folders:

    DfsrAdmin Rf New /RgName:Public /RfName:Marketing /RfDfspath:\\corp.contoso.com\Public\Marketing /force
    DfsrAdmin Rf New /RgName:Public /RfName:Sales /RfDfspath:\\corp.contoso.com\Public\Sales /force

#Configure the replication folder paths:

    DfsrAdmin Membership Set /RgName:Public /RfName:Marketing /MemName:FS1 /LocalPath:C:\Shares\Marketing /MembershipEnabled:true /IsPrimary:true /force
    DfsrAdmin Membership Set /RgName:Public /RfName:Marketing /MemName:FS2 /LocalPath:C:\Shares\Marketing /MembershipEnabled:true /IsPrimary:false /force
    DfsrAdmin Membership Set /RgName:Public /RfName:Sales /MemName:FS1 /LocalPath:C:\Shares\Sales /MembershipEnabled:true /IsPrimary:true /force
    DfsrAdmin Membership Set /RgName:Public /RfName:Sales /MemName:FS2 /LocalPath:C:\Shares\Sales /MembershipEnabled:true /IsPrimary:false /force


#Create connections between the servers:

    DfsrAdmin Conn New /RgName:Public /SendMem:corp\FS1 /Recvmem:corp\FS2 /ConnEnabled:true
    DfsrAdmin Conn New /RgName:Public /SendMem:corp\FS2 /Recvmem:corp\FS1 /ConnEnabled:true
