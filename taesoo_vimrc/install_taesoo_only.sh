git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
cd ..
sh install.sh
cd taesoo_vimrc
cp vimrc ~/.vimrc
cp _emacs ~/.emacs
cp -rf _emacs.d ~/
mkdir -p ~/.emacs.d
cp -rf ~/_emacs.d/* ~/.emacs.d
rm -rf ~/_emacs.d
mkdir -p ~/.cgdb
cp cgdbrc ~/.cgdb/
cp tmux.conf ~/.tmux.conf
sudo cp convkr.sh /usr/local/bin/convkr
sudo chmod 707 /usr/local/bin/convkr
sudo bash -c 'echo "set completion-ignore-case on">> /etc/inputrc'
currdir=`pwd`
echo $currdir
cd ~/.vim
unzip "$currdir/vimwiki-1-1-1.zip"
cd ~/.vim/plugin
mkdir -p ~/.vim/colors
cp "$currdir/pyte.vim" ~/.vim/colors
cp "$currdir/linux.vim" ~/.vim/colors
