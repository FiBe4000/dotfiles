#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\[\e[32m\][\[\e[m\]\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]\[\e[32m\] \[\e[m\]\[\e[32m\]\W\[\e[m\]\[\e[32m\]]\[\e[m\]\[\e[32m\]\\$\[\e[m\] '

# Aliases
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias backup='/home/fibe/projects/bash_scripts/backup.sh'

# Exports
export VISUAL="vim"
export EDITOR="$VISUAL"

# Set Vi mode
set -o vi

echo; screenfetch; echo
