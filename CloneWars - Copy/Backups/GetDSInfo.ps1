$Today = (Get-Date -Format "yyyyMMdd-HH.mm")

$defaultVIServers = "vc2.ad.mmu.ac.uk"

#,"drvc.ad.mmu.ac.uk"

$vcenterServer = $defaultVIServers

# PowerCLI Header
Write-host "Loading PowerCLI" -ForeGroundColor Red
$VMwareLoaded = $(Get-PSSnapin | ? {$_.Name -like "*VMware*"} ) -ne $null
If ($VMwareLoaded) { }
Else
{
Add-PSSnapin -Name "VMware.VimAutomation.Core" | Out-Null
}

# Connect vCenter Server
Write-host "Connecting vCenter" -ForeGroundColor Yellow
Connect-VIserver -server $vCenterServer | Out-Null

$report = Get-Datacenter | Get-Datastore | Foreach-Object {
    $ds = $_.Name
    $_ | Get-VM | Select-Object Name,@{n='DataStore';e={$ds}} 
    }

$report | Export-Csv "H:\DS.stats.$vcenter.$today.csv" -NoTypeInformation -UseCulture