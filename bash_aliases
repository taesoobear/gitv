# use vim to open a file. e.g. v luna.c
alias v='gitv vi'
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
