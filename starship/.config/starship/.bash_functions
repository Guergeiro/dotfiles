#!/bin/bash

function set_win_title(){
  echo -ne "\033]0; $PWD \007"
}
eval "$(starship init bash)"
starship_precmd_user_func="set_win_title"
