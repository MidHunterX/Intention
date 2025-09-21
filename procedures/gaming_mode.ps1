# Gaming mode procedure
# Sets a gaming wallpaper and launches Playnite

$executable = "X:\Mid_Hunter\Playnite\Playnite.DesktopApp.exe"
$wallpaper  = "X:\Customization\Wallpaper\games.dll\The_Witcher_3.jpg"

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
