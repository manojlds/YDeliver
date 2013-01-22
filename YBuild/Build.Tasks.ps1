$script:dir = Split-Path -Parent $MyInvocation.MyCommand.Path
gci $script:dir\..\CommonFunctions | ? { -not $_.FullName.EndsWith(".Tests.ps1") } | % { . $_.FullName }
gci $script:dir\Tasks | ? { -not $_.FullName.EndsWith(".Tests.ps1") } | % { . $_.FullName }

if (Test-Path ("$rootDir\build.custom.tasks.ps1")) {
    "Importing custom build tasks..."
    . "$rootDir\build.custom.tasks.ps1"
}