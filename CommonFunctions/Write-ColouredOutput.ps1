#Taken from psake
function Write-ColouredOutput {
    param(
        [string] $message,
        [System.ConsoleColor] $foregroundcolor
    )

    if (($Host.UI -ne $null) -and ($Host.UI.RawUI -ne $null)) {
        $previousColor = $Host.UI.RawUI.ForegroundColor
        $Host.UI.RawUI.ForegroundColor = $foregroundcolor
    }

    $message

    if ($previousColor -ne $null) {
        $Host.UI.RawUI.ForegroundColor = $previousColor
    }
}