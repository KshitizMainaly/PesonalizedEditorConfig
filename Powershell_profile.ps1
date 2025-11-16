# ===============================
# PowerShell Profile - OPTIMIZED
# Fast loading with custom prompt
# ===============================

# ---------- FAST ZOXIDE ----------
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    $zoxideCache = "$env:TEMP\zoxide-init.ps1"
    if (!(Test-Path $zoxideCache)) {
        zoxide init powershell --hook pwd | Out-File $zoxideCache
    }
    . $zoxideCache
}

# ---------- SIMPLE FAST PROMPT ----------
function prompt {
    # OSC7 for WezTerm directory tracking
    $pwd = (Get-Location).ProviderPath -replace '\\', '/'
    $esc = [char]27
    $uri = [Uri]::EscapeDataString($pwd)
    Write-Host "${esc}]7;file://$([System.Net.Dns]::GetHostName())/$uri${esc}\" -NoNewline
    
    # Simple colored prompt: username + directory + git branch
    $user = $env:USERNAME
    $path = (Get-Location).Path.Replace($HOME, "~")
    
    # Try to get git branch
    $gitBranch = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git branch --show-current 2>$null
        if ($branch) {
            $gitBranch = " on $([char]0x1b)[35m $branch$([char]0x1b)[0m"
        }
    }
    
    # Build prompt: username in color + path + git branch
    Write-Host "$([char]0x1b)[36m$user$([char]0x1b)[0m in $([char]0x1b)[34m$path$([char]0x1b)[0m$gitBranch" -NoNewline
    return "`n$([char]0x276F) "
}

# ---------- ALIASES ----------
function ll { Get-ChildItem | Select-Object -ExpandProperty Name }
function lz { lazygit }
function yz { yazi }
function wrn { wezterm cli rename-workspace $args }

# ---------- PSReadLine ----------
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineKeyHandler -Key Tab -Function Complete

# ---------- UTILITY FUNCTIONS ----------
# Reload profile
function Reload-Profile {
    . $PROFILE
    Write-Host "✓ Profile reloaded!" -ForegroundColor Green
}

# Clear cache if needed
function Clear-ProfileCache {
    Remove-Item "$env:TEMP\zoxide-init.ps1" -ErrorAction SilentlyContinue
    Write-Host "✓ Profile cache cleared! Restart PowerShell." -ForegroundColor Green
}

# Create alias after function is defined
Set-Alias -Name reload -Value Reload-Profile
