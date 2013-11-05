function Write-PackageHelp {
    "You don't have packageContents defined in your build.yml. That's sort of odd" | Write-Host
}

task Package {
    $buildPath, $artifactsDir = Get-Conventions buildPath, artifactsDir

    if ($config.copyContents.keys) {
        ($config.copyContents).keys | %{
            $source = Resolve-PathExpanded $_
            $destination = Expand-String $config.copyContents[$_]
            "Copying $source to $destination"
            
            if(!(Test-Path $destination)){
                mkdir $destination | Out-Null
            }
            Copy-PackageItem $source $destination
        }
    }
    if ($config.packageContents.keys) {
        ($config.packageContents).keys | %{
            $source = Resolve-PathExpanded $_
            Write-Zip $source $artifactsDir $config.packageContents[$_]
        }
    }   
}
