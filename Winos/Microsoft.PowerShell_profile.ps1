# 设置 PowerShell 使用 UTF-8 编码
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$scriptDir = Split-Path -PaTh $MyInvocation.MyCommand.Definition -Parent

import-module $scriptDir\prompt.psm1
function prompt {
  gitFancyPrompt
}

Import-Module PSReadLine
Set-PSReadLineOption -EditMode vi

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle Inline
Set-PSReadLineKeyHandler -Key Tab -Function AcceptSuggestion

Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 4000
Set-PSReadLineOption -HistoryNoDuplicates

# history substring search
Set-PSReadlineKeyHandler -Key   UpArrow         -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key   DownArrow       -Function HistorySearchForward

# Tab = 正常补全
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# Shift+Tab = 反向补全
Set-PSReadlineKeyHandler -Chord Shift+Tab -Function MenuComplete

# 右方向键 = 接受预测（Linux标准！）
Set-PSReadLineKeyHandler -Key RightArrow -Function AcceptSuggestion

Set-PSReadLineKeyHandler -Key   Alt+Backspace   -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key   Alt+b           -Function BackwardWord
Set-PSReadLineKeyHandler -Key   Alt+d           -Function KillWord
Set-PSReadLineKeyHandler -Key   Alt+f           -Function ForwardWord
Set-PSReadLineKeyHandler -Key   Ctrl+a          -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key   Ctrl+b          -Function BackwardChar
Set-PSReadLineKeyHandler -Key   Ctrl+d          -Function DeleteCharOrExit
Set-PSReadLineKeyHandler -Key   Ctrl+e          -Function EndOfLine
Set-PSReadLineKeyHandler -Key   Ctrl+f          -Function ForwardChar
Set-PSReadLineKeyHandler -Key   Ctrl+g          -Function Abort
Set-PSReadLineKeyHandler -Key   Ctrl+n          -Function NextHistory
Set-PSReadLineKeyHandler -Key   Ctrl+p          -Function PreviousHistory
Set-PSReadLineKeyHandler -Key   Ctrl+w          -Function BackwardKillWord
Set-PSReadlineKeyHandler -Chord 'Ctrl+x,Ctrl+e' -Function ViEditVisually
Set-PSReadlineKeyHandler -Key   Ctrl+Backspace  -Function UnixWordRubout

function unzip {
    param($zipfile)
    Expand-Archive $zipfile -DestinationPath .
}

###############################################################################


# if (Get-Command starship -ErrorAction SilentlyContinue) {
#     Invoke-Expression (&starship init powershell)
# }

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
