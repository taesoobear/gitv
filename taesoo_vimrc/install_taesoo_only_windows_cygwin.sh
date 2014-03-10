cd ..
sh install.sh
cd taesoo_vimrc
cp vimrc ~/.vimrc
cp vimrc_cygwin_gvim ~/_vimrc
cp _emacs ~/.emacs
cp -rf _emacs.d ~/
mkdir -p ~/.emacs.d
cp -rf ~/_emacs.d/* ~/.emacs.d
rm -rf ~/_emacs.d
mkdir -p ~/.cgdb
cp cgdbrc ~/.cgdb/
cp tmux.cof ~/.tmux.conf
bash -c 'echo "set completion-ignore-case on">> /etc/inputrc'
currdir=`pwd`
echo $currdir
cd ~/.vim
unzip "$currdir/vimwiki-1-1-1.zip"
cd ~/.vim/plugin
unzip "$currdir/hangeul.zip"
mkdir -p ~/.vim/colors
cp "$currdir/pyte.vim" ~/.vim/colors
cp cygwin_win_gvim/_vimrc ~/_vimrc
cp -rf ~/.vim ~/vimfiles
cp cygwin_win_gvim/gitvim.vim ~/vimfiles/plugin/
echo "Note!!! please manually edit ~/.vimrc and remove the line containing clipboard=unnamedplus"
echo "~/.vimrc is for the cygwin vim."
echo "~/_vimrc is for windows gvim launched from cygwin. Copy ~/.vim folder to ~/vimfiles after installing bundles using the cygwin vim to use gvim properly."
