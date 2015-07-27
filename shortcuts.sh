# history search with arrow up-down, fx type "cd" and press arrow up
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Previous/next word shortcut with Ctrl + Left Ctrl + Right
bind '"\eOC": forward-word'
bind '"\eOD": backward-word'

# better dir colours
LS_COLORS='di=0;32' ; export LS_COLORS

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=500000
# avoid losing history
PROMPT_COMMAND="history -a"
export HISTSIZE PROMPT_COMMAND

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
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Git aliases
alias g=”git”
alias gr=”git rm -rf”
alias gs=”git status”
alias ga=”g add”
alias gc=”git commit -m”
alias gp=”git push origin master”
alias gl=”git pull origin master”
