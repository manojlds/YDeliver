task NugetPackage {
    $buildPath, $libPath, $buildMode = Get-Conventions buildPath, libPath, buildMode
    $nuget = "$libPath\Nuget\Nuget.exe"
    $basePath = $buildPath
    if($config["nugetBasePath"]){
        $basePath = Resolve-PathExpanded $config["nugetBasePath"]
    }

    $config["nugetSpecs"] | %{
        $project = Get-ChildItem "$rootDir\$_" -recurse

        Exec { 
            & $nuget pack $project -BasePath $basePath -Version $buildVersion -OutputDirectory $buildPath -Properties Configuration=$buildMode 
        } "Nuget packaging failed"
    }
}