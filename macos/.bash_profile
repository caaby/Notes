# 启用终端颜色显示
export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadeche
# export LSCOLORS=gxfxcxdxbxegedabagacad

# 定义颜色
DEFAULT="\[\033[0;00m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
CYAN="\[\033[0;36m\]"


# 获取 Git 分支
get_git_branch() {
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [ -n "$branch" ] && echo "($branch)"
}

update_ps1() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        # 在 Git 仓库中，显示 Git 分支
        export PS1="${GREEN}\u@${YELLOW}\w${CYAN}$(get_git_branch)${DEFAULT}\n\$ "
    else
        # 不在 Git 仓库中，显示 IP
        export PS1="${GREEN}\u@$(ipconfig getifaddr en0)${YELLOW}\w${CYAN}${DEFAULT}\n\$ "
    fi
}
# 每次进入新的目录时，更新 PS1
cd() {
    builtin cd "$@"  # 执行默认的 cd 命令
    update_ps1        # 更新提示符
}

# 初始化时更新提示符
update_ps1

# 设置代理功能
function proxy_off(){
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "已关闭代理"
}

function proxy_on() {
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    export http_proxy="http://127.0.0.1:7890"
    export https_proxy=$http_proxy
    export all_proxy="socks5://127.0.0.1:7890"
    echo -e "已开启代理"
}

# 判断 Homebrew 是否安装
if command -v brew &>/dev/null; then
    # 设置环境变量
    export HOMEBREW_GITHUB_API_TOKEN=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
    export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew-bottles
    # 执行 Homebrew 的 shell 环境设置
    eval $(/usr/local/Homebrew/bin/brew shellenv)

    # 如果 bash 自动补全文件存在并可读取，加载它
    # - Mac OS X (homebrew).
    if [ "$(uname)" == "Darwin" ]; then
      if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
      fi
    fi 
else
    echo "Homebrew is not installed."
fi

# pycharm
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"
if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then
    . "${___MY_VMOPTIONS_SHELL_FILE}"
fi


# Enable color output for grep
alias grep='grep --color=always'

# Suppress BASH deprecation warnings
export BASH_SILENCE_DEPRECATION_WARNING=1

# Add /usr/local/sbin to PATH
export PATH="/usr/local/sbin:$PATH"

# Add Cargo's bin directory to PATH
export PATH="/Users/Hmily/.cargo/bin:$PATH"

export PATH="/Users/Hmily/Library/Python/3.9/bin:$PATH"

