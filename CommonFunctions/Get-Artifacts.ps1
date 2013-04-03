function Get-Artifacts($artifactsConfig, $version, $destination, $environmentConfig){
    $artifactsConfig | %{
        $artifact = $_.keys[0]
        if($_[$artifact]."teamcity-build-id"){
            Download-TeamCityArtifact $_[$artifact]."teamcity-build-id" $artifact $version "$destination\$artifact" $environmentConfig."teamcity-server"
        } elseif($_[$artifact]."path"){
            Copy-Item (Join-Path $_[$artifact]."path" $artifact) -destination $destination
        }
    }
}

function Build-URL {
    param($project, $artifact, $version, $server)

    $url = "$server/guestAuth/repository/download/$project/"
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
    param($project, $artifact, $version, $dest, $server)
    
    $url = Build-URL -project $project -artifact $artifact -version $version -server $server
    "Downloading artifact from $url"
    Get-WebContent $url $dest -Force
}