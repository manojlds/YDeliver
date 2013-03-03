#Requires -Version 2.0
Set-StrictMode -Version 2.0

Import-Module "$PSScriptRoot\Lib\psake\psake.psm1" -Force
Import-Module "$PSScriptRoot\lib\PowerYaml\PowerYaml.psm1" -Force
. "$PSScriptRoot\CommonFunctions\Merge-Hash.ps1"
. "$PSScriptRoot\CommonFunctions\Get-Configuration.ps1"
. "$PSScriptRoot\CommonFunctions\Resolve-PathExpanded.ps1"
. "$PSScriptRoot\CommonFunctions\Write-ColouredOutput.ps1"

function Invoke-Component($action, $config, $extraParameters) {
    $buildFile = "$PSScriptRoot\Y{0}\{0}.Tasks.ps1" -f $action

    if($listTasks){
        Get-AvailableTasks $buildFile -Full
        return
    }

    $global:rootDir = $rootDir
    $global:yDir = $PSScriptRoot

    
    . "$PSScriptRoot\Conventions\Defaults.ps1" $config["conventions"]

    $parameters = @{
        "config" = $config;
        "conventions" = $conventions;
        "buildVersion" = $buildVersion;
        "rootDir" = $rootDir;
    }

    if($extraParameters){
        $parameters = Merge-Hash $parameters $extraParameters
    }

    Invoke-Psake $buildFile `
        -nologo `
        -framework $conventions.framework `
        -taskList $tasks `
        -parameters $parameters

    if(-not $psake.build_success) { throw "Y{0} failed!" -f $action }
}

function Invoke-YBuild {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = 0)][string[]] $tasks = @('Help'), 
        [Parameter(Position = 1, Mandatory = 0)][string] $buildVersion = "1.0.0",
        [Parameter(Position = 2, Mandatory = 0)][string] $rootDir = $pwd,
        [Parameter(Position = 3, Mandatory = 0)][switch] $listTasks
        )

    $action = "Build"
    $config = Get-BuildConfiguration $rootDir
    Invoke-Component $action $config
}

function Invoke-YInstall {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = 1)][string[]] $applications, 
        [Parameter(Position = 1, Mandatory = 0)][string] $buildVersion = "1.0.0",
        [Parameter(Position = 2, Mandatory = 0)][string] $rootDir = $pwd,
        [Parameter(Position = 3, Mandatory = 0)][switch] $listTasks
        )

    $action = "Install"
    $applications | %{
        Write-ColouredOutput "Installing application $_" yellow
        $config = Get-InstallConfiguration $rootDir $_
        $tasks = $config.tasks
        Invoke-Component $action $config.applicationConfig
    }
}

function Invoke-YFlow {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = 0)][string] $name = "default", 
        [Parameter(Position = 1, Mandatory = 0)][string] $rootDir = $pwd,
        [Parameter(Position = 2, Mandatory = 0)][switch] $listFlows,
        [Parameter(ParameterSetName = 'YBuild', Position = 3)][string] $buildVersion = "1.0.0"
        )

    $config = Get-Configuration $rootDir workflows
    $workflows = $config.workflow

    if($listFlows){
        return Out-WorkFlows $workflows
    }

    if(-not $workflows[$name]){
        throw "The workflow $name is not defined in your configuration"
    }

    $ybuildTasks = $workflows.$name.ybuild

    if($ybuildTasks){
        Invoke-YBuild $ybuildTasks $buildVersion
    }

}

function Invoke-YScaffold {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = 1)][string] $component, 
        [Parameter(Position = 1, Mandatory = 0)][string] $rootDir = $pwd,
        [Parameter(Position = 2, Mandatory = 0)][switch] $force
        )

    $componentPath = "$PSScriptRoot\YScaffold\$component"

    if(-not (Test-Path $componentPath -PathType Container)){
        throw "No scaffolding found for the component $component"
    }

    Write-ColouredOutput "Component $component" Yellow
    $config = Get-Configuration $componentPath config

    $config.Files.GetEnumerator() | %{ 
        $file = Split-Path $_.Name -Leaf
        $source = Join-Path "$componentPath\Files" $_.Name
        $destination = Join-Path (Expand-String $_.Value) $file
        Install-ScaffoldFile $source $destination -force:$force
    }
}

function Get-AvailableTasks($buildFile){
    Invoke-Psake $buildFile -docs -nologo
}

function Out-WorkFlows($workflows){
    $workflows.keys
}

function Install-ScaffoldFile($source, $destination, $force) {
    if((-not $force) -and (Test-Path $destination -PathType Leaf)){
        return "Exists $destination"
    }

    Copy-Item $source -Destination $destination -force:$force
    "{0} $destination" -f (?: $force "Replace" "Create")
}

function ?:([bool]$condition, $first, $second){
    if($condition){ return $first}
    $second
}

Export-ModuleMember -function Invoke-YBuild, Invoke-YInstall, Invoke-YFlow, Invoke-YScaffold