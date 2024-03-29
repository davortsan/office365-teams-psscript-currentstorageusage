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

        $data.Title+';'+$data.StorageUsageCurrent
    }
}

Disconnect-MicrosoftTeams
Disconnect-ExchangeOnline
Disconnect-SPOService
