task WindowsService{
    
    Add-Type -AssemblyName System.ServiceProcess
    . Add-CarbonAssembly
    . Add-CarbonModule Security
    . Add-CarbonModule UsersAndGroups
    . Add-CarbonModule Service
    . Add-CarbonModule Privileges

    $artifactsDir = Get-Conventions artifactsDir
    $taskConfig = Get-InstallTaskConfiguration

    Extract-Artifact (Join-Path $artifactsDir $taskConfig.artifact) $taskConfig.servicePath

    Install-Service -Name $taskConfig.serviceName `
                    -Path (Join-Path $taskConfig.servicePath $taskConfig.serviceExeName) `
                    -StartupType Manual

}