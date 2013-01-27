function Write-PackageHelp {
    "You don't have packageContents defined in your build.yml. That's sort of odd" | Write-Host
}

task Package {
    $buildPath = Get-Conventions buildPath

    if ($buildConfig.copyContents.keys) {
        ($buildConfig.copyContents).keys | %{
            $source = Resolve-PathExpanded $_
            $destination = Expand-String $buildConfig.copyContents[$_]
            "Copying $source to $destination"
            
            if(!(Test-Path $destination)){
                mkdir $destination | Out-Null
            }
            Copy-PackageItem $source $destination
        }
    }
    if ($buildConfig.packageContents.keys) {
        ($buildConfig.packageContents).keys | %{
            $source = Resolve-PathExpanded $_
            Write-Zip $source $buildPath $buildConfig.packageContents[$_]
        }
    }
    
}
