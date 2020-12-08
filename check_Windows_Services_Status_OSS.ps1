##################################################################
#                                                                #
#                                                                #
##################################################################


$NagiosStatus = 0
$output = $null

#Insert services to explude here:
[Array]$global:excludedservices = @('sppsvc','wuauserv', 'gupdate')

$services =  Get-Service | Select-Object -Property Name,DisplayName,Status,StartType | Where-Object {$_.Status -eq "Stopped" -and $_.StartType -eq "Automatic"}

[System.Collections.ArrayList]$FilteredServices = $services

Foreach ($element in $excludedservices)
{
    Foreach ($service in $services)
    {
        If ($element -like $service.name)
        {   
            $index =  $FilteredServices.IndexOf($service)     
            $FilteredServices.removeat($index)
        }
    }     
}

If($FilteredServices -notlike $null){
  $NagiosStatus = 2
  $output = 'Service(s) not running! Amount: ' + $FilteredServices.Count +". Stopped Service(s): " + $FilteredServices.DisplayName
  Write-Host $output
}
else{
  Write-Host "All automatic starting services are in their appropriate state."
}

exit $NagiosStatus