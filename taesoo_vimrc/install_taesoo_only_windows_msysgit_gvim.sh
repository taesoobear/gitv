cd ..
sh install_windows_msysgit.sh
cd taesoo_vimrc
cp vimrc ~/_vimrc
sed -i "s/source/\"source/g" ~/_vimrc
sed -i "s/unnamedplus/unnamed/g" ~/_vimrc
sed -i "s/let\ hangeul/\"let\ hangeul/g" ~/_vimrc
currdir=`pwd`
echo $currdir 
vimpath='/c/Program Files (x86)/vim/vimfiles'
cd "$vimpath"
unzip "$currdir/vimwiki-1-1-1.zip"
cd "$vimpath/plugin"
#unzip "$currdir/hangeul.zip"
mkdir -p "$vimpath/colors"
cp "$currdir/pyte.vim" "$vimpath/colors"
