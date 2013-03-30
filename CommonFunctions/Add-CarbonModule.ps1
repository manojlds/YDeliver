function Add-CarbonModule($module){
    $libPath = Get-Conventions libPath
    Get-ChildItem "$libPath\Carbon\$module" -filter "*.ps1" | %{ . $_.fullname }
}

function Add-CarbonAssembly(){
    $libPath = Get-Conventions libPath
    Add-Type -Path "$libPath\Carbon\bin\Carbon.dll"
}