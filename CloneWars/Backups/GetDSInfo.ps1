$Today = (Get-Date -Format "yyyyMMdd-HH.mm")

$defaultVIServers = "vc2.ad.mmu.ac.uk"

#"drvc.ad.mmu.ac.uk"

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
	
# Export CSV, removing quotations
$report | ConvertTo-Csv -NoTypeInformation | %{ $_ -replace '"', ""} | out-file "H:\DS.stats.$vcenter.$today.csv"

# Pauses at the end for debug purposes
Function Pause($M="Press any key to continue . . . "){If($psISE){$S=New-Object -ComObject "WScript.Shell";$B=$S.Popup("Click OK to continue.",0,"Script Paused",0);Return};Write-Host -NoNewline $M;$I=16,17,18,20,91,92,93,144,145,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183;While($K.VirtualKeyCode -Eq $Null -Or $I -Contains $K.VirtualKeyCode){$K=$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")};Write-Host}
