# 设置 PowerShell 使用 UTF-8 编码
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Import-Module "$PSScriptRoot\aliases.psm1" -Force
Import-Module "$PSScriptRoot\prompt.psm1" -Force
${function:prompt} = $function:gitFancyPrompt

# 远程判定
$IsRemote = [bool]($env:SSH_CLIENT -or $env:SSH_CONNECTION -or $env:SSH_TTY)

# 本地终端启用图标，SSH 远程不加载
if (-not $IsRemote -and (Get-Module -ListAvailable Terminal-Icons)) {
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
}

if ($null -ne (Get-Module PSReadLine -ListAvailable)) {
    Import-Module PSReadLine
    
    # 启用 Vim 编辑模式（ESC 进入命令模式）
      Set-PSReadlineOption -EditMode vi
      Set-PSReadlineOption -BellStyle None
    
    # 命令预测补全（根据历史记录提示）
    # 老版 Windows PowerShell 可能不支持，报错就注释掉下面两行
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle Inline

    # Tab 键接受自动预测建议
    Set-PSReadLineKeyHandler -Key Tab -Function AcceptSuggestion
    
    # 历史记录设置
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd  # 搜索历史时光标跳到最后
    Set-PSReadLineOption -HistorySaveStyle SaveIncrementally  # 实时保存历史
    Set-PSReadLineOption -MaximumHistoryCount 1000  # 最大历史记录数
    Set-PSReadLineOption -HistoryNoDuplicates  # 不保存重复历史
    
    # 上下箭头 = 搜索历史命令
    # Set-PSReadlineKeyHandler -Key   UpArrow         -Function HistorySearchBackward
    # Set-PSReadlineKeyHandler -Key   DownArrow       -Function HistorySearchForward
    
    # Tab = 普通补全
    # Set-PSReadlineKeyHandler -Key Tab -Function Complete
    
    # Shift+Tab = 反向补全
    # Set-PSReadlineKeyHandler -Chord Shift+Tab -Function MenuComplete
    
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
