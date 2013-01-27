$conventions = @{}
$conventions.framework = "4.0x64"
$conventions.buildMode = "Release"
$conventions.buildPath = "$rootDir\build"
$conventions.solutionFile = (Resolve-Path $rootDir\src\*.sln, $rootDir\source\*.sln -ea SilentlyContinue)
$conventions.libPath = "$yDir\Lib"
$conventions.unitTestPathPattern = "*UnitTests"

"Conventions being used:" 
"rootDir`t`t: $rootDir"
$conventions.keys | % {
    "$_`t: $($conventions.$_)"
}
""