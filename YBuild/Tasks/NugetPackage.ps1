task NugetPackage {
    $buildPath, $libPath = Get-Conventions buildPath, libPath
    $nuget = "$libPath\Nuget\Nuget.exe"

    $buildConfig["nugetPackageProjects"] | %{
        $project = Get-ChildItem "$rootDir\$_" -recurse

        Exec { & $nuget pack $project -BasePath $buildPath -Version $buildVersion -OutputDirectory $buildPath -Properties Configuration=Release } "Nuget packaging failed"
    }
}