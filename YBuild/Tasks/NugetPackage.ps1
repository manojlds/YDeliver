task NugetPackage {
    $buildPath, $artifactsDir, $libPath, $buildMode = Get-Conventions buildPath, artifactsDir, libPath, buildMode
    $nuget = "$libPath\Nuget\Nuget.exe"
    $basePath = $buildPath
    if($config["nugetBasePath"]){
        $basePath = Resolve-PathExpanded $config["nugetBasePath"]
    }

    $config["nugetSpecs"] | %{
        $project = Get-ChildItem "$rootDir\$_" -recurse

        Exec { 
            & $nuget pack $project -BasePath $basePath -Version $buildVersion -OutputDirectory $artifactsDir -Properties Configuration=$buildMode 
        } "Nuget packaging failed"
    }
}