#*****************************************************************************
#Author: James Lockwood
#Task: OVFExport a VM on a shared location
#*****************************************************************************
# OVFExport.ps1
# -vmName The name of VM that you want to export
# ./OVFExport-v2.ps1 vmName
####################################################################
Param( [string] $VMName)

Connect-VIserver -server "*******.ac.uk" $VMName + "'"

"'vi://AD\\*******:******@******.ac.uk/ITS/vm/" + $VMName + "'"



$SharedSpace = "\\****\vm_repository\Test"
$ovfFile = $Sharedspace + "\" + $VMName + "\" + $VMName + ".ovf"
$ovftoolpath = "\\******\c$\Program Files\VMware\VMware OVF Tool"
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

