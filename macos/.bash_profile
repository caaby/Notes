# 设置环境变量
setup_export_env() {
    export CLICOLOR=1                          # 启用终端颜色显示
    export LSCOLORS=ExGxFxdaCxDaDahbadeche     # 设置 ls 命令的颜色配置
    export BASH_SILENCE_DEPRECATION_WARNING=1  # 关闭 macOS Bash 过时警告
    export PYTHONDONTWRITEBYTECODE=1
}

# 显示虚拟环境名称（如果存在）
get_venv() {
    [[ -n "$VIRTUAL_ENV" ]] && echo "($(basename "$VIRTUAL_ENV")) "
}

# 获取当前 Git 分支（如果存在）
get_git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [[ -n "$branch" ]] && echo "($branch)"
}

# 更新 PS1 提示符（venv 放最前，保留 IP 逻辑）
setup_ps1() {
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local CYAN='\033[0;36m'
    local DEFAULT='\033[0m'

    local venv="$(get_venv)"
    local git_branch="$(get_git_branch)"

    if git rev-parse --is-inside-work-tree &>/dev/null; then
        # Git 仓库中
        export PS1="${CYAN}${venv}${GREEN}\u@${YELLOW}\w ${CYAN}${git_branch}${DEFAULT}\n\$ "
    else
        # 非 Git 仓库中
        local ip="$(ipconfig getifaddr en0 2>/dev/null || echo 'no-ip')"
        export PS1="${CYAN}${venv}${GREEN}\u@${ip}${YELLOW}\w ${DEFAULT}\n\$ "
    fi
}


# 配置 Homebrew 环境变量并加载相关设置
setup_homebrew() {
    # 判断 Homebrew 是否已安装
    if command -v brew &>/dev/null; then
        # 设置 Homebrew 的 GitHub API 访问令牌（请勿在公开环境中存储敏感信息）
        export HOMEBREW_GITHUB_API_TOKEN="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"
        # 替换 bottle 下载地址
        export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew-bottles
        
        export HOMEBREW_NO_ENV_HINTS=1
 
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
setup_env() {
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
proxy_off(){
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "已关闭代理"
}

proxy_on() {
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    export http_proxy="http://127.0.0.1:7890"
    export https_proxy=$http_proxy
    export all_proxy="socks5://127.0.0.1:7890"
    echo -e "已开启代理"
}

setup_orbstack() {
    [[ -f ~/.orbstack/shell/init.bash ]] && source ~/.orbstack/shell/init.bash
}

setup_pyenv() {
    if command -v pyenv &>/dev/null; then
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
    fi
}

setup_export_env
setup_env
setup_ps1
setup_homebrew
setup_pyenv
# 让每次显示提示符前都调用 setup_ps1
PROMPT_COMMAND=setup_ps1

# 调用函数加载 PyCharm 虚拟机选项
load_pycharm_vmoptions
