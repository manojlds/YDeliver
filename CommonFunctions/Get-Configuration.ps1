function Get-Configuration {
    param($path, $name, $overrideConfig)

    $config = @{}

    if (Test-Path "$path\$name.yml") {
        $config = Get-Yaml -FromFile "$path\$name.yml"
      }
    
    if($overrideConfig){
        return Merge-Hash $config $overrideConfig
    }

    $config
}

function Get-BuildConfiguration($path, $config) {
    Get-Configuration $path build $config
}

function Get-InstallConfiguration($path, $application, $config) {
    $installConfig = Get-Configuration $path install $config
    $applicationConfig = $installConfig.install.$application
    $applicationConfig.config["conventions"] = $installConfig["conventions"]
    $config = @{
        "tasks" = $applicationConfig.tasks;
        "applicationConfig" = $applicationConfig.config;
    }
    $config
}