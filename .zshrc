##################################################
# 環境変数、シェル変数
##################################################

export LANG=ja_JP.UTF-8
export XMODIFIRES=@im=uim
export GTK_IM_MODULE=uim
export LSCOLORS=gxfxcxdxbxegedabagacad

##################################################
# alias
##################################################

alias ls='ls -G'
alias ks='echo "hello ks"'
alias ll='ls -l'
alias la='ls -la'
alias lg='la | grep'
alias md='mkdir'
alias rd='rmdir'
alias jobs='jobs -l'
 
export PATH=~/bin:$PATH
export EDITOR='s -w'''

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

##################################################
# ローカル設定:~/.zsh_local
##################################################

if [ -e ~/.zsh_local ]; then
. ~/.zsh_local
fi

##################################################
# リモート接続設定
##################################################

if [ -e ~/.zsh.d/.alias_ssh ]; then
. ~/.zsh.d/.alias_ssh
fi

##################################################
# プロンプト設定
##################################################

# color
autoload -U colors; colors

# もしかして…

setopt correct

ip=`~/.zsh.d/os.sh`

# プロンプト設定
# http://qiita.com/kubosho_/items/c200680c26e509a4f41c参照
# というか丸パク(ry

PROMPT="
[%n@%m($ip)] %{${fg[yellow]}%}%~%{${reset_color}%}
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

############################################################
# gitのブランチ情報を右プロンプトに表示
############################################################
function rprompt-git-current-branch {
        local name st color

        if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
                return
        fi
        name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
        if [[ -z $name ]]; then
                return
        fi
        st=`git status 2> /dev/null`
        if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
                color=${fg[green]}
        elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
                color=${fg[yellow]}
        elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
                color=${fg_bold[red]}
        else
                color=${fg[red]}
        fi

        # %{...%} は囲まれた文字列がエスケープシーケンスであることを明示する
        # これをしないと右プロンプトの位置がずれる
        echo "%{$color%}$name%{$reset_color%} "
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

RPROMPT='[`rprompt-git-current-branch`%~]'
