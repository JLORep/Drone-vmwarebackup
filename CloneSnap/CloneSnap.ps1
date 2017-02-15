#################################################
# Name: Scheduled Snap & Merge [CloneSnap.ps1]  #
# Desc: Snaps / Merges List of VMS  to schedule #
#################################################
#                                               #
# *Reads CSV                                    #
# *Gets VMs Home Datastore					    #						
# *Performs Snapshot to schedule 			    #
# *Waits Preagreed Window	                    #
# *Merges Snapshot with VM 					    #
# *Writes To Log							    #
# *Recurses through CSV						    #
# *Sends Email with Log to SS when complete 	#
#                                               #
#################################################
# Date: 27/08/2015                              #
# Auth: jameseymail@hotmail.co.uk               #
#################################################

#VCentre DNS Name
$VCDNS ="DRVC.ad.mmu.ac.uk"

#Clear Screen
clear-host

# Load PowerCLI Snapin & Print Header
Write-host "Loading PowerCLI" -ForeGroundColor Blue
$VMwareLoaded = $(Get-PSSnapin | ? {$_.Name -like "*VMware*"} ) -ne $null
If ($VMwareLoaded) { }
Else
{
Add-PSSnapin -Name "VMware.VimAutomation.Core" | Out-Null
}

# Connect to CLI VCenter
Connect-VIserver -server $VCDNS

# Import CSV of VMs to be "Snapped"
$FullVMList = @(Import-CSV C:\CloneSnap\snaps.csv)

# Performing Snapshot
Foreach($machine in $FullVMList){

# Recurse through CSV to obtain SourceVM Variable
$SourceVM = Get-VM $machine.MasterVM

# Get Target Datastore 
$TargetDS = Get-Datastore -VM $SourceVM

# Check VM Parameter if no VM is specified then the script ends here.
If (($SourceVM -eq $Null ) -or ($TargetDS -eq $Null)) {
Write-Host "Error: SourceVM Not Found - Please try again"
Write-Host "Error: DataStore Not Found Please try again" -ForeGroundColor White
Exit }

#Functions to check whether a VM or DS Exists
function ExistVM([string] $VMName) {
Get-VM | Foreach-Object {$FullVMList += $_.Name}

if ( $FullVMList.Contains( $VMName ) ) {
$true
} else {
$false
}
}

function ExistDS([string] $DSName) {
Get-DataStore | Foreach-Object { $FullDSList += $_.Name }

if ( $FullDSList.Contains( $DSName ) ) {
$true
} else {
$false
}
}

# vCenter Server
$vCenterServer="vc2.ad.mmu.ac.uk"

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

# Lets Rock [Snapshot -> Clone -> Timestamp -> Delete]
if ( ExistVM( $SourceVM ) -and ExistDS( $TargetDS ) ) 
{
$timestart = @(Get-Date -f "HH:MM") 
$VM = Get-VM $SourceVM

Write-Host -foregroundcolor Green " + Creating SnapShot " $SourceVM
$CloneSnap = $VM | New-SnapShot -Name "$CloneDate-$SourceVM-CloneSnapShot"
$VMView = $VM | Get-View
}
#################
# Email Results #
#################

#Set Date format for emails
#$timecomplete = (Get-Date -f "HH:MM")
#$emailFrom = "j.lockwood@mmu.ac.uk"
#$emailTo = "ss@mmu.ac.uk"
#$subject = "[$vm - Snapshot Complete]"
#$body = "Snapshot details"
#-------------
#VM Name:",$SourceVM,"
#Name:",$CloneName,"
#Time Started:", $timestart,"
#Time Completed:", $timecomplete
#$FullVMList
#$smtpServer = "outlook.mmu.ac.uk"
#$smtp = new-object Net.Mail.SmtpClient($smtpServer)
#$smtp.Send($emailFrom,$emailTo,$subject,$body)

#Write Results to Log File (Append)""

#VM:" + $SourceVM + "," + "DS:" + $TargetDS + "," + "OVAName:" + $OVAName + "," + "ExportLocation:" + $ExportLoc + "," + "TimeComplete:" + $timecomplete + "," + "TimeStarted:" + $timestart | out-file -filepath c:\clonewars\log.txt -append -width 200

#Disconnect from vCentre
#Write-host "Closing vCenter session " -ForeGroundColor Yellow
#Disconnect-VIServer $VCDNS -Confirm:$false
}