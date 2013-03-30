Add-Type -AssemblyName "System.Web"
$microsoftWebAdministrationPath = Join-Path $env:SystemRoot system32\inetsrv\Microsoft.Web.Administration.dll
if( (Test-Path -Path $microsoftWebAdministrationPath -PathType Leaf) )
{
    Add-Type -Path $microsoftWebAdministrationPath
}

Import-Module WebAdministration -Force
