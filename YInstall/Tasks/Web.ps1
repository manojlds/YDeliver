task Web {

    . Add-CarbonModule IIS

    $artifactsDir = Get-Conventions artifactsDir
    $taskConfig = Get-InstallTaskConfiguration
    $spliceMap = Get-InstallTaskSpliceMap

    Extract-Artifact (Join-Path $artifactsDir $taskConfig.artifact) $taskConfig.sitePath $spliceMap
    "Configuring app pool $($taskConfig.appPool)"
    Install-IisAppPool -Name $taskConfig.appPool | Out-Null
    "Configuring site $($taskConfig.siteName)"
    Install-IisWebsite  -Name $taskConfig.siteName `
                        -Path $taskConfig.sitePath `
                        -AppPoolName $taskConfig.appPool `
                        -Bindings  $taskConfig.bindings | Out-Null
}