# gitv
gitv: vim, neovim file chooser, and TAGS generator
Gitv is a tool that extends git's functionality as well as vim and neovim. 
Gitv is for those who use vim neovim or gvim and etags. The gitv's main feature is its file chooser: it opens any source file in a git repository using vim like this:

    $ gitv vi keyword
When there are multiple files containing the keyword, one of them can be interactively chosen. The keyword matching uses the lua patterns (http://pgl.yoyo.org/luai/i/5.4.1+Patterns). For example, to list all cpp files, use

    $ gitv vi cpp$
    or
    $ gitv find cpp$
To list all .x files, use

    $ gitv find %.x$
To list all main functions, use

    $ gitv ts main$
    or more precisely,
    $ gitv ts ^main$

The above "ts" command requires "exuberant-ctags" to be installed. Inside vim or neovim, one can open another file using ctrl + g + keyword. To search for a function definition, ctrl+ h  + keyword.

In neovim, fuzzy-keyword search is supported through the telescope plugin.

Also, you can change directory using keywords

    $ gg main.cpp$
    or
    $ gd streamingassets$

Here, "gd" uses folder name (instead of file name). Both gg and gd uses a recursive search in an entire git repository. 

This tool is convenient for repositories having complex directory structures.

Example settings are in gitvim.vim (for vim), init.vim (for neovim), and bash_aliases (for bash and zsh).

Additionally, you can set error-fallback paths and ignore patterns for each repository. For example,
create GIT_TOP/.gitvconfig file containing


       -- ignore files that match following patterns even if they are in the repository.
       g_ignorePattern={'/dependencies_windows_only/', '/dependencies/','dependencies_windows_only/','BaseLib/image/FreeImage/','^dependencies/', 'PhysicsLib/CollisionDetector/Ice',
       'PhysicsLib/AIST_implementation', 
       'PhysicsLib/GMBS_implementation', 
       'PhysicsLib/Bullet_implementation', 
       'MotionFlow/MATHCLASS',
       'QP_controller/Eigen',
       --'math/clust',
       'PhysicsLib/sDIMS','GaussianProcess/','opennl/','Fl_Native_File_Chooser','PhysicsEngine/'
       }
       g_diffTarget="../taesooLib"
       g_tagFallbackPath={"../taesooLib", "../PhysX_MABA/"}

Target platform
=
Windows (wsl), mac, and Linux (tested on Ubuntu and Fedora machines).
It is assumed that ~/bin is in the PATH environment variable.
If there is no /tmp/ folder in your system, please search and replace /tmp/ in ~/bin/gitv and ~/.vim/plugin/gitvim.vim files appropriately.
gitv is written fully in pure lua.
Supported extensions (*.c, *.cpp, *.py, *.lua ...) can be modified by editing the first few lines of gitv (Other files will be ignored.)

How to install
=
Install git and lua. For example, in Debian or Ubuntu,

       $ sudo apt-get install lua git 

In windows, install wsl. 
Install exuberant-ctags to generate TAGS and use code-browsing in vim.

       $ sudo apt-get install exuberant-ctags
Clone the repository anywhere, then run install.sh. Gitv will be installed locally
in your ~/bin folder.

       $ git clone https://github.com/taesoobear/gitv
       $ cd gitv; sh install.sh
Optionally create bash aliases, for example, in ~/.bash_aliases

       alias v='gitv vi'
       alias g='gitv gvim'
       alias t='gitv ts'
       export PATH=$PATH:~/bin
If you want to install my .vimrc too... (Dangerous!)

       $ cd gitv/taesoo_vimrc;sh install_taesoo_only.sh
Usage in terminal

        $ gitv
The most commonly used gitv commands are:

    vi         Open a file in the git repository whose name contains 
             the keyword. When no keyword is given, history will be shown.
               $ gitv vi [option] keyword
             or
               $ gitv vi [option]
             option -l: search only subdirectories of the current directory.
    vir        Same as "vi" except that an existing vim server is used when available.
    ts         Search a keyword using $GIT_ROOT/TAGS, and open using vim. 
             For example, to edit main() function:
               $ gitv ts main$
    gvim       Open a file using gvim
    gedit      Open a file using gedit
    choose     Write choosen file name to /tmp/chosen
               $ gitv choose keyword
    clear-hist Clear history
    sync       Commit, pull, and then push. 
    pull       Pull the current branch from all remotes
    fetch      Fetch the current branch from all remotes
    push       Push the current branch to all remotes
    commit     Interactively commit the current branch. gitv ci also works.
    find       Find files 
               $ gitv find keyword
    grep       Unlike git grep, entire repository (not limited to the current 
             directory) will be searched. Files with allowed extensions will only
             be searched. (see ~/bin/gitv.) Lua patterns are used.
               $ gitv grep keyword
    etags .    Generate TAGS for all tracked files in the current folder recursively
               $ gitv etags .
    etags      Generate TAGS for all tracked files in the git repository
    diff       Show differences between commits. 
               $ gitv diff
               $ gitv diff HEAD~10

Usage in VIM or GVIM
=
By default, the following map is used. In gvim, a new menu also appears. You can alter the behavior by editing ~/.vim/plugin/gitvim.vim

select buffers using :Bs (choose among the already open files) or :Bg (choose a file in the repository) or :GitvTS (choose using $GIT_ROOT/TAGS). $GIT_ROOT is automatically detected based on :pwd.

    :Bs a.cpp
    :Bg a.cpp
    :GitvTS main
select buffers using C-b (choose among the already open files) or C-g (choose in the repository)
    
    
tag-search definitions starting with... (Uses gitv ts)

    <f3>

    
grep the current word under the cursor. (Uses gitv grep)

    <f4>
    :grep keyword

tag-search the current word under the cursor. (More robust than the default c+])

    <f5>
    
    
go back to the previous location.

    <shift-f5>
    
make

    <f7>
    
list compile errors (:copen)

    <f8>
    
goto the next error (:cnext)

    <f9>
