﻿$ScriptBlock = {Set-SharingPolicy -Identity "Default Sharing Policy" -Domains "Anonymous: CalendarSharingFreeBusySimple"}
$ScriptBlock2 = {Enable-OrganizationCustomization}

# Establish a PowerShell session with Office 365. You'll be prompted for your Delegated Admin credentials
 
$Cred = Get-Credential
Connect-MsolService -Credential $Cred
$customers = Get-MsolPartnerContract -All
Write-Host "Found $($customers.Count) customers for this Partner."
 
foreach ($customer in $customers) {


    $InitialDomain = Get-MsolDomain -TenantId $customer.TenantId | Where-Object {$_.IsInitial -eq $true}
    Write-Host "Enabling External Calendar Sharing Policy for $($Customer.Name)"
    $DelegatedOrgURL = "https://ps.outlook.com/powershell-liveid?DelegatedOrg=" + $InitialDomain.Name
    Invoke-Command -ConnectionUri $DelegatedOrgURL -Credential $Cred -Authentication Basic -ConfigurationName Microsoft.Exchange -AllowRedirection -Scriptblock $ScriptBlock2 -HideComputerName
    Invoke-Command -ConnectionUri $DelegatedOrgURL -Credential $Cred -Authentication Basic -ConfigurationName Microsoft.Exchange -AllowRedirection -ScriptBlock $ScriptBlock -HideComputerName
}