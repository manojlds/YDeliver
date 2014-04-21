function Get-Configuration {
    param($path, $name, $overrideConfig)

    $config = @{}

    if (Test-Path "$path\$name.yml") {
        $config = Get-Yaml -FromFile "$path\$name.yml"
    } elseif($overrideConfig) {
        return $overrideConfig
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
    $installConfig = Apply-Values $installConfig $installConfig.values
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

function Get-InstallTaskSpliceMap(){
    $config.taskConfigs["$($currentContext.currentTaskName)"].spliceMap
}

function Get-EnvironmentConfig($environment, $overrideConfig){
    $configPath = Join-Path "$rootDir\EnvironmentConfigs" "$environment.yml"
    if(-not (Test-Path $configPath -PathType Leaf)){
        throw "Environment config not found at $configPath"
    }

    $config = Get-Yaml -FromFile $configPath

    if($overrideConfig){
        return Merge-Hash $config $overrideConfig
    }

    $config

}