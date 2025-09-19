param(
    [string]$Action
)

# ============================ [ SELF-INSTALL / UNINSTALL ] ============================ #
$taskName = "XOSCRP-Client"

# Uninstall from tasks (.\recv.ps1 uninstall)
if ($Action -eq "uninstall") {
	$fullName = "\$taskName"
    schtasks /Query /TN $fullName 2>$null
    if ($LASTEXITCODE -eq 0) {
		if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltinRole] "Administrator")) {
			Write-Warning "Run powershell as administrator to uninstall '$fullName'"
			exit
		}

        schtasks /Delete /TN $fullName /F | Out-Null
        Write-Host "Uninstalled $fullName"
    }
    else {
        Write-Warning "'$fullName' is already uninstalled"
    }
    exit 0
}

# Check if task already exists else install (.\recv.ps1)
$taskExists = schtasks /Query /TN $taskName 2>$null
if ($LASTEXITCODE -ne 0) {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltinRole] "Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }

    Write-Host "Registering Task Scheduler job: $taskName"

    $scriptPath = $MyInvocation.MyCommand.Path
    $fullName   = "\$taskName"


  # Minimized Version
  # schtasks /Create /TN $fullName /TR "powershell.exe /NoProfile -WindowStyle Minimized -ExecutionPolicy Bypass -File `"$scriptPath`"" /SC ONLOGON /RL HIGHEST /F

  # Normal Popup Version
    schtasks /Create /TN $fullName /TR "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" /SC ONLOGON /RL HIGHEST /F
}

# ============================ [ CORE-LOGIC ] ============================ #

$Protocol = "xoscrp"
# $CommsDir = Join-Path $env:SystemDrive ".${Protocol}"
$CommsDir = "X:\.${Protocol}"
$ProcDir  = Join-Path $PSScriptRoot "procedures"

# Ensure comms + procedure dirs
if (!(Test-Path $CommsDir))  { New-Item -ItemType Directory -Path $CommsDir | Out-Null }
if (!(Test-Path $ProcDir))   { New-Item -ItemType Directory -Path $ProcDir  | Out-Null }

# User reassurance
function Show-Banner {
@"
    ▀▄▀ █▀█ █▀ █▀▀ █▀█ █▀█
    █░█ █▄█ ▄█ █▄▄ █▀▄ █▀▀
    XOSCRP Client (User-space Automation)
"@ | Write-Host -ForegroundColor Cyan
}
# Only show banner if running in an interactive console
if ($Host.Name -ne 'ConsoleHost') { } else { Show-Banner }

# Process all procedure files
$executed = $false
Get-ChildItem -Path $CommsDir -File |
    ForEach-Object {
        $procName = $_.BaseName
        $trigger  = $_.FullName
        $scriptPs1 = Join-Path $ProcDir "$procName.ps1"
        $scriptBat = Join-Path $ProcDir "$procName.bat"

        if (Test-Path $scriptPs1) {
            try {
                & $scriptPs1
				$executed = $true
            } catch {
                Write-Error "Error executing $scriptPs1 : $_"
            }
            Remove-Item $trigger -Force
        }
        elseif (Test-Path $scriptBat) {
            try {
                & $scriptBat
				$executed = $true
            } catch {
                Write-Error "Error executing $scriptBat : $_"
            }
            Remove-Item $trigger -Force
        }
        else {
            Write-Warning "No matching script for procedure '$procName'"
			Remove-Item $trigger -Force
        }
    }

if (-not $executed) {
    $defaultScript = Join-Path $ProcDir "default.ps1"
    if (Test-Path $defaultScript) {
        & $defaultScript
    }
}
