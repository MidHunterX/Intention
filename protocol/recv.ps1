$Protocol = "xoscrp"
# $CommsDir = Join-Path $env:SystemDrive ".${Protocol}"
$CommsDir = "X:\.${Protocol}"
$ProcDir  = Join-Path $PSScriptRoot "procedures"

# Ensure comms + procedure dirs
if (!(Test-Path $CommsDir))  { New-Item -ItemType Directory -Path $CommsDir | Out-Null }
if (!(Test-Path $ProcDir))   { New-Item -ItemType Directory -Path $ProcDir  | Out-Null }

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