function Get-Artifacts($artifactsConfig, $version, $destination){
    $artifactsConfig | %{
        $artifact = $_.keys[0]
        if($_[$artifact]."teamcity-build-id"){
            Download-TeamCityArtifact $_[$artifact]."teamcity-build-id" $artifact $version $destination
        }
    }
}

function Build-URL {
    param($project, $artifact, $version)

    $url = "http://localhost:8153/guestAuth/repository/download/$project/"
    if (($version -eq $null) -or ($version -eq "last_pinned")) {
        $url += ".lastPinned"
    } elseif ($version -eq "latest") {    
        $url += ".lastSuccessful"    
    } else {
        $url += "$version"
    }
    
    return $url += "/$artifact"
}

function Download-TeamCityArtifact {
    param($project, $artifact, $version, $dest)
    
    $url = Build-URL -project $project -artifact $artifact -version $version
    "Downloading artifact from $url"
    Get-WebContent $url $dest -Force
}