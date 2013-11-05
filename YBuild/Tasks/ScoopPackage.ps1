task ScoopPackage {
    $buildPath, $artifactsDir = Get-Conventions buildPath, artifactsDir

    $manifestFile = Resolve-PathExpanded $config.scoop.manifestFile
    $package = Join-Path $artifactsDir $config.scoop.package

    $md5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($package)))

    $manifestJson = @{
        version= $buildVersion;
        hash= "md5:$hash";
    }

}