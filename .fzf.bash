source ~/.fzf.common

# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.bash"

# open fzf-suggestion command
__fzf_suggestion__() {
    ## Save the tty settings and restore them on exit.
    SAVED_TERM_SETTINGS="$(stty -g)"
    
    # Force the tty (back) into canonical line-reading mode.
    stty cooked echo

    # fzf-suggestion
    local output
    output=$(FZF_SUGGESTION_SIMPLE=1 fzf-suggestion)
    if [ "$output" == "" ];then
        stty $SAVED_TERM_SETTINGS
        return
    fi

    # put stdout on the command line
    READLINE_LINE=${output#*$'\t'}
    if [ -z "$READLINE_POINT" ]; then
      echo "$READLINE_LINE"
    else
      READLINE_POINT=0x7fffffff
    fi

    stty $SAVED_TERM_SETTINGS
}

if [[ $- == *i* ]];then
    bind -m emacs-standard -x '"\C-o": __fzf_suggestion__'
    bind -m vi-command -x '"\C-o": __fzf_suggestion__'
    bind -m vi-insert -x '"\C-o": __fzf_suggestion__'
fi

