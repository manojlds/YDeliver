#Taken from psake
function Write-ColoredOutput {
    param(
        [string] $message,
        [System.ConsoleColor] $foregroundcolor
    )

    $currentConfig = Get-CurrentConfigurationOrDefault
    if ($currentConfig.coloredOutput -eq $true) {
        if (($Host.UI -ne $null) -and ($Host.UI.RawUI -ne $null)) {
            $previousColor = $Host.UI.RawUI.ForegroundColor
            $Host.UI.RawUI.ForegroundColor = $foregroundcolor
        }
    }

    $message

    if ($previousColor -ne $null) {
        $Host.UI.RawUI.ForegroundColor = $previousColor
    }
}