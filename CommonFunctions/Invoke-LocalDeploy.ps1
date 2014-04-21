function Invoke-LocalDeploy($roleConfig, $environmentConfig) {
    
    "Deploying to localhost"

    Invoke-YInstall -applications $roleConfig.applications.keys -config @{ values = $environmentConfig.values}
}