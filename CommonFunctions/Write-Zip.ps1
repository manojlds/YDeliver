function Write-Zip($source, $destination, $packageName){
    $libPath = Get-Conventions libPath
    $7z = "$libPath\7z\7za.exe"
    "Zipping $source to $destination\$packageName"
    $zipCommand = "$7z a $(join-path $destination $packageName) $source"
    
    iex $zipCommand | out-null
}

function Expand-Zip($source, $destination) {
    $libPath = Get-Conventions libPath
    $7z = "$libPath\7z\7za.exe"

    Remove-Item $destination -Recurse -ErrorAction silentlycontinue

    "Unzipping $source to $destination"

    $destination = "-o" + $destination 
    &$7z x -y $source $destination | out-null
}