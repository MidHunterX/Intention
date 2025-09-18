# Gaming mode procedure
# Sets a gaming wallpaper and launches a game

$gameExe   = "X:\Mid_Hunter\Playnite\Playnite.DesktopApp.exe"
$wallpaper = "X:\Customization\Wallpaper\games.dll\FarCry 5.jpg"

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

# Launch the game
if (Test-Path $gameExe) {
    Start-Process -FilePath $gameExe
}