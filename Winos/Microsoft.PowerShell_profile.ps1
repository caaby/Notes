# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-Module (Join-Path $PSScriptRoot "aliases.psm1")
Import-Module (Join-Path $PSScriptRoot "prompt.psm1")
Import-Module PSReadLine
Import-Module DirColors

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView # ListView
Set-PSReadLineOption -EditMode vi
Set-PSReadlineOption -BellStyle None

Set-PSReadLineKeyHandler -Key "Ctrl+a" -Function BeginningOfLine -ViMode Insert  # 光标移动到行首
Set-PSReadLineKeyHandler -Key "Ctrl+e" -Function EndOfLine -ViMode Insert        # 光标移动到行尾
Set-PSReadLineKeyHandler -Key "Ctrl+b" -Function BackwardChar -ViMode Insert     # 光标左移
Set-PSReadLineKeyHandler -Key "Ctrl+f" -Function ForwardChar -ViMode Insert      # 光标右移
Set-PSReadLineKeyHandler -Key "Ctrl+k" -Function ForwardDeleteLine -ViMode Insert # 删除光标后所有字符
Set-PSReadLineKeyHandler -Key "Ctrl+w" -Function BackwardKillWord -ViMode Insert  # 删除光标前的一个单词
# Set-PSReadLineKeyHandler -Key "Ctrl+u" -Function BackwardDeleteLine -ViMode Insert  # 删除光标前的所有字符

Set-PSReadLineKeyHandler -Key Escape -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()
} -ViMode Insert

# Invoke-Expression (& {
#     $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
#     (zoxide init --hook $hook powershell --cmd j) -join "`n"
# })

function unzip {
    param($zipfile)
    Expand-Archive $zipfile -DestinationPath .
}

function proxy {
    $env:http_proxy = "http://127.0.0.1:7890"
    $env:https_proxy = "http://127.0.0.1:7890"
    [System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy("http://127.0.0.1:7890")
    Write-Host "Proxy enabled: http://127.0.0.1:7890" -ForegroundColor Green
}

function unproxy {
    $env:http_proxy = $null
    $env:https_proxy = $null
    [System.Net.WebRequest]::DefaultWebProxy = $null
    Write-Host "Proxy disabled" -ForegroundColor Yellow
}

function check-proxy {
    if ($env:http_proxy -or $env:https_proxy) {
        Write-Host "Current proxy settings:" -ForegroundColor Cyan
        Write-Host "HTTP Proxy: $env:http_proxy"
        Write-Host "HTTPS Proxy: $env:https_proxy"
    } else {
        Write-Host "No proxy is currently set." -ForegroundColor Cyan
    }
}
