# to use vim to open a file. e.g. v luna.c
alias v='gitv vi'
# tag search. e.g. t main$
alias t='gitv ts'

# use gitv to change directory by file name. e.g. gg main.c
function gitv-cd {
  before="$(pwd)"
  gitv chooseFolder "$@" 
  after="$(cat /tmp/gitv_chosen)"
  if [[ "$before" != "$after" ]]; then
    cd "$after"
  fi
}
# use gitv to change directory by directory name. e.g. gd home
function gitv-cd2 {
  before="$(pwd)"
  gitv chooseFolder2 "$@" 
  after="$(cat /tmp/gitv_chosen)"
  if [[ "$before" != "$after" ]]; then
    cd "$after"
  fi
}
# use ranger to change directory
function ranger-cd {
  before="$(pwd)"
  ranger --choosedir="/tmp/gitv_chosen"
  after="$(cat /tmp/gitv_chosen)"
  if [[ "$before" != "$after" ]]; then
    cd "$after"
  fi
}
# goto the folder containing a selected file. e.g. gg luna.c
alias gg='gitv-cd'
# goto any folder in the tree. e.g. gd mainlib
alias gd='gitv-cd2'
# use ranger to change directory. (sudo apt-get install ranger)
alias rg=ranger-cd


# to turn off flow control (C-s, C-q)
stty -ixon

# put the following line in .bashrc if ~/bin is not in the path
export PATH=$PATH:~/bin

# C-d in vim saves the current session. vis restores it.
alias vs='vim -c ":source .__vimsession"'
# because I change .bash_aliases very often, I make an alias
alias va='vi ~/.bash_aliases;source ~/.bash_aliases'

################################################
# experimental features below (not well tested)#
################################################
# to use gvim 
alias b='gitv gvim'
# to use gvim remote
alias b='gitv gvimr GVIM'
# or you can use emacs client
alias b='gitv --emacs vir'
# send to another gvim instance # gitv gvimr support multiple instances of gvim # even when the same file is open in both gvim (an experimental feature).
alias b2='gitv gvimr GVIM2'
# emacsclient + auto launch server
alias e='gitv --emacs open'
# or using emacs
alias t='gitv --emacs ts'

##############################################
# windows msysgit only below                 #
##############################################
function gvim {
	"/c/Program Files (x86)/vim/Vim73/gvim" "$@" &
	}
alias vimdiff='vim -d'
# use the following instead of the above one on windows
function gitv-cd {
  before="$(pwd)"
  gitv chooseFolder "$@" 
  after="$(cat ~/gitv_chosen)"
  if [[ "$before" != "$after" ]]; then
    cd "$after"
  fi
}
alias va='vi ~/.bashrc;source ~/.bashrc'
