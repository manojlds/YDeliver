function Get-Configuration {
    param($path, $name)

    $config = @{}

    if (Test-Path "$path\$name.yml") {
        $config = Get-Yaml -FromFile "$path\$name.yml"
      }
    $config
}

function Get-BuildConfiguration {
    param($path)
    Get-Configuration $path build
}

function Get-InstallConfiguration {
    param($path)
    Get-Configuration $path install
}