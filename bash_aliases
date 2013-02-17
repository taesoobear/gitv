stty -ixon
# use vim to open a file. e.g. v luna.c
alias v='gitv gvimr GVIM'
# tag search. e.g. t main$
alias t='gitv ts'
# use remote gvim to open a file

function gitv-cd {
  before="$(pwd)"
  gitv chooseFolder "$@" 
  after="$(cat /tmp/gitv_chosen)"
  if [[ "$before" != "$after" ]]; then
    cd "$after"
  fi
}
# goto the folder containing a selected file. e.g. gg luna.c
alias gg='gitv-cd'


alias b='gitv gvimr GVIM'
# send to another gvim instance
# gitv gvimr support multiple instances of gvim 
# even when the same file is open in both gvim (an experimental feature).
alias b2='gitv gvimr GVIM2'

# put the following line in .bashrc 
export PATH=$PATH:~/bin

# because I change .bash_aliases very often,
#alias va='vi ~/.bashrc;source ~/.bashrc'
alias va='vi ~/.bash_aliases;source ~/.bash_aliases'


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
