function global:Version-AssemblyInfoFiles($version) {

    $newVersion = 'AssemblyVersion("' + $version + '")';
    $newFileVersion = 'AssemblyFileVersion("' + $version + '")';

    Get-ChildItem $rootDir -Recurse | ? {$_.Name -eq "AssemblyInfo.cs"} | % {
        $tmpFile = "$($_.FullName).tmp"

        gc $_.FullName |
            %{$_ -replace 'AssemblyVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)', $newVersion } |
            %{$_ -replace 'AssemblyFileVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)', $newFileVersion }  | 
              Out-File $tmpFile -encoding UTF8

        Move-Item $tmpFile $_.FullName -force
    }
}

task Compile {
    $buildMode, $buildPath, $solutionFile = Get-Conventions buildMode, buildPath, solutionFile
    Version-AssemblyInfoFiles $buildVersion
    Exec { msbuild $solutionFile /p:OutputPath=$buildPath /p:Configuration=$buildMode /verbosity:minimal /nologo } "Build Failed - Compilation"
}