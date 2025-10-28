function Set-Wallpaper {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        Write-Warning "Wallpaper not found: $Path"
        return
    }

    Add-Type @"
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@

    $SPI_SETDESKWALLPAPER = 20
    $SPIF_UPDATEINIFILE   = 0x01
    $SPIF_SENDWININICHANGE= 0x02

    [Wallpaper]::SystemParametersInfo(
        $SPI_SETDESKWALLPAPER, 0, $Path,
        $SPIF_UPDATEINIFILE -bor $SPIF_SENDWININICHANGE
    )

    Write-Host "Wallpaper set to: $Path"
}

function Start-Executable {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (Test-Path $Path) {
        Start-Process -FilePath $Path
        Write-Host "Started: $Path"
    } else {
        Write-Warning "Executable not found: $Path"
    }
}
