export SHELL=$(which zsh)
source $HOME/.zshrc_bashrc
alias ss='source $HOME/.zshrc'
source_if $HOME/.zshrc_bashrc.private
source_if ~/.fzf.zsh

# F6: git status
# F7: make
# F8: makers
# F9: change worktree by fzf
bindkey -s '^[[17~' '^ugit status^M'
bindkey -s '^[[18~' '^umake^M'
bindkey -s '^[[19~' '^umakers^M'
bindkey -s '^[[20~' '^ufcdworktree^M'

##########################################

#   Prompt design
autoload -U colors
colors

case ${UID} in
0)
    #RPROMPT="%{[31m%}[%W %T]%{[m%} "
    PROMPT="%B%{[31m%}[%!]%%%{[m%}%b "
    PROMPT="%B%{[31m%}%C#%{[m%}%b $PROMPT"
    PROMPT2="%B%{[31m%}%_#%{[m%}%b "
    SPRMPT="%B%{[31m%}%r is correct? [n,y,a,e]:%{[m%}%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="%{[31m%}${HOST%%.*} ${PROMPT}";;
*)
	c=32 # Green
	c=33 # Yellow
	c=34 # Blue
	c=0
    #RPROMPT="%{[${c}m%}[%W %T]%{[m%} "
    PROMPT="%{[${c}m%}%C%{[m%} "
    PROMPT="%{[${c}m%}%C$%{[m%} "
    PROMPT2="%{[${c}m%}%_%%%{[m%} "
    SPROMPT="%{[${c}m%}%r is correct? [n,y,a,e]:%{[m%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="%{[${c}m%}${HOST%%.*}:${PROMPT}";;
esac

setopt transient_rprompt # When input comes to the right prompt, turn it off.


#   Terminal name
case "${TERM}" in
kterm*|xterm|vt100-w)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    };;
esac

# Color config
unset LSCOLORS
case "${TERM}" in
xterm|xterm-color)
  export TERM=xterm-256color
  ;;
kterm)
  export TERM=kterm-color
  # set BackSpace control character
  stty erase
  ;;
cons25)
  unset LANG
  export LSCOLORS=ExFxCxdxBxegedabagacad
  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34'
  zstyle ':completion:*' list-colors \
    'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
  ;;
esac

case "${TERM}" in
kterm*|xterm*|vt100-w)
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=30:ln=32:so=32:pi=33:ex=31:bd=46;34:cd=43;34'
    export LS_COLORS='di=35:ln=32:so=32:pi=33:ex=31:bd=46;34:cd=43;34'
    zstyle ':completion:*' list-colors 'di=35' 'ln=32' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
cons25)
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;35:ln=01;32:so=01;32:ex=01;31:bd=46;34:cd=43;34'
    zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac


# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history


# Keybind
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey -v
bindkey -M vicmd "^R" redo
bindkey -M vicmd "u" undo

# Completion
fpath=(~/zsh/function/ ${fpath})
autoload -U compinit
compinit -u
#autoload predict-on
#predict-on
zstyle ':completion:*' matcher-list 'm:{-a-z}={_A-Z}'
zstyle ':completion:*:default' menu select=1



# Other setopt
setopt auto_cd
setopt auto_pushd
setopt correct
setopt list_packed
setopt nolistbeep
setopt nohup
setopt ALIASES

#setopt autolist
setopt listtypes
setopt automenu
#setopt histverify
setopt histignorealldups
setopt histignorespace
setopt histreduceblanks
setopt ignoreeof
#setopt autopushd pushd_ignore_dups
setopt pushd_ignore_dups
setopt extendedglob
setopt autoresume
setopt printeightbit
setopt printexitvalue

# Same behavior as bash when there is no match with "*" (do not make an error) 
setopt nonomatch

# Handle whitespace in the same way as in bash (allow splitting by for statement)
#setopt SH_WORD_SPLIT

#########################
# change directly path  #
#########################
cdpath=(~ ..)

# for git
autoload bashcompinit
bashcompinit
source_if $HOME/.git-completion.bash

# cargo make
#autoload -U +X compinit && compinit
#autoload -U +X bashcompinit && bashcompinit
source_if $HOME/.makers-completion.bash

########################################## starship
if [ -n "$(command -v set_tmux_pane_pwd.sh)" ];then
    set_tmux_pane_pwd () { set_tmux_pane_pwd.sh }
    precmd_functions+=(set_tmux_pane_pwd)
fi
if [ -n "$(command -v starship)" ];then
    eval "$(starship init zsh)"
    starship_zle-keymap-select-wrapped () { }
fi

source_if $HOME/.zshrc.private

#############################################
# Trouble shooting
#############################################
# * Fix tab completion.
#   rm ~/.zcompdump
#   exec $SHELL -l
#
