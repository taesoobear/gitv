1. intalling windows-native lua and neovim as follows (in powershell), copy a script "./lua" to "~/bin/"
{{{
winget install "windows for lua"
winget install Neovim.Neovim
}}}

2. using a "git bash" window, install gitv.
{{{
sh install_windows_git_bash.sh
}}}

3. create a "powershell" profile, and copy the contents of "./powershell_profile"  into it.

Then you can use gitv normally in powershell.

Also, see taesoo_vimrc/install_taesoo_only_windows_git_bash.sh for more details.

