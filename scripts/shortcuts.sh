
#
# Section added by Drupsible
#
# history search with arrow up-down, fx type "cd" and press arrow up
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# better dir colours
LS_COLORS='di=0;32' ; export LS_COLORS

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50001
HISTFILESIZE=500001

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

## get rid of command not found ##
alias cd..='cd ..'

## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
#
# End of section by Drupsible
#
