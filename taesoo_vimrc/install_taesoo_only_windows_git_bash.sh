if ! test -d ~/.vim/bundle/vundle; then git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle; fi
cd ..
# install gitv
sh install_windows_git_bash.sh
cd taesoo_vimrc
winpty winget install "lua for windows"
cp ../windows_git_bash/lua ~/bin/
# install tl (fuzzy executer)
cp tl ~/bin/
chmod +x ~/bin/tl
cp fzy_lua.lua ~/bin/

# install vim settings
cp vimrc ~/.vimrc
mkdir -p ~/.cgdb
cp cgdbrc ~/.cgdb/
cp tmux.conf ~/.tmux.conf

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
mkdir -p ~/AppData/Local/nvim
cp init.vim ~/AppData/Local/nvim/
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME}"/AppData/Local/nvim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# print os-specific messages
if grep MINGW64_NT /proc/version; then
	if ! test -f win32yank-x64.zip; then curl -fLo win32yank-x64.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip; fi
	if ! test -f ~/bin/win32yank.exe; then unzip win32yank-x64.zip; mv win32yank.exe ~/bin/; chmod +x ~/bin/win32yank.exe; fi
	echo ""
	echo ""
	echo ""
	echo ""
	echo "________________________________________________"
	echo "If you use vim, following manual configurations are necesasry!!!"
	echo "1. edit ~/.vimrc"
	echo "     set clipboard+=unnamedplus --> "
	echo "     set clipboard+=unnamed"
	echo "________________________________________________"
	echo "If you use neovim, following manual configurations are necesasry!!!"
	echo "1. edit ~/AppData/Local/nvim-data/plugged/vimwiki-server.nvim/lua/vimwiki_server.lua"
	echo "   : if a.version.is_valid(bridge) then --> if true then "
	echo "2. edit ~/bin/gitv"
	echo " g_vimpath, g_gvimpath=os.findVIM() "
	echo " g_vimpath=\"nvim\""
	echo "3. edit ~/AppData/Local/nvim/init.vim"
	echo "     uncomment the \"g:clipboard=...\" line"
	echo "      also change colorscheme to DarkDefault"
else
	echo "________________________________________________"
	echo "If you use neovim, following manual configurations are necesasry!!!"
	echo "1. you need to install xclip if you are using X11, otherwise install wl-copy and wl-paste if Wayland is in use."
fi
