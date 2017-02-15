#-------------------------------------------------------------------- 
# Name: Load CSV into SharePoint List 
# NOTE: No warranty is expressed or implied by this code – use it at your 
# own risk. If it doesn't work or breaks anything you are on your own 
#--------------------------------------------------------------------


# Setup the correct modules for SharePoint Manipulation 
if ( (Get-PSSnapin -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null ) 
{ 
   Add-PsSnapin Microsoft.SharePoint.PowerShell 
} 
$host.Runspace.ThreadOptions = "ReuseThread"

#Open SharePoint List 
$SPServer= http://LAB-SPS1
$SPAppList="/Informer/ProductionVMs" 
$spWeb = Get-SPWeb $SPServer 
$spData = $spWeb.GetList($SPAppList)

$InvFile="appinvent.csv" 
# Get Data from Inventory CSV File 
$FileExists = (Test-Path $InvFile -PathType Leaf) 
if ($FileExists) { 
   "Loading $InvFile for processing..." 
   $tblData = Import-CSV $InvFile 
} else { 
   "$InvFile not found - stopping import!" 
   exit 
}

# Loop through Applications add each one to SharePoint

"Uploading data to SharePoint...."

foreach ($row in $tblData) 
{ 
   "Adding entry for "+$row."Application Name".ToString() 
   $spItem = $spData.AddItem() 
   $spItem["Application Name"] = $row."Application Name".ToString() 
   $spItem["Application Vendor"] = $row."Application Vendor".ToString() 
   $spItem["Application Version"] = $row."Application Version".ToString() 
   $spItem["Install Count"] = $row."Install Count".ToString() 
   $spItem.Update() 
}

"---------------" 
"Upload Complete"

$spWeb.Dispose()