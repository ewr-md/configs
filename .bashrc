#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

###############################
#  ALIASES for bash commands  #
###############################
alias i='startx /usr/bin/i3'
alias x='startx /usr/bin/xfce4-session'
alias d='startx /usr/bin/dwm'
alias v='nvim'
alias snp='cd /home/eric/.local/share/nvim/plugged/vim-snippets/UltiSnips'
alias ph='cd ~/Documents/research/ph/nonAdherence/'
alias ls='exa --sort=type -lh'
alias dl='youtube-dl -f best'
alias mk='makepkg -sif'
alias cv='cd ~/Documents/work/cv-resume'
