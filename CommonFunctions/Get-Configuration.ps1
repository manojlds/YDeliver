function Get-Configuration {
    param($path, $name)

    $config = @{}

    if (Test-Path "$path\$name.yml") {
        $config = Get-Yaml -FromFile "$path\$name.yml"
      }
    $config
}

function Get-BuildConfiguration($path) {
    Get-Configuration $path build
}

function Get-InstallConfiguration($path, $application) {
    $installConfig = Get-Configuration $path install
    $applicationConfig = $installConfig.install.$application
    $applicationConfig.config["conventions"] = $installConfig["conventions"]
    $config = @{
        "tasks" = $applicationConfig.tasks;
        "applicationConfig" = $applicationConfig.config;
    }
    $config
}