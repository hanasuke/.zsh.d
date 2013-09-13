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
alias gcc='gcc-mp-4.8'

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
PROMPT="
[%n@%m($ip)] %{${fg[yellow]}%}%~%{${reset_color}%}
%(?.%{$fg[green]%}.%{$fg[blue]%})%(?!ζ*'ヮ'%)ζ <! ζ*;ヮ;%)ζ <)%{${reset_color}%} "

SPROMPT="%{$fg[red]%}%{$suggest%}ζ*'ヮ'%)ζ? < もしかして %B%r%b %{$fg[red]%}ですか? [うっう〜!(y), うっう〜!(n),a,e]:${reset_color} "

if [ ${UID} -eq 0 ]; then
  tmp_prompt="%B%U${tmp_prompt}%u%b"
  tmp_prompt2="%B%U${tmp_prompt2}%u%b"
  tmp_rprompt="%B%U${tmp_rprompt}%u%b"
  tmp_sprompt="%B%U${tmp_sprompt}%u%b"
fi
