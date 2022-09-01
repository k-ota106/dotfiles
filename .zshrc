##################################
# Keybind
##################################
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey -v
bindkey -M vicmd "^R" redo
bindkey -M vicmd "u" undo

# F6: git status
# F7: make
# F8: makers
# F9: change worktree by fzf
bindkey -s '^[[17~' '^ugit status^M'
bindkey -s '^[[18~' '^umake^M'
bindkey -s '^[[19~' '^umakers^M'
bindkey -s '^[[20~' '^ufcdworktree^M'

##################################
# Completion
##################################
fpath=(~/zsh/function/ ${fpath})
autoload -U compinit
compinit -u
autoload bashcompinit
bashcompinit
zstyle ':completion:*' matcher-list 'm:{-a-z}={_A-Z}'
zstyle ':completion:*:default' menu select=1

##################################
# change directly path
##################################
cdpath=(~ ..)

##################################
# Other setopt
##################################
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

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history

##################################
# source setting files
##################################
export SHELL=$(which zsh)
source $HOME/.zshrc_bashrc
alias ss='source $HOME/.zshrc'
source_if $HOME/.fzf.zsh
source_if $HOME/.git-completion.bash
source_if $HOME/.makers-completion.bash
source_if $HOME/.zshrc_bashrc.private
source_if $HOME/.zshrc.private

##################################
# starship
##################################
if [ -n "$(command -v set_tmux_pane_pwd.sh)" ];then
    set_tmux_pane_pwd () { set_tmux_pane_pwd.sh }
    precmd_functions+=(set_tmux_pane_pwd)
fi
if [ -n "$(command -v starship)" ];then
    eval "$(starship init zsh)"
    starship_zle-keymap-select-wrapped () { }
fi

