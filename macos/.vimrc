" 基础设置
" ========================
set number                " 显示行号
" set relativenumber        " 显示相对行号
set cursorline            " 高亮当前行
set expandtab             " 用空格代替 Tab
set tabstop=4             " Tab 长度为 4
set shiftwidth=4          " 缩进宽度为 4
set autoindent            " 自动缩进
set smartindent           " 智能缩进
set encoding=utf-8        " 使用 UTF-8 编码
set clipboard=unnamedplus " 使用系统剪贴板
set laststatus=2          " 始终显示状态栏
set helplang=cn           " 帮助系统设置为中文

" 搜索设置
" ========================
set ignorecase            " 搜索时忽略大小写
set smartcase             " 如果搜索包含大写字母，则区分大小写
set incsearch             " 实时高亮搜索结果
set hlsearch              " 高亮搜索结果
set wrap                  " 允许长行自动换行

" 高效操作设置
" ========================
set wildmenu              " 增强命令补全
set wildmode=list:longest " 增强命令补全模式
set showcmd               " 显示输入的命令
set showmatch             " 显示匹配括号

syntax on

" 快捷键设置
" ========================
nnoremap <C-s> :w<CR>     " Ctrl+S 保存
nnoremap <C-q> :q<CR>     " Ctrl+Q 退出
nnoremap <C-c> :nohlsearch<CR> " Ctrl+C 取消搜索高亮
nnoremap <C-f> :Files<CR>  " 调用 fzf 搜索文件
nnoremap <C-t> :NERDTreeToggle<CR> " 切换文件树
