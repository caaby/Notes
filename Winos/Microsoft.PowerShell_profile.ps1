
Import-Module (Join-Path $PSScriptRoot "aliases.psm1")
Import-Module (Join-Path $PSScriptRoot "prompt.psm1")


if ($null -ne (Get-Module PSReadLine -ListAvailable)) {
    Import-Module PSReadLine
    
    # 编辑模式（ESC Emacs进入命令模式）
      Set-PSReadlineOption -EditMode Windows
      Set-PSReadlineOption -BellStyle None
    
    # 命令预测补全（根据历史记录提示）
    # 老版 Windows PowerShell 可能不支持，报错就注释掉下面两行
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle Inline

    # Tab 键接受自动预测建议
    Set-PSReadLineKeyHandler -Key Tab -Function AcceptSuggestion
    # ========== 快捷键增强（类 Linux Bash 风格） ==========
    Set-PSReadLineKeyHandler -Key   Alt+b           -Function BackwardWord      # 光标跳前一个单词
    Set-PSReadLineKeyHandler -Key   Alt+d           -Function KillWord          # 删后一个单词
    Set-PSReadLineKeyHandler -Key   Alt+f           -Function ForwardWord       # 光标跳后一个单词
    Set-PSReadLineKeyHandler -Key   Ctrl+b          -Function BackwardChar     # 光标左移
    Set-PSReadLineKeyHandler -Key   Ctrl+d          -Function DeleteCharOrExit # 删除字符 / 退出
    Set-PSReadLineKeyHandler -Key   Ctrl+f          -Function ForwardChar      # 光标右移
    Set-PSReadLineKeyHandler -Key   Ctrl+g          -Function Abort            # 取消当前输入
    Set-PSReadLineKeyHandler -Key   Ctrl+n          -Function NextHistory      # 下一条历史
    Set-PSReadLineKeyHandler -Key   Ctrl+p          -Function PreviousHistory  # 上一条历史
    Set-PSReadlineKeyHandler -Chord 'Ctrl+x,Ctrl+e' -Function ViEditVisually    # 用编辑器编辑当前命令
    Set-PSReadlineKeyHandler -Key   Ctrl+Backspace  -Function UnixWordRubout   # Ctrl+Backspace 删除单词
}

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
