function Install-YDeliver($path, $session){
    Invoke-Command -session $session -command {
        param($path)
        &nuget install YDeliver -o $path | Out-Null
        $installedPackagePath = (Get-ChildItem $path | Select -Last 1).fullname
        Join-Path $installedPackagePath "tools"
    } -ArgumentList @(, $path)
}