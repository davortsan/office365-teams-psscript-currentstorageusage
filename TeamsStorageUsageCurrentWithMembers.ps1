﻿Import-Module MicrosoftTeams
Import-Module ExchangeOnlineManagement
Import-Module Microsoft.Online.SharePoint.PowerShell

$AdminSiteURL = "https://<tenant_name>-admin.sharepoint.com"

$cred = Get-Credential

Connect-MicrosoftTeams -Credential $cred
Connect-ExchangeOnline -Credential $cred
Connect-SPOService -Url $AdminSiteURL -Credential $cred

$Teams = Get-Team | select GroupId

foreach ($actual in $Teams)
{
    $SPOSite = Get-Unifiedgroup -Identity $actual.GroupId | Select SharePointSiteurl

    if ($SPOSite.SharePointSiteUrl -ne $null)
    { 
        $data = Get-SPOSite $SPOSite.SharePointSiteUrl | select Title, StorageUsageCurrent
    }

    $TeamUsers = Get-TeamUser -GroupId $actual.GroupId | select user

    foreach ($user in $TeamUsers)
    {
        $line = $data.Title+';'+ $data.StorageUsageCurrent+';'+$user.user.Split('@')[0]

        Add-Content -Path "C:\temp\TeamsUsageWithMembers.txt" $line
    }
}

Disconnect-MicrosoftTeams
Disconnect-ExchangeOnline
Disconnect-SPOService
