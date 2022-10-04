local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"
local utils = require "telescope.utils"
local isWin=string.find(string.lower(os.getenv('OS') or 'nil'),'windows')~=nil

if isWin then
	package.path =os.getenv('HOMEDRIVE')..os.getenv('HOMEPATH').."/bin/?.lua" .. ";"..package.path 
	if os.getenv('HOME') then
		package.path =os.getenv('HOME').."/bin/?.lua" .. ";"..package.path 
	end
else
	package.path =os.getenv('HOME').."/bin/?.lua" .. ";"..package.path 
end
local function git_top() -- git_root
	if cache_git_top==nil then
		local t
		local str=os.capture('git rev-parse --show-toplevel 2>&1', true)
		if select(1,string.find(str, 'fatal:')) then
			str=''
		end
		t= string.lines(str)[1]
		cache_git_top=t
	end
	if cache_git_top=='' then
		cache_git_top='.'
	end
	return cache_git_top
end 
local function git() 
	return 'git'
end

function lsFiles(option, path)
	path=path or git_top()
	local cpt
	if cache_git_top=='.' then
		print('Not a git repository. Searching the current folder...')
		--cpt=os.capture(git()..' ls-files .', true)
		if os.isApple() then
			cpt={}
		else
			--cpt=os.glob('*',true,true) -- too slow
			cpt=string.lines(os.capture('ls -1',true))
			cpt[#cpt]=nil
		end
		--printTable(cpt)
	elseif option=='-l' then	
		cpt=os.capture(git()..' ls-files .', true)
	elseif option=='-g' then
		-- use absolute
		cpt=os.capture('cd '..path..';git ls-files .', true)
	else
		cpt=os.capture(git()..' ls-files "'..git_top()..'" 2>&1', true)
		if select(1, string.find(cpt, 'fatal:')) then
			option='-g'
			cpt=os.capture('cd '..git_top()..';git ls-files .', true)
		end
		cpt=string.lines(cpt)
	end
	return _lsFiles(cpt, option, path)
end

function _lsFiles(cpt, option, path)
	local files
	path=path or git_top()
	if type(cpt)=='string' then
		files=string.lines(cpt)
	else
		files=cpt
	end
	local files=array.sub(files,1,-2)
	if option=='-g' then
		for i,v in ipairs(files) do
			files[i]=path..'/'..v
		end
	end
	if g_ignorePattern and #g_ignorePattern>0 then
		files=array.filter(function (fn)
			for i,pattern in ipairs(g_ignorePattern) do
				if select(1,string.find(fn, pattern)) then
					return false
				end
			end
			return true
		end, files)
	end
	return files
end
function string.linesContaining(filename, pattern)
	local fout, msg=io.open(filename, "r")
	if fout==nil then
		print(msg)
		return
	end
	pattern=string.gsub(pattern,'[%$%^]','')
	local lastFileTag=''
	local t = {}
	while true do
		local line=fout:read('*line')
		if line==nil then break end
		if select(1, string.find(string.lower(line),string.lower(pattern))) then 
			table.insert(t, lastFileTag) 
			table.insert(t, line) 
		elseif not select(1, string.find(line, string.char(127))) then
			lastFileTag=line
		end
	end
	return t
end

local function getTagList(filename, searchKey, sep)
	if not os.isFileExist(filename) then return {} end

	local t
	if searchKey then
		t=string.linesContaining(filename, searchKey)
	else
		t=string.lines(util.readFile(filename))
	end
	if not t then return {} end
	local currFile
	local tags={}
	for i=1,#t do
		local o=''
		local oo=string.tokenize(t[i],string.char(127))
		if #oo==1 then
			local oo2=string.tokenize(oo[1], ',')
			if #oo2==2 then
				--print(oo2[1], oo2[2])
				currFile=oo2[1]
			end
		else 
			local oo2 =string.tokenize(oo[2], string.char(1))
			local pattern=oo2[1]
			if isRegExp then
				-- when the searchKey contains "." ,
				-- for example, VRMLTransform.*translateBone,
				-- full function-signature is used as a pattern
				pattern=oo[1]
			end
			--if select(1,string.find(string.lower(pattern),string.lower(searchKey))) or
			--	  select(1,string.find(string.lower(pattern),string.gsub(string.lower(searchKey), "%^","[:%.]"))) then

			local spaceLen=math.max(0, 60-string.len(oo[1]))
			table.insert(tags, oo[1].. string.rep(' ', spaceLen).." |-"..sep..currFile.. ":"..tonumber(string.tokenize(oo2[2],',')[1]))
			-- end
		end
	end
	return tags
end

local file_search = function(opts)
	require("mylib52")
	g_vimSrc={"%.cfg$","%.sh$", "%.cmake$", "%.vim$", "%.hpp$", "%.cs$", "%.xml$", "%.cc$", "%.bvh$", "%.glsl$", "%.f$", "%.java$", "%.mm$","%.material$", "%.rb$", "%.m$", "Makefile$","%.bib$", "%.tex$", "%.wiki$","%.EE$", "%.wrl$", "%.lua$","%.py$", "%.c$", "%.h$", "%.hpp$", "%.txt$", "%.inl$", "%.cpp$"}

	if os.isFileExist(git_top()..'/.gitvconfig') then
		dofile(git_top()..'/.gitvconfig')
	end
	local files=lsFiles()
	if not g_tagFallbackPath then
		g_tagFallbackPath={}
	end

	for i=1,#g_tagFallbackPath do
		local fallbackPath=g_tagFallbackPath [i]
		local path=os.relativeToAbsolutePath(fallbackPath, git_top())
		if os.isFileExist(path) then
			--print('file searching '..g_tagFallbackPath[i])
			local files2=lsFiles('-g', path)
			array.concat(files, files2)
		end
	end
	local _files=files
	local files={}

	-- 
	home=os.home_path()
	local function displayText(file)
		local fn, path=os.processFileName(file)
		local spaceLen=math.max(0, 40-string.len(fn))

		if path:sub(1,1)=='/' and path:sub(1, home:len())==home then
			path='~'..path:sub(home:len()+1)
		end

		return fn..string.rep(' ', spaceLen)..' | '..path
	end
	local function fullPathFromDisplayText(text)
		local s,e =string.find(text, ' | ')
		if s then
			local filename=string.trimSpaces(text:sub(1, s-1))
			local path=text:sub(s+3)
			if path:sub(1,1)=='~' then
				path=home..path:sub(2)
			elseif path=='' then
				return filename
			end
			return path..'/'..filename
		end
		return text
	end
	local fzy = require'fzy_lua'
	for ifile, file in ipairs(_files) do
		if string.isMatched(file,g_vimSrc)  then
			if opts and opts.key then	
				--if select(1,string.find(string.lower(file), string.lower(opts.key))) then
				--	table.insert(files, displayText(file))
				if fzy.has_match(string.lower(opts.key), string.lower(file)) then
					local a=opts.key:lower()
					local b=displayText(file)
					local positions = fzy.positions(a,b:lower())
					if #positions==0 or positions[#positions] >=40 then
					else
				--if select(1,string.find(string.lower(file), string.lower(opts.key))) then
					--table.insert(files, table.tostring(positions)..displayText(file))
						table.insert(files, displayText(file))
					end
				end
			else
				table.insert(files, displayText(file))
			end
		end
	end
	if #files==1 then
		vim.cmd("edit "..fullPathFromDisplayText(files[1]))
		return 
	end
	pickers.new(opts, {
		prompt_title = "gitv vi",
		finder = finders.new_table {
			results = files
		},
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if not selection then
					return 
				end

				if selection[1] then
					vim.cmd("edit "..fullPathFromDisplayText(selection[1]))
				end
			end)
			return true
		end,
	}):find()
end
local tag_search = function(opts)
	require("mylib52")
	--
	if not os.isFileExist(git_top()..'/TAGS') then
		os.execute2('cd "'..git_top()..'"', 'gitv etags')
	end
	if not os.isFileExist(git_top()..'/TAGS') then
		utils.notify("builtin.tags", {
			msg = "No tags file found. Create one with 'gitv ts main'",
			level = "ERROR",
		})
		return
	end
	if os.isFileExist(git_top()..'/.gitvconfig') then
		dofile(git_top()..'/.gitvconfig')
	end
	local tags=getTagList(git_top()..'/TAGS', opts.key,'')
	if not g_tagFallbackPath then
		g_tagFallbackPath={}
	end
	for i=1,#g_tagFallbackPath do
		--local path=git_top()..'/'..g_tagFallbackPath [i]
		local fallbackPath=g_tagFallbackPath [i]
		if fallbackPath:sub(-1)=='/' then
			fallbackPath=fallbackPath:sub(1,-2)
		end
		local path=os.relativeToAbsolutePath(fallbackPath, git_top())
		if os.isFileExist(path) then
			print('tag searching '..g_tagFallbackPath[i])
			local tags2=getTagList(path..'/TAGS', opts.key, '-'..tonumber(i))
	  	array.concat(tags, tags2)
		end
	end

  pickers.new(opts, {
    prompt_title = "gitv ts",
    finder = finders.new_table {
      results = tags
    },
    sorter = conf.generic_sorter(opts),
	attach_mappings = function(prompt_bufnr, map)
		actions.select_default:replace(function()
			actions.close(prompt_bufnr)
			local selection = action_state.get_selected_entry()
			if not selection then
				return 
			end

			if selection[1] then
				local s,e =string.find(selection[1], '|%-')
				if s then
					local filename=selection[1]:sub(s+2)
					if filename:sub(1,1)=='-' then
						filename=g_tagFallbackPath[tonumber(filename:sub(2,2))]..'/'..filename:sub(3)
					end
					local s,e =string.find(filename, ':')
					if s then
						local file=os.relativeToAbsolutePath(filename:sub(1,s-1), git_top())
						--vim.cmd("edit "..git_top()..'/'..filename:sub(1,s-1))
						vim.cmd("edit "..file)
						vim.api.nvim_win_set_cursor(0, { tonumber(filename:sub(s+1)), 0 })
					end
				end
			end
		end)
		return true
	end,
  }):find()
end
return require("telescope").register_extension {
  setup = function(ext_config, config)
    -- access extension config and user config
  end,
  exports = {
    gitv = tag_search,
	gitv_files =file_search
  },
}
