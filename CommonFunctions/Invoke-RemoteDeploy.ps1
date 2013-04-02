function Invoke-RemoteDeploy($server, $roleConfig) {
    
    $remoteYDeliverPath = Get-Conventions remoteYDeliverPath

    "Deploying to $server"

    $session = New-PSSession -ComputerName $server

    $modulePath = Install-YDeliver $remoteYDeliverPath $session
    $installConfig = Get-Configuration $rootDir install
    $workingDir = Join-Path $modulePath "temp"

    $installConfigConventions = $installConfig.conventions
    if($installConfigConventions){
        $installConfigConventions["artifactsDir"] = $workingDir
    } else {
        $installConfig.conventions = @{ "artifactsDir" = $workingDir; }
    }

    "Using YDeliver from $modulePath"

    Invoke-Command -Session $session -Command {
        param($modulePath, $workingDir, $installConfig, $roleConfig, $remoteYDeliverPath)
        Import-Module "$modulePath\YDeliver.psm1"
        mkdir $workingDir
        Set-Location $workingDir
        write-host $installConfig["conventions"]["artifactsDir"]
        Invoke-YInstall -applications $roleConfig.applications.keys -config $installConfig
        rm $workingDir -force

    } -ArgumentList @(, $modulePath, $workingDir, $installConfig, $roleConfig, $remoteYDeliverPath)

    Remove-PSSession $session

}