if [[ $- == *i* ]];then
    stty stop undef
    stty erase ^H
fi
shopt -s direxpand
shopt -s expand_aliases
set -o vi

bind '"\C-n": history-search-forward'
bind '"\C-p": history-search-backward'

# Select completion by TAB.
#bind 'set show-all-if-ambiguous on'
#bind 'TAB:menu-complete'

# F6: git status
# F7: make
# F8: makers
# F9: change worktree by fzf
bind  '"\e[17~":"git status\n"'
bind  '"\e[18~":"make\n"'
bind  '"\e[19~":"makers\n"'
bind  '"\e[20~":"fcdworktree\n"'

export SHELL=$(which bash)
source $HOME/.zshrc_bashrc
alias ss='source $HOME/.bashrc'
source_if $HOME/.fzf.bash
source_if $HOME/.git-completion.bash
source_if $HOME/.makers-completion.bash
source_if $HOME/.zshrc_bashrc.private
source_if $HOME/.bashrc.private

########################################## starship
if [ -n "$(command -v set_tmux_pane_pwd.sh)" ];then
    starship_precmd_user_func="set_tmux_pane_pwd.sh"
fi
if [ -n "$(command -v starship)" ];then
    eval "$(starship init bash)"
fi
