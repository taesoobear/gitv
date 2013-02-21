cd ..
sh install_windows_msysgit.sh
cd taesoo_vimrc
cp vimrc_win ~/_vimrc
currdir=`pwd`
echo $currdir 
cd /share/vim/vim73
unzip "$currdir/vimwiki-1-1-1.zip"
cd /share/vim/vim73/plugin
#unzip "$currdir/hangeul.zip"
mkdir -p /share/vim/vim73/colors
cp "$currdir/pyte.vim" /share/vim/vim73/colors
