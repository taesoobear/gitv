if ! test -d ~/.vim/bundle/vundle; then git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle; fi
cd ..
# install gitv
sh install.sh
cd taesoo_vimrc
# install tl (fuzzy executer)
cp tl ~/bin/
chmod +x ~/bin/tl
cp fzy_lua.lua ~/bin/

# install vim settings
cp vimrc ~/.vimrc
mkdir -p ~/.cgdb
cp cgdbrc ~/.cgdb/
cp tmux.conf ~/.tmux.conf

# korean language related
sudo cp convkr.sh /usr/local/bin/convkr
sudo chmod 707 /usr/local/bin/convkr
sudo bash -c 'echo "set completion-ignore-case on">> /etc/inputrc'
currdir=`pwd`
echo $currdir
cd ~/.vim
#unzip "$currdir/hangeul.zip"

# vimwiki
if ! test -f ~/.vim/autoload/vimwiki.vim; then unzip "$currdir/vimwiki-1-1-1.zip"; fi
cd ~/.vim/plugin
mkdir -p ~/.vim/colors
cp "$currdir/pyte.vim" ~/.vim/colors
cp "$currdir/linux.vim" ~/.vim/colors
cd ~/.vim/plugin


# now install configurations for neovim
cd "$currdir"
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim/
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# print os-specific messages
if grep microsoft /proc/version; then
	if ! test -f win32yank-x64.zip; then wget https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip; fi
	if ! test -f /usr/local/bin/win32yank.exe; then unzip win32yank-x64.zip; sudo mv win32yank.exe /usr/local/bin/; chmod +x /usr/local/bin/win32yank.exe; fi
	echo ""
	echo ""
	echo ""
	echo ""
	echo "________________________________________________"
	echo "If you use neovim, following manual configurations are necesasry!!!"
	echo "1. edit ~/.local/share/nvim/plugged/vimwiki-server.nvim/lua/vimwiki_server.lua"
	echo "   : if a.version.is_valid(bridge) then --> if true then "
	echo "2. edit ~/bin/gitv"
	echo " g_vimpath, g_gvimpath=os.findVIM() "
	echo " g_vimpath=\"nvim\""
	echo "3. edit ~/.config/nvim/init.vim"
	#echo "     set clipboard+=unnamed --> unnamedplus"
	echo "     uncomment the \"g:clipboard=...\" line"
else
	echo "________________________________________________"
	echo "If you use neovim, following manual configurations are necesasry!!!"
	echo "1. you need to install xclip if you are using X11, otherwise install wl-copy and wl-paste if Wayland is in use."
fi
