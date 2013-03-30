function Add-CarbonModule($module){
    $libPath = Get-Conventions libPath
    Get-ChildItem "$libPath\Carbon\$module" -filter "*.ps1" | %{ . $_.fullname }
}