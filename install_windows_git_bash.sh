mkdir -p ~/bin
cp gitv ~/bin/
cp mylib.lua ~/bin/
cp mylib52.lua ~/bin/
cp taesoo_vimrc/fzy_lua.lua ~/bin/
mkdir -p ~/.vim
mkdir -p ~/.vim/plugin
cp gitvim.vim ~/.vim/plugin

CURRPATH="$PWD"
echo "$CURRPATH"

cd ~
WINHOMEPATH="$PWD"
echo "$WINHOMEPATH"
function sedPath { 	
	path=$((echo $1|sed -r 's/([\$\.\*\/\[\\^])/\\\1/g'|sed 's/[]]/\[]]/g')>&1) 
}
sedPath "$WINHOMEPATH"
echo "$path"
echo "s/\/tmp\//$path\/\/g" 
sed -i "s/silent execute \"!clear/\"/g" ~/.vim/plugin/gitvim.vim
sed -i "s/\/tmp\//$path\//g" ~/.vim/plugin/gitvim.vim
chmod +x ~/bin/gitv

