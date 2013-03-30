function Extract-Artifact($source, $destination, $spliceMap) {
    if(-not (Test-Path $source)){
        throw "Artifact $source not found"
    }

    $source = Get-Item $source

    if($source.extension -eq ".zip"){
        Expand-Zip $source.FullName $destination
    }

    if($spliceMap){
        Splice-Artifact $destination $spliceMap
    }
}

function Splice-Artifact($extractedArtifactPath, $spliceMap){
    $spliceMap.keys | %{
        Splice-XMLConfigFile "$extractedArtifactPath\$_" $spliceMap[$_]
    }
}