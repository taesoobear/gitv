cd ..
sh install_windows_msysgit.sh
cd taesoo_vimrc
cp vimrc_win ~/_vimrc
currdir=`pwd`
echo $currdir 
echo $HOME
vimpath="$HOME/vimfiles"
cd "$vimpath"
mkdir -p "$vimpath/plugin"
mkdir -p "$vimpath/colors"
unzip "$currdir/vimwiki-1-1-1.zip"
cd "$vimpath/plugin"
"unzip "$currdir/hangeul.zip"
mkdir -p "$vimpath/colors"
cp "$currdir/pyte.vim" "$vimpath/colors"
rm -f $vimpath/plugin/gitvim.vim
cp "$currdir/../gitvim.vim" $vimpath/plugin
