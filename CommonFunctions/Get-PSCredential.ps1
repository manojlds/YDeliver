function Get-PSCredential($username, $password){
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    New-Object System.Management.Automation.PSCredential ($username, $securePassword)   
}