function Get-WebContent([string] $url, [string] $file = "", [switch]$force, $credentials) {
    if($force) { 
        [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} 
    }
    
    $webclient = New-Object system.net.webclient
    
    if(($credentials) -and ($credentials.getType().Name -eq "PSCredential")){
        $credentials = New-Object System.Management.Automation.PSCredential ($credentials.getNetworkCredential().username, $credentials.password)
        $webclient.Credentials = $credentials
    }

    try {
        if ($file -eq "") {
            return $webclient.DownloadString($url)
        } else {
            "Starting download from $url to $file"
            $webclient.DownloadFile($url, $file)
        }
    } catch [Net.WebException] {
        
        $exception = $_.Exception.ToString()
        
        throw $exception
    }
}
