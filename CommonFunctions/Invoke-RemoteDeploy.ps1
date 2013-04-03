function Invoke-RemoteDeploy($server, $roleConfig, $environmentConfig, $version) {
    
    $remoteYDeliverPath = Get-Conventions remoteYDeliverPath

    "Deploying to $server"
    if($roleConfig["credential"]){
        $credential = Get-PSCredential $roleConfig.credential.username $roleConfig.credential.password 
        $session = New-PSSession -ComputerName $server -authentication Default -credential $credential
    } else {
        $session = New-PSSession -ComputerName $server -authentication Default
    }

    try{

        $modulePath = Install-YDeliver $remoteYDeliverPath $session
        $installConfig = Get-Configuration $rootDir install
        $workingDir = Join-Path $modulePath "temp"

        $installConfigConventions = $installConfig.conventions
        if($installConfigConventions){
            $installConfigConventions["artifactsDir"] = $workingDir
        } else {
            $installConfig.conventions = @{ "artifactsDir" = $workingDir; }
        }

        $importedScripts = Import-Scripts @("$yDir\CommonFunctions\Get-Artifacts.ps1", "$yDir\CommonFunctions\Get-WebContent.ps1")

        $deployConfig = @{
            "modulePath" = $modulePath;
            "workingDir" = $workingDir;
            "installConfig" = $installConfig;
            "roleConfig" = $roleConfig;
            "version" = $version;
            "remoteYDeliverPath" = $remoteYDeliverPath;
            "importedScripts" = $importedScripts;
            "environmentConfig" = $environmentConfig;
        };
       
        "Using YDeliver from $modulePath"

        Invoke-Command -Session $session -Command {
            param($deployConfig)

            $importedScripts = $ExecutionContext.InvokeCommand.NewScriptBlock($deployConfig["importedScripts"])
            . $importedScripts
            
            if(Test-Path $deployConfig["workingDir"] -PathType Container){
                rm $deployConfig["workingDir"] -force -recurse
            }
            mkdir $deployConfig["workingDir"] | Out-Null
            Set-Location $deployConfig["workingDir"]

            Get-Artifacts -artifactsConfig $deployConfig["roleConfig"].artifacts `
                          -version $deployConfig["version"] `
                          -destination $deployConfig["workingDir"] `
                          -environmentConfig $deployConfig["environmentConfig"]
            
            Import-Module "$($deployConfig["modulePath"])\YDeliver.psm1"
            Invoke-YInstall -applications $deployConfig["roleConfig"].applications.keys -config $deployConfig["installConfig"]
            
            rm $deployConfig["workingDir"] -force -recurse -ea silentlycontinue

        } -ArgumentList @(, $deployConfig)
    } finally {
        Remove-PSSession $session
    }

}