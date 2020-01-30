. .\src\windows-hc.ps1



$path = ".\data\app_list.csv"
$csv = Import-Csv -path $path

Write-Output "Reading csv file ..."
foreach($line in $csv)
{ 
    $properties = $line | Get-Member -MemberType Properties
    $column = $properties[0]
    $columnvalue = $line | Select -ExpandProperty $column.Name
    $app_location = $columnvalue
    #Write-Output "******** applocation: $app_location"
    
    $column = $properties[1]
    $columnvalue = $line | Select -ExpandProperty $column.Name
    $app_name = $columnvalue
    #Write-Output "******** app_name : $app_name"

    $column = $properties[2]
    $columnvalue = $line | Select -ExpandProperty $column.Name
    $app_servicename = $columnvalue
    #Write-Output "******** app_servicename: $app_servicename"

    $column = $properties[3]
    $columnvalue = $line | Select -ExpandProperty $column.Name
    $logfilename = $columnvalue
    #Write-Output "******** log_file_name: $logfilename"

    $column = $properties[4]
    $columnvalue = $line | Select -ExpandProperty $column.Name
    $log_location = $columnvalue
    #Write-Output "******** log_loc: $log_location"
    
    $column = $properties[5]
    $columnvalue = $line | Select -ExpandProperty $column.Name
    $msg = $columnvalue
    #Write-Output "******** msg: $msg"
    
    
    #Set Env variables to be used by other PS1 script:
    $env:Hostname = $env.computername
    $env:Workspace = "."    


    if($app_name -ine '' -or $app_location -ine '' -or $app_name -ine 'NULL' -or $app_location -ine 'NULL'){
    verifyAppInstallCheck $app_name $app_location}
    else {
    Write-Host "Enter a Valid AppName and Location"
    }
    if($app_name -ine '' -or $app_location -ine '' -or $log_location -ine '' -or $logfilename,$msg -ine '' -or $app_name -ine 'NULL' -or $app_location -ine 'NULL' -or $log_location -ine 'NULL' -or $logfilename -ine 'NULL' -or $msg -ine 'NULL' ){
    verifyAppLog $app_name $app_location $log_location $logfilename $msg }
    else {
    Write-Host "Enter Valid Details"
    }

    if($app_name -ine '' -or $app_servicename -ine '' -or $app_name -ine 'NULL' -or $app_servicename -ine 'NULL'){
    verifyAppStatus $app_name $app_servicename}
    else {
    Write-Host "Enter Valid Details"
    }
} 

createHTMLReport
Write-Output "Completed health checks for Applications. Please check logs and reports for more details."
