############################################################################################
# 一般設定
############################################################################################

#-------------------------------------------------------------------------------------------
# 環境変数など
#-------------------------------------------------------------------------------------------

export LANG=ja_JP.UTF-8
export XMODIFIRES=@im=uim
export GTK_IM_MODULE=uim
export LSCOLORS=gxfxcxdxbxegedabagacad
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=emacs

bindkey -e                # キーバインドをEmacsモード
setopt no_beep            # ビープ音なし


############################################################################################
# history
############################################################################################

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# 重複したコマンドラインはヒストリに追加しない
setopt hist_ignore_all_dups
# 履歴の共有
setopt share_history
# ヒストリにhistoryコマンドを記録しない
setopt hist_no_store
# 余分なスペースを削除してヒストリに記録する
setopt hist_reduce_blanks
# 履歴ファイルに時刻を記録
setopt extended_history
# 履歴をインクリメンタルに追加
setopt inc_append_history
# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
autoload history-search-end
# 履歴検索機能のショートカット
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

############################################################################################
# 補完
############################################################################################

# init asdf
if [ -e ~/.asdf ]; then
  . $HOME/.asdf/asdf.sh
  fpath=($HOME/.asdf/completions $fpath)
fi

# 補完
autoload -U compinit
compinit
# 予測機能
# autoload predict-on
# predict-on
# cdのタイミングで自動的にpushd
setopt auto_pushd
# 補完時にスペルチェックをする
#setopt auto_correct
# 自動修正
setopt correct
setopt correct_all
# 補完時にヒストリを自動的に展開する
setopt hist_expand
# 補完候補一覧でファイルの種別を識別マーク表示
setopt list_types
# 補完候補が複数ある時に、一覧表示
setopt auto_list
# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完
setopt auto_menu
# 補完結果をできるだけ詰める
setopt list_packed
# カッコの対応などを自動的に補完
setopt auto_param_keys
# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs
# ディレクトリ名だけで､ディレクトリの移動をする
setopt auto_cd
# 補完の時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補表示時にビープ音を鳴らさない
setopt nolistbeep

######################################################################################################
# utility functions
######################################################################################################

function is_linux {
    if [ `uname` = "Darwin" ]
    then
        false
    elif [ `uname` = "Linux" ]
    then
        true
    fi
}

# ssh host complement
function _ssh {
    if is_linux
    then
        compadd `grep -rh '^Host ' ~/.ssh/conf* | grep -v '*' | awk '{print $2}' | sort`
    else
        compadd `ggrep -rh '^Host ' ~/.ssh/conf* | ggrep -v '*' | awk '{print $2}' | sort`
    fi
}

############################################################################################
# alias
############################################################################################

if is_linux
then
    alias ls='ls -F --color'
else
    alias ls='ls -FG'
fi

alias ks='echo "hello ks"'
alias ll='ls -l'
alias la='ls -la'
alias lg='la | grep'
alias md='mkdir'
alias rd='rmdir'
alias jobs='jobs -l'
alias ec='emacsclient'
alias tmux='tmux -2'
alias emacs='emacs -nw'
alias ta='tmux a'
alias tn='tmux new -s'
alias be='bundle exec'

if [ -e /usr/local/bin/colordiff ]; then
    alias diff='colordiff -u'
fi

export PATH=/usr/local/bin:$PATH:~/bin

############################################################################################
# Go
############################################################################################

function peco-history () {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}

if [ -x "`which go`"  ] ; then
    export GOROOT=`go env GOROOT`
    export GOPATH=${HOME}/lib/golang
    export PATH=${GOROOT}/bin:${GOPATH}/bin:${PATH}

    if [ -x `which ghq` -a -x `which peco` ]; then
        alias repo='cd $(ghq list -p | peco)'
        zle -N peco-history
        bindkey '^r' peco-history
    fi
fi

######################################################################################################
# gitのブランチ情報を右プロンプトに表示
######################################################################################################
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
        zstyle ':vcs_info:git:*' check-for-changes true
        zstyle ':vcs_info:git:*' stagedstr "+"
        zstyle ':vcs_info:git:*' unstagedstr "-"
        zstyle ':vcs_info:git:*' formats '%b[%c%u]'
        zstyle ':vcs_info:git:*' actionformats '[%b|%a[%c%u]]'
fi

function _update_vcs_info_msg() {
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg

############################################################################################
# プロンプト設定
############################################################################################

# color
autoload -U colors; colors

# もしかして…

setopt correct

ip=`~/.zsh.d/os.sh`

# プロンプト設定
# http://qiita.com/kubosho_/items/c200680c26e509a4f41c参照
# というか丸パク(ry

PROMPT="
[%n@%m($ip)] %{${fg[yellow]}%}%~%{${reset_color}%} %1(v|%F{green}%1v%f|)
%(?.%{$fg[green]%}.%{$fg[blue]%})%(?!(*'-') <!(*;-;%)? <)%{${reset_color}%} "
# プロンプト指定(コマンドの続き)
PROMPT2='[%n]> '

# もしかして時のプロンプト指定
SPROMPT="%{$fg[red]%}%{$suggest%}(*'~'%)? < もしかして %B%r%b %{$fg[red]%}かな? [そう!(y), 違う!(n),a,e]:${reset_color} "

if [ ${UID} -eq 0 ]; then
  tmp_prompt="%B%U${tmp_prompt}%u%b"
  tmp_prompt2="%B%U${tmp_prompt2}%u%b"
  tmp_rprompt="%B%U${tmp_rprompt}%u%b"
  tmp_sprompt="%B%U${tmp_sprompt}%u%b"
fi

#TRAPALRM () { zle reset-prompt}
#TMOUT=60

######################################################################################################
# gitのブランチ情報を右プロンプトに表示
######################################################################################################

if [ -f ~/.zsh.d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh.d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

######################################################################################################
# gitignore.io API
######################################################################################################

function gi() {
    curl -L -s https://www.gitignore.io/api/$@ ;
}

######################################################################################################
# load external modules
######################################################################################################

# init rbenv
if [ -e ~/.rbenv ]; then
    export PATH=~/.rbenv/bin:$PATH && eval "$(rbenv init -)"
    alias re='rbenv exec'
fi

# init nvm
if [ -e ~/.nvm ]; then
    export NVM_DIR=~/.nvm
    source $(brew --prefix nvm)/nvm.sh
fi

# load kubernetes completion
if [ -x "`which kubectl`"  ] ; then
    source <(kubectl completion zsh)
fi

# load minikube completion
# load kubernetes completion
if [ -x "`which minikube`"  ] ; then
    source <(minikube completion zsh)
fi

if [ -x "`which op`" ]; then
    eval "$(op completion zsh)"; compdef _op op
fi
############################################################################################
# ローカル設定:~/.zsh_local
############################################################################################

if [ -e ~/.zsh_local ]; then
    . ~/.zsh_local
fi

if ! is_linux; then
    eval $(/opt/homebrew/bin/brew shellenv)
fi
