1. intalling windows-native lua and neovim as follows (in powershell), copy a script "./lua" to "~/bin/"
{{{
winget install "windows for lua"
winget install Neovim.Neovim
}}}


2. create a "powershell" profile. 
In a powershell window,
{{{
test-path $profile
}}}
If it returns False
{{{
New-Item -Path $profile -Type File -Force
notepad.exe $profile
}}}
and then copy the contents of "./powershell_profile"  into it.


3. using a "powershell" window, install gitv.
{{{
./install_windows_powershell.ps1
}}}



Then you can use gitv normally in powershell.

Also, see taesoo_vimrc/install_taesoo_only_windows_git_bash.sh for more details.
