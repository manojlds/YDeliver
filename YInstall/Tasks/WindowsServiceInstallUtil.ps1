task WindowsServiceInstallUtil{
    
    $artifactsDir = Get-Conventions artifactsDir
    $taskConfig = Get-InstallTaskConfiguration

    Extract-Artifact (Join-Path $artifactsDir $taskConfig.artifact) $taskConfig.servicePath

    $serviceExe = (Join-Path $taskConfig.servicePath $taskConfig.serviceExeName)

    if(Get-Service $taskConfig.serviceName -ea silentlycontinue){
        "Removing existing service $($taskConfig.serviceName)"
        Exec { installutil /u $serviceExe }
    }

    Exec { installutil $serviceExe } "Service install failed"
}