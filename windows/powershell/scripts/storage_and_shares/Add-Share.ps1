##############################################################################
##
## Add-Share
##
## From Packt Publishing Windows Server 2012 Automation Cookbook
##
##############################################################################

<#

.SYNOPSIS

This script creates a new share and configures share permissions.

#>


#Create share directory
New-Item -Path E:\Share2 -ItemType Directory

#Create share and configure share permissions
New-SmbShare -Name Share2 -Path E:\share2 -ReadAccess Everyone -FullAccess Administrator -Description "Test share"
