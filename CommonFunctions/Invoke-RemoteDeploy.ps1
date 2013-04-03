function Invoke-RemoteDeploy($server, $roleConfig, $version) {
    
    $remoteYDeliverPath = Get-Conventions remoteYDeliverPath

    "Deploying to $server"

    $session = New-PSSession -ComputerName $server -authentication NegotiateWithImplicitCredential

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
        };
       
        "Using YDeliver from $modulePath"

        Invoke-Command -Session $session -Command {
            param($deployConfig)

            $importedScripts = $ExecutionContext.InvokeCommand.NewScriptBlock($deployConfig["importedScripts"])
            . $importedScripts
            
            if(Test-Path $deployConfig["workingDir"] -PathType Container){
                rm $deployConfig["workingDir"] -force
            }
            mkdir $deployConfig["workingDir"] | Out-Null
            Set-Location $deployConfig["workingDir"]

            Get-Artifacts $deployConfig["roleConfig"].artifacts $deployConfig["version"] $deployConfig["workingDir"]
            
            Import-Module "$($deployConfig["modulePath"])\YDeliver.psm1"
            Invoke-YInstall -applications $deployConfig["roleConfig"].applications.keys -config $deployConfig["installConfig"]
            
            rm $deployConfig["workingDir"] -force -ea silentlycontinue

        } -ArgumentList @(, $deployConfig)
    } finally {
        Remove-PSSession $session
    }

}