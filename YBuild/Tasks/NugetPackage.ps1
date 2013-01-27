task NugetPackage {
    $buildPath, $libPath, $buildMode = Get-Conventions buildPath, libPath, buildMode
    $nuget = "$libPath\Nuget\Nuget.exe"

    $buildConfig["nugetSpecs"] | %{
        $project = Get-ChildItem "$rootDir\$_" -recurse

        Exec { 
            & $nuget pack $project -BasePath $buildPath -Version $buildVersion -OutputDirectory $buildPath -Properties Configuration=$buildMode 
        } "Nuget packaging failed"
    }
}