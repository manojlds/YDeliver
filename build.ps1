param(
    $tasks = @('Clean', 'Package', 'NugetPackage'), 
    $buildNumber = "1.0.0"
    )

$script:scriptDir = split-path $MyInvocation.MyCommand.Path -parent

Import-Module $script:scriptDir\YDeliver.psm1 -Force
Invoke-YBuild $tasks -buildVersion $buildNumber