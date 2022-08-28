#!/bin/bash

if [ -n "$TMUX" ];then
    tmux showenv -g TMUX_PWD_$(tmux display -p "#D" | tr -d %)  | sed 's/^.*=//'
fi

