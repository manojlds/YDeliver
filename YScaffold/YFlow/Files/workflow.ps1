param(
    $name = 'default', 
    $buildNumber = "1.0.0"
    )

$script:scriptDir = split-path $MyInvocation.MyCommand.Path -parent

#Import-Module $script:scriptDir\BuildScripts\YDeliver.psm1
Invoke-YFlow $name -buildVersion $buildNumber