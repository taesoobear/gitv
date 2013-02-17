mkdir -p ~/bin
cp gitv ~/bin/
sed -i "s/\/usr\/bin\///g" ~/bin/gitv 
cp mylib.lua ~/bin/
cp gitvim.vim ~/bin/
WINHOMEPATH=$HOMEDRIVE$HOMEPATH
echo "$WINHOMEPATH"
echo "s/\/tmp\//$(printf '%q' "$WINHOMEPATH")\\\/g" 
sed -i "s/silent execute \"!clear/\"/g" ~/bin/gitvim.vim
sed -i "s/\/tmp\//$(printf '%q' "$WINHOMEPATH")\\\/g" ~/bin/gitvim.vim
sed -i "s/\<cat\>/type/g" ~/bin/gitvim.vim
sed -i "s/\<rm\>/del/g" ~/bin/gitvim.vim
# install to /share/vim/vim73 by default. edit appropriately
VIMPATH=/share/vim/vim73
echo $VIMPATH
cp gitv.bat $VIMPATH
echo "copy gitv.bat to your windows folder"
mkdir -p $VIMPATH/plugin
rm -f $VIMPATH/plugin/gitvim.vim
cp ~/bin/gitvim.vim $VIMPATH/plugin
chmod +x ~/bin/gitv

