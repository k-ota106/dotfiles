#!/bin/bash

if [ -n "$TMUX" ];then
    tmux setenv -g TMUX_PWD_$(tmux display -p "#D" | tr -d %) $PWD
fi

