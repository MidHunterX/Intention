# Default procedure
# Opens Rainmeter and sets wallpaper

$executable = "X:\Mid_Hunter\Rainmeter 4.3\Rainmeter.exe"
$wallpaper    = "X:\Customization\Wallpaper\hud modded 1080.jpg"

# Set wallpaper
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
[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $wallpaper, $SPIF_UPDATEINIFILE -bor $SPIF_SENDWININICHANGE)

# Start executable if exists
if (Test-Path $executable) {
    Start-Process -FilePath $executable
}
