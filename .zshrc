##################################
# Keybind
##################################
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey -v                  # vi-mode
bindkey -M vicmd "^R" redo  # redu by "Ctrl-R" when normal mode.
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

setopt list_packed          # Make the completion list smaller.
setopt listtypes            # Show type of each file when completion.
setopt nolistbeep           # No beep for completion.
setopt printeightbit        # Print eight bit characters.

##################################
# Change directory
##################################
cdpath=(~ ..)               # Search path for the cd command.
setopt auto_cd              # Go to directory without 'cd' command.
setopt auto_pushd           # Push directory onto the directory stack.
setopt pushd_ignore_dups    # Remove duplicates from the directory stack.

##################################
# Other setopt
##################################
setopt correct              # Correct the speeling of commands.
setopt nohup                # Not send the HUP signal to running jobs when the shell exits.
setopt aliases              # Expand aliases.

setopt histignorealldups    # Remove the older duplicate command from the history list.
setopt histignoredups       # Do not enter command lines into the history list if they are duplicates of the previous event.
setopt histignorespace      # Don't register commands starts with a space to the history list.
setopt histreduceblanks     # Remove superfluous blanks from each command line being added to the history list.
setopt share_history        # Share the command history with another shells.
setopt ignoreeof            # Do not exit on end-of-file.
setopt extendedglob         # Enable extended glob
                            #   not:    ^PATTERN
                            #   exclude PATTERN~EXCLUDE
setopt printexitvalue       # Print exit status when a command failed.
setopt nonomatch            # Same behavior as bash when there is no match with "*" (do not make an error) 

#setopt SH_WORD_SPLIT       # Handle whitespace in the same way as in bash (allow splitting by for statement)

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

##################################
# source setting files
##################################
export SHELL=$(command -v zsh)
source $HOME/.zshrc_bashrc
alias ss='source $HOME/.zshrc'
source_if $HOME/.fzf.zsh
source_if $HOME/.git-completion.bash
source_if $HOME/.makers-completion.bash
source_if $HOME/.zshrc_bashrc.private
source_if $HOME/.zshrc.private

if [ -n "$(command -v set_tmux_pane_pwd.sh)" ];then
    set_tmux_pane_pwd () { set_tmux_pane_pwd.sh }
    precmd_functions+=(set_tmux_pane_pwd)
fi
if [ -n "$(command -v starship)" ];then
    eval "$(starship init zsh)"
    starship_zle-keymap-select-wrapped () { }
fi

