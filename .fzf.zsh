source $HOME/.fzf.common

# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.zsh"

# open fzf-suggestion command
fzf-suggestion-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(FZF_SUGGESTION_SIMPLE=1 fzf-suggestion) )
  local ret=$?
  LBUFFER=$selected
  zle reset-prompt
  return $ret
}
zle     -N   fzf-suggestion-widget
bindkey '^O' fzf-suggestion-widget
#bindkey -s '^O' '^ufzf-suggestion^M'
