$vm = $Env:Hostname
$WorkspacePath = $Env:Workspace
 
$date_str = Get-Date -UFormat "%m-%d-%Y-%hh-%mm-%ss"
New-Item -ItemType Directory -Force -Path .\logs
#New-Item -Path $WorkspacePath -Name "logs" -ItemType "directory"
$Outputfile = $WorkspacePath + "\logs\output" + $date_str + ".log"
New-Item $Outputfile


#create Output file
function verifyVMLogin($vm) {
    $ComputerName = $vm.VMname + $Domain
    $RemoteSession = New-PSSession -ComputerName $ComputerName -Name '172.30.63.196' -Credential $cred -ErrorAction Continue
    $output = New-Object psobject
    $output | Add-Member -MemberType NoteProperty -Name VMName -Value $vm.VMname
    If ($RemoteSession.State -eq "Opened") {
        $output | Add-Member -MemberType NoteProperty -Name VMStatus -Value "Running"
        $text = "HC_NAME: Verify VM Login Check, HC_STATUS: PASS, VM_NAME: " + $vm
        $text | Out-File $Outputfile -Append -Force
    }
    else {
        $text = "HC_NAME: Verify VM Login Check, HC_STATUS: FAIL, VM_NAME: " + $vm
        $text | Out-File $Outputfile -Append -Force
    }
}

function verifyAppInstallCheck($app_name, $app_location) {
    Write-Output "`r`nHC_CHECK: Verify App Installation for $app_name started"
    "HC_CHECK: Verify App Installation for $app_name started" | Out-File $Outputfile -Append -Force
     If (Test-Path "$app_location") {         
         $list = Get-ChildItem -Path "$app_location" 
         $list | Out-File $Outputfile -Append -Force
         Write-Output "$app_name installation location successfully identified : $app_name "
         $text = "HC_NAME: Verify Application Installation Check, HC_STATUS: PASS, APP_NAME: " + $app_name
         $text | Out-File $Outputfile -Append -Force }
     else {
         Write-Output " $app_name not installed. Please check the application manually."
         $text = "HC_NAME: Verify Application Installation Check, HC_STATUS: FAIL, APP_NAME: " + $app_name
         $text | Out-File $Outputfile -Append -Force
    }
}

function verifyAppLog($app_name, $app_location, $log_location, $logfilename, $message) {
    Write-Output "`r`nHC_CHECK: Verify App Log for $app_name started"
    "`r`nHC_CHECK: Verify App Log for $app_name started" | Out-File $Outputfile -Append -Force
    If (Test-Path "$app_location") {
        Write-Output "Application is installed, proceeding further..."
        #Get-ChildItem $loglocation/$logfilename | Out-File $Outputfile -Append
        Write-Output "Verifying the log message..."
        Write-Output $log_location/$logfilename  $message
        if($message -ne '' -or $logfilename -ne '') {
        $out = Select-String -Path $log_location/$logfilename -Pattern $message
        if($out) {
            Write-Output "Found the message: $message in the log file $logfilename."
            $text = "HC_NAME: Verify Application Log Check, HC_STATUS: PASS, APP_NAME: " + $app_name
            $text | Out-File $Outputfile -Append -Force
        } else {
            Write-Output "Log Validation Check Failed. Please check HC Logs for details."
            $text = "HC_NAME: Verify Application Log Check, HC_STATUS: FAIL, APP_NAME: " + $app_name
            $text | Out-File $Outputfile -Append -Force
        }
     }
     }
     else {
        $text = "Did not find the installation directory of the application, hence not proceeding further. Please check manually whether the application is installed and then proceed further / re-trigger."
        $text | Out-File $Outputfile -Append -Force
        $text = "HC_NAME: Verify Application Installation Check, HC_STATUS: ERROR, APP_NAME: " + $app_name
        $text | Out-File $Outputfile -Append -Force
        Write-Output "Some error occurred. Please check the log file and proceed..."
     }
}

function verifyAppStatus($app_name,$app_servicename) {
    Write-Output "`r`nHC_CHECK: Verify App Status for $app_name started"
    "`r`nHC_CHECK: Verify App Status for $app_name started" | Out-File $Outputfile -Append -Force
    #$app_status = Get-Service postgresql-x64-9.5 -ErrorAction SilentlyContinue
    Get-Service | Out-File -FilePath .\temp.txt
    $app_status = Select-String -Path .\temp.txt -Pattern $app_servicename
         
    if ($app_status) {
        $app_status | Out-File $Outputfile -Append -Force
        Write-Output "Application $app_name is up and running."
        $text = "HC_NAME: Verify Application Status Check, HC_STATUS: PASS, APP_NAME: " + $app_name
        $text | Out-File $Outputfile -Append -Force
    } else {
        $app_status | Out-File $Outputfile -Append -Force
        Write-Output "Application $app_name is not found in running processes. Please check manually."
        $text = "HC_NAME: Verify Application Status Check, HC_STATUS: FAIL, APP_NAME: " + $app_name
        $text | Out-File $Outputfile -Append -Force
    }

}
function createHTMLReport() {
    $user = whoami
	$hostname = $env:computername
	#$filename = "output/report_$date_str.html"
	$filename = "output/report.html"
    $date_report = Get-Date
    $var1 = "<html><head><style>table, th, td {  border: 1px solid black;}</style></head><body> <h2>Installation Check Report</h2> <p>Triggered by: $user </p><p>Host name: $env:computername</p><p>Triggered Date: $date_report</p><table><tr><th> App Name </th><th> HC Name </th> <th> HC Status </th> </tr>"
    $var3 = "</table> <p>Report location: $PSScriptRoot\$filename </p> <p>Log Location: $PSScriptRoot\$Outputfile </p><p>Please check the log for more details.</p></body> </html>" 
	$var2 = ""
	
	$values = Select-String -Path $Outputfile -Pattern "HC_NAME"
    foreach($line in $values)
	{    
		$str1 = $line.line    
		$hc_name = ($line.line.Split(" "))[1] + " " + ($line.line.Split(" "))[2] + " " + ($line.line.Split(" "))[3] + " " +($line.line.Split(" "))[4]
		$hc_status = ($line.line.Split(" "))[6]
		$hc_app =  ($line.line.Split(" "))[8]  
		
		$row = "<tr><td>" + $hc_app + "</td><td>" + $hc_name + "</td><td style='font-style:normal;color:green;font-size:18px;'>" + $hc_status + "</td></tr>"
		#Write-Output $row
		$var2 = $var2 + $row
	}	
	$file = $var1 + $var2 + $var3 
	$file | Out-File $filename
}
