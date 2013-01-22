task Clean {
    $buildPath = Get-Conventions buildPath
    Remove-Item $buildPath -Force -Recurse -ErrorAction silentlycontinue
}