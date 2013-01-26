function Invoke-NUnitTests($buildPath, $libPath, $testPathPattern) {
    $testProjects = Get-Item "$buildPath\$testPathPattern.dll"
    $nunit = "$libPath\NUnit\nunit-console.exe"
    Exec { & $nunit $testProjects "/xml=$buildPath\UnitTest-Results.xml" } "Unit tests failed"
}

task UnitTests{
    $buildPath, $libPath, $unitTestPathPattern = Get-Conventions buildPath, libPath, unitTestPathPattern

    Invoke-NUnitTests $buildPath $libPath $unitTestPathPattern
}