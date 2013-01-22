function Get-Configuration {
    param($path, $name)

    $config = @{ HasNoErrors = $false; HasErrors = $true; }
    if (Test-Path "$path\$name.yml") {
       $config = Get-Yaml -FromFile "$path\$name.yml"
       $config.HasNoErrors = $true
       $config.HasErrors   = $false
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