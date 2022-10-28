winget install "lua for windows"
# let's use neovim instead of vim
winget install Neovim.Neovim
# install lf file manager (which is a clone of "ranger")
winget install -e --id GoLang.Go.1.19
$env:CGO_ENABLED = '0'
go install -ldflags="-s -w" github.com/gokcehan/lf@late


if(!(Test-Path -Path $HOME\bin)) { md $HOME\bin }

copy gitv $HOME\bin\
copy mylib.lua $HOME\bin\
copy mylib52.lua $HOME\bin\
copy taesoo_vimrc\fzy_lua.lua $HOME\bin\


if(!(Test-Path -Path $HOME\tmp)) { md $HOME\tmp }


if(!(Test-Path -Path $HOME\AppData\Local\nvim)) { md $HOME\AppData\Local\nvim }
copy windows_powershell\init.vim $HOME\AppData\Local\nvim\
Invoke-WebRequest https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -OutFile $HOME\AppData\Local\nvim\autoload\plug.vim

if(Test-Path -Path $profile)
{
	notepad.exe windows_powershell\powershell_profile
	notepad.exe $profile
}
