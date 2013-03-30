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

    $config = @{
        "conventions" = $installConfig["conventions"];
        "tasks" = $applicationConfig.tasks.keys;
        "taskConfigs" = $applicationConfig.tasks;
    }

    $config
}

function Get-InstallTaskConfiguration(){
    $config.taskConfigs["$($currentContext.currentTaskName)"].config
}