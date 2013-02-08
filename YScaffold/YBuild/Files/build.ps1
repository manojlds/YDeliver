param($buildNumber = "1.0.0")

$script:scriptDir = split-path $MyInvocation.MyCommand.Path -parent

#Import-Module $script:scriptDir\BuildScripts
$buildTasks = @('Clean', 'Compile', 'UnitTests', 'Package')
Invoke-YBuild $buildTasks -buildVersion $buildNumber