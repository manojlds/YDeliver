function global:Version-AssemblyInfoFiles($version, $sourceFoldersFilter) {

    $newVersion = 'AssemblyVersion("' + $version + '")';
    $newFileVersion = 'AssemblyFileVersion("' + $version + '")';

    Get-ChildItem $rootDir -Recurse -Filter "AssemblyInfo.cs" | ?{ $_.fullname -notmatch $sourceFoldersFilter } | % {
        $tmpFile = "$($_.FullName).tmp"

        gc $_.FullName |
            %{$_ -replace 'AssemblyVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)', $newVersion } |
            %{$_ -replace 'AssemblyFileVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)', $newFileVersion }  | 
              Out-File $tmpFile -encoding UTF8

        Move-Item $tmpFile $_.FullName -force
    }
}

task Compile {
    $buildMode, $buildPath, $solutionFile, $sourceFoldersFilter = Get-Conventions buildMode, buildPath, solutionFile, sourceFoldersFilter
    Version-AssemblyInfoFiles $buildVersion $sourceFoldersFilter
    Exec { msbuild $solutionFile /p:OutputPath=$buildPath /p:Configuration=$buildMode /verbosity:minimal /nologo } "Build Failed - Compilation"
}