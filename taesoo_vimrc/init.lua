-- ============================================================
-- Basic settings
-- ============================================================

vim.opt.compatible = false
vim.cmd("filetype plugin off")

-- ============================================================
-- vim-plug
-- ============================================================
-- 제목과 코드 블록 기준으로 folding
vim.g.vimwiki_folding = "expr"
vim.cmd([[
call plug#begin()

Plug 'flazz/vim-colorschemes'
Plug 'altercation/vim-colors-solarized'
Plug 'vimwiki/vimwiki'
Plug 'gabrielelana/vim-markdown'
Plug 'chipsenkbeil/vimwiki-server.nvim', { 'tag': 'v0.1.0-alpha.4' }
Plug 'nanotech/jellybeans.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug '~/gitv/gitv.nvim'
Plug 'dcampos/nvim-snippy'
Plug 'lukas-reineke/headlines.nvim'

"Plug 'folke/neodev.nvim'
"Plug 'neovim/nvim-lspconfig'
"Plug 'nvim-lua/completion-nvim'

call plug#end()
]])
vim.cmd("filetype plugin indent on")
-- ============================================================
-- Telescope
-- ============================================================

require("telescope").setup({})

require("telescope").load_extension("file_browser")
require("telescope").load_extension("gitv")

vim.api.nvim_create_user_command("E", function()
	require("telescope").extensions.file_browser.file_browser()
end, {})

vim.api.nvim_create_user_command("B", function()
	require("telescope.builtin").buffers()
end, {})

-- ============================================================
-- Optional LSP setup
-- ============================================================

--[[
require("neodev").setup({})

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
	on_attach = require("completion").on_attach,
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
		},
	},
})
]]

-- ============================================================
-- Syntax / runtime
-- ============================================================

vim.cmd("syntax on")

-- Extended % matching:
-- if/elsif/else/end, XML tags, etc.
vim.cmd("runtime macros/matchit.vim")

vim.opt.fileencodings = "utf-8"

-- guioptions-=T
--vim.opt.guioptions:remove("T")

-- ============================================================
-- VimWiki
-- ============================================================

vim.g.vimwiki_file_exts = "pdf,chm"

-- ============================================================
-- Appearance
-- ============================================================

vim.opt.termguicolors = true

vim.cmd.colorscheme("jellybeans")

vim.opt.guifont = "Monospace 11"

if vim.fn.has("gui_running") == 1 then
	vim.g.hangeul_enabled = 1

	vim.keymap.set(
		"i",
		"<S-Space>",
		"<Plug>HanMode",
		{ silent = true }
	)

	vim.cmd.colorscheme("Monokai")
end

-- ============================================================
-- General options
-- ============================================================

vim.opt.ignorecase = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.tagbsearch = false

vim.opt.wrap = false

-- Folding by indentation
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 1

-- System clipboard
vim.opt.clipboard:append("unnamed")

-- WSL alternative:
--[[
vim.g.clipboard = {
	name = "win32yank-wsl",

	copy = {
		["+"] = "win32yank.exe -i --crlf",
		["*"] = "win32yank.exe -i --crlf",
	},

	paste = {
		["+"] = "win32yank.exe -o --lf",
		["*"] = "win32yank.exe -o --lf",
	},

	cache_enabled = 0,
}
]]

-- ============================================================
-- ToggleWrap
-- ============================================================

local function toggle_wrap()
	if vim.wo.wrap then
		print("Wrap OFF")

		vim.wo.wrap = false
		vim.opt.virtualedit = "all"

		local keys = {
			"<Up>",
			"<Down>",
			"<Home>",
			"<End>",
			"j",
			"k",
		}

		for _, key in ipairs(keys) do
			pcall(vim.keymap.del, "n", key, { buffer = true })
		end

		for _, key in ipairs({
			"<Up>",
			"<Down>",
			"<Home>",
			"<End>",
		}) do
			pcall(vim.keymap.del, "i", key, { buffer = true })
		end
	else
		print("Wrap ON")

		vim.wo.wrap = true
		vim.wo.linebreak = true
		vim.wo.list = false

		vim.opt.virtualedit = ""

		vim.opt_local.display:append("lastline")

		local opts = {
			buffer = true,
			silent = true,
			remap = false,
		}

		vim.keymap.set("n", "<Up>", "gk", opts)
		vim.keymap.set("n", "<Down>", "gj", opts)

		vim.keymap.set("n", "k", "gk", opts)
		vim.keymap.set("n", "j", "gj", opts)

		vim.keymap.set("n", "<Home>", "g<Home>", opts)
		vim.keymap.set("n", "<End>", "g<End>", opts)

		vim.keymap.set("i", "<Up>", "<C-o>gk", opts)
		vim.keymap.set("i", "<Down>", "<C-o>gj", opts)

		vim.keymap.set("i", "<Home>", "<C-o>g<Home>", opts)
		vim.keymap.set("i", "<End>", "<C-o>g<End>", opts)
	end
end

-- ============================================================
-- ToggleFold
-- ============================================================

local function toggle_fold()
	if vim.fn.foldlevel(".") == 0 then
		vim.cmd("normal! l")
	else
		if vim.fn.foldclosed(".") < 0 then
			vim.cmd("foldclose")
		else
			vim.cmd("foldopen")
		end
	end

	-- Clear command/status message
	vim.cmd("echo ''")
end

-- ============================================================
-- Key mappings
-- ============================================================

local map = vim.keymap.set

-- Space: toggle fold
map("n", "<Space>", toggle_fold)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "vimwiki",
    callback = function(ev)
        vim.wo.foldenable = true
        vim.wo.foldlevel = 1

        vim.keymap.set("n", "<Space>", toggle_fold, {
            buffer = ev.buf,
            silent = true,
        })
    end,
})
-- Leader+w: toggle wrap
map("n", "<Leader>w", toggle_wrap, {
	silent = true,
})

-- unfold all
map("n", "zr", "zR")

-- ;; instead of ;
map({ "n", "v", "o" }, ";;", ";")

-- ; instead of :
map("n", ";", ":")

-- Edit command line
map("n", "q;", "q:")

-- Save session and quit
map(
	"n",
	"<C-d>",
	":mks! .__vimsession<CR>:qa<CR>",
	{ silent = false }
)

-- Save
map(
	"n",
	"<C-s>",
	":w<CR>",
	{ silent = true }
)

map(
	"i",
	"<C-s>",
	"<ESC>:w<CR>",
	{ silent = true }
)

-- Buffers
map(
	"n",
	"<C-n>",
	":bn<CR>",
	{ silent = true }
)

map(
	"n",
	"<C-p>",
	":bp<CR>",
	{ silent = true }
)

map(
	"n",
	"<C-b>",
	":Telescope buffers<CR>",
	{ silent = true }
)

-- GitV
map(
	"n",
	"<C-k>",
	":Telescope gitv<CR>",
	{ silent = true }
)

map(
	"n",
	"<C-g>",
	function()
		require("telescope").extensions.gitv.gitv_files()
	end
)

map(
	"n",
	"<C-h>",
	function()
		-- Equivalent to:
		-- mZ + gitv("^<C-r><C-w>$")

		vim.cmd("normal! mZ")

		local word = vim.fn.expand("<cword>")

		require("telescope").extensions.gitv.gitv({
			key = "^" .. word .. "$",
		})
	end
)

-- Run make
map(
	"n",
	"<C-y>",
	":!stdbuf -i0 -o0 make run<CR>"
)

-- Return to mark Z
map(
	"n",
	"<S-F5>",
	"'Z"
)

-- ============================================================
-- Commands
-- ============================================================

vim.api.nvim_create_user_command(
	"ZR",
	function()
		vim.cmd("normal! zR")
	end,
	{}
)

-- ============================================================
-- Backup / swap
-- ============================================================

vim.opt.backupdir = {
	"./.backup",
	".",
	"/tmp",
}

vim.opt.directory = {
	".",
	"./.backup",
	"/tmp",
}

-- ============================================================
-- grep
-- ============================================================

vim.opt.grepprg = "gitv grep"

-- ============================================================
-- Snippy Tab completion
-- ============================================================

vim.keymap.set(
	"i",
	"<Tab>",
	function()
		if vim.fn["snippy#can_expand_or_advance"]() == 1 then
			return "<Plug>(snippy-expand-or-advance)"
		end

		return "<Tab>"
	end,
	{
		expr = true,
		remap = true,
	}
)

-- ============================================================
-- nvimdiff: clear word/character-level highlighting
-- ============================================================

-- Better line matching / diff algorithm
vim.opt.diffopt:append({
    "algorithm:histogram",
    "indent-heuristic",
    "linematch:60",
})

local function set_diff_highlights()
    -- Added line: subtle green
    vim.api.nvim_set_hl(0, "DiffAdd", {
        bg = "#1e3528",
    })

    -- Deleted line: subtle red
    vim.api.nvim_set_hl(0, "DiffDelete", {
        bg = "#3b2426",
        fg = "#d0a0a0",
    })

    -- Changed line: subtle blue
    vim.api.nvim_set_hl(0, "DiffChange", {
        bg = "#252d3d",
    })

    -- Actual changed text inside the line:
    -- intentionally much stronger than DiffChange
    vim.api.nvim_set_hl(0, "DiffText", {
        bg = "#8a6500",
        fg = "#ffffff",
        bold = true,
    })
end

set_diff_highlights()

-- Re-apply after changing colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_diff_highlights,
})
vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
    callback = function()
        if vim.bo.buftype ~= "" then
            vim.wo.foldenable = false
        end
    end,
})
