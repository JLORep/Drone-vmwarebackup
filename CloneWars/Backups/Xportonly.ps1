#*****************************************************************************
#Author: James Lockwood
#Task: OVFExport a VM on a shared location
#*****************************************************************************
# OVFExport.ps1
# -vmName The name of VM that you want to export
# ./OVFExport-v2.ps1 vmName
####################################################################
Param( [string] $VMName)

Connect-VIserver -server "vc2.ad.mmu.ac.uk" $VMName + "'"

"'vi://AD\\46020944:Pa55work@vc2.mmu.ac.uk/ITS/vm/" + $VMName + "'"



$SharedSpace = "\\ascfiler1\vm_repository\Test"
$ovfFile = $Sharedspace + "\" + $VMName + "\" + $VMName + ".ovf"
$ovftoolpath = "\\informer\c$\Program Files\VMware\VMware OVF Tool"
$ovftool = ''
$arg = " --powerOffSource" + " " + $viserver + " " + $ovfFile
if(test-path $ovftoolpath)
        {
            $ovftool = $ovftoolpath
   Write-host "OVF tool found:" $ovftoolpath
        }

if (!$ovftool)
    {
        write-host -ForegroundColor red "ERROR: OVFtool not found in it's standard path."
 exit
    }
    else
    {
Write-Host $SharedSpace
Write-Host $viserver
Write-Host $ovfFile
Write-Host $arg
Invoke-Expression "$ovftool $arg"
}

