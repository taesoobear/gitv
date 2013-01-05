mkdir -p ~/bin
cp gitv ~/bin/
sed -i "s/\/usr\/bin\///g" ~/bin/gitv 
cp mylib.lua ~/bin/
mkdir -p /share/vim/vim73/plugin
cp gitvim.vim /share/vim/vim73/plugin
chmod +x ~/bin/gitv

