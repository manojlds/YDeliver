$script:dir = Split-Path -Parent $MyInvocation.MyCommand.Path
gci $script:dir\..\CommonFunctions -filter "*.ps1" | ? { -not $_.FullName.EndsWith(".Tests.ps1") } | % { . $_.FullName }
gci $script:dir\Tasks -filter "*.ps1" | ? { -not $_.FullName.EndsWith(".Tests.ps1") } | % { . $_.FullName }

if (Test-Path ("$rootDir\install.custom.tasks.ps1")) {
    "Importing custom tasks..."
    . "$rootDir\install.custom.tasks.ps1"
}