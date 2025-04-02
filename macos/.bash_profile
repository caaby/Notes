# 设置环境变量
function setup_export_env() {
    export CLICOLOR=1                          # 启用终端颜色显示
    export LSCOLORS=ExGxFxdaCxDaDahbadeche     # 设置 ls 命令的颜色配置
    export BASH_SILENCE_DEPRECATION_WARNING=1  # 关闭 macOS Bash 过时警告
    
}

# 获取当前 Git 分支（如果存在）
function get_git_branch() {
    local branch
    # 尝试获取当前 Git 分支，若失败则返回空字符串
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    # 如果分支存在，则返回分支名称
    [ -n "$branch" ] && echo "($branch)"
}

# 更新 PS1 提示符
function setup_ps1() {
    # 定义颜色变量
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local CYAN='\033[0;36m'
    local DEFAULT='\033[0m'

    # 如果当前目录是 Git 仓库内
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        # 在 Git 仓库中，显示 Git 用户、工作目录和 Git 分支
        export PS1="${GREEN}\u@${YELLOW}\w${CYAN}$(get_git_branch)${DEFAULT}\n\$ "
    else
        # 不在 Git 仓库中，显示主机名、工作目录
        export PS1="${GREEN}\u@$(ipconfig getifaddr en0)${YELLOW}\w${CYAN}${DEFAULT}\n\$ "
    fi
}

# 改进的 cd 命令，进入目录时自动更新 PS1
cd() {
    # 执行默认的 cd 命令
    builtin cd "$@"  
    # 进入新的目录时，自动更新提示符
    setup_ps1
}

# 配置 Homebrew 环境变量并加载相关设置
function setup_homebrew() {
    # 判断 Homebrew 是否已安装
    if command -v brew &>/dev/null; then
        echo "检测到 Homebrew，开始配置环境变量... ✅"

        # 设置 Homebrew 的 GitHub API 访问令牌（请勿在公开环境中存储敏感信息）
        export HOMEBREW_GITHUB_API_TOKEN="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"
        
        # 配置 Homebrew 使用阿里云镜像加速下载
        export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew-bottles"

        # 加载 Homebrew 的 shell 环境变量
        eval "$(/usr/local/Homebrew/bin/brew shellenv)"

        # macOS 下加载 Bash 自动补全（如果存在）
        if [[ "$(uname)" == "Darwin" ]]; then
            local brew_completion
            brew_completion="$(brew --prefix)/etc/bash_completion"

            if [[ -f "$brew_completion" ]]; then
                source "$brew_completion"
            fi
        fi
    fi
}


# 设置环境变量，优化 PATH 变量
function setup_env() {
    # 需要添加到 PATH 的目录列表
    local extra_paths=(
        "/usr/local/sbin"                 # 系统 sbin 目录，某些工具需要
        "$HOME/.cargo/bin"                 # Rust Cargo 安装的可执行文件目录
        "$HOME/Library/Python/3.9/bin"     # Python 3.9 的用户安装脚本目录
    )

    # 遍历路径列表，逐个添加到 PATH 中，避免重复
    for path in "${extra_paths[@]}"; do
        # 确保路径存在且未添加到 PATH 变量中
        [[ -d "$path" && ":$PATH:" != *":$path:"* ]] && PATH="$path:$PATH"
    done
    export PATH  # 更新环境变量
}

# 加载 PyCharm 配置的虚拟机选项
load_pycharm_vmoptions() {
    local vmoptions_file="${HOME}/.jetbrains.vmoptions.sh"
    
    # 如果文件存在，加载它
    if [ -f "${vmoptions_file}" ]; then
        . "${vmoptions_file}"
    fi
}

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

setup_export_env
setup_env
setup_ps1
setup_homebrew
# 调用函数加载 PyCharm 虚拟机选项
load_pycharm_vmoptions
