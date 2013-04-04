function Get-Artifacts($artifactsConfig, $version, $destination, $environmentConfig){
    $artifactsConfig | %{
        $artifact = $_.keys[0]
        if($_[$artifact]."teamcity"){
            Download-TeamCityArtifact $_[$artifact]."teamcity" $artifact $version "$destination\$artifact" $environmentConfig."teamcity-server"
        } elseif($_[$artifact]."go"){
            Download-GoArtifact $_[$artifact]."go" $artifact $version "$destination\$artifact" $environmentConfig."go-server"

        } elseif($_[$artifact]."path"){
            Copy-Item (Join-Path $_[$artifact]."path" $artifact) -destination $destination
        }
    }
}

function Build-TeamCityArtifactUrl {
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

function Download-TeamCityArtifact($teamCityConfig, $artifact, $version, $dest, $server){
    $url = Build-TeamCityArtifactUrl -project $teamCityConfig["build-id"] -artifact $artifact -version $version -server $server
    "Downloading artifact from $url"
    Get-WebContent $url $dest -Force
}

function Download-GoArtifact($goConfig, $artifact, $version, $dest, $server) {
    write-host -fore yellow $artifact
    $url = "$server/go/files/{0}/$version/{1}/1/{2}/$artifact" -f @($goConfig["pipeline"], $goConfig["stage"], $goConfig["job"])
    "Downloading artifact from $url"
    Get-WebContent $url $dest -Force
}