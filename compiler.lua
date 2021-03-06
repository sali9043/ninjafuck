gg.toast('Script compiler v3.7')
-- https://gameguardian.net/forum/files/file/146-script-compiler/

if gg.BUILD < 15386 then
	gg.alert('You are using an old version of GameGuardian. Some functions may not work, or work not as expected.')
end

local g = {}
g.last = gg.getFile()
g.info = nil

g.config = gg.getFile():gsub('%lua$', '')..'cfg'
g.data = loadfile(g.config)
if g.data ~= nil then
	g.info = g.data()
	g.data = nil
end

if g.info == nil then
	g.info = {g.last, g.last:gsub('/[^/]+$', ''), nil}
end
if g.info[3] == nil then g.info[3] = gg.VERSION end
if g.info[4] == nil then g.info[4] = 400 end

while true do
	g.info = gg.prompt({'Select script/assemble file:', 'Select writable path for output:',
		'Use GameGuardian version:', 'Min size for log call "load"'}, g.info, {'file', 'path', 'text', 'number'})
	if g.info == nil then break end
	gg.saveVariable(g.info, g.config)
	gg.VERSION = g.info[3]
	gg.VERSION_INT = tonumber((gg.VERSION:gsub('%.[0-9]+', function (m)
		m = m:sub(2)
		if #m == 1 then m = '0'..m end
		return m
	end)))
	print('Use GameGuardian version: '..gg.VERSION..' ['..gg.VERSION_INT..']')
	g.last = g.info[1]
	g.test, g.err = loadfile(g.last)
	g.loaded = g.last
	if g.test == nil then
		if g.err == nill then g.err = 'Unknown error' end
		print(g.err)
		gg.alert('Failed load/assemble script: '..g.last..'\n\n'..g.err)
	else
		g.name = g.last:match('[^/]+$')
		g.pathes = {g.info[2]:gsub('/?$', '')..'/'..g.name, g.last, '/sdcard/'..g.name, gg.getFile():gsub('[^/]+$', '')..g.name, gg.EXT_FILES_DIR..'/'..g.name}
		g.file = nil
		g.out = ''
		g.try = ''
		for i, v in ipairs(g.pathes) do
			g.out = v..".tmp.lua"
			g.file = io.open(g.out, "w")
 			if g.file ~= nil then
 				g.last = v:gsub('%.lua$', '')
 				break
			end
			g.try = g.try..' '..v
		end
		if g.file == nil then
			gg.alert('Failed write to file. Checked:'..g.try)
		else
			g.file:close()
			os.remove(g.out)

			g.sel = gg.choice({
				'Compile with debug info (with remove garbage code)', -- 1
				'Compile without debug info (with remove garbage code)', -- 2
				'Disassemble', -- 3
				'Log all GG calls and dump all data for call "load"', -- 4
				'Log all GG calls', -- 5
				'Dump all data for call "load"', -- 6
				'Password cracker', -- 7
				'Reassemble with remove garbage', -- 8
			})
			if g.sel == nil then break end

			g.warn = function() return gg.alert('Scripts in binary form may not work on other versions of GameGuardian', 'Agree', 'Disagree') end

			if g.sel == 1 or g.sel == 2 then
				if g.warn() ~= 1 then break end

				g.out = g.last..".bin.lua"
				g.file = io.open(g.out, "w")
				g.file:write(string.dump(g.test, g.sel == 2, true))
				g.file:close()
				gg.alert('The binary script is saved to the file:\n\n'..g.out)
				break
			elseif g.sel == 3 then
				g.out = g.last..".lasm"
				g.res = gg.internal2(g.test, g.out)
				if g.res then
					gg.alert('The disassemble of the script is saved to the file:\n\n'..g.out)
					break
				else
					gg.alert('An error occurred while disassembling the script:\n\n'..g.res)
				end
			elseif g.sel == 4 or g.sel == 5 or g.sel == 6 then
				if true then
					local ggg = {}
					for k, v in pairs(gg) do
						ggg[k] = v
					end

					local sel = select
					local typ = type
					local str = tostring
					local echo = print
					local io_open = io.open
					local tr = {}
					local slen = string.len

					local msg = ''
					local rnd = g.last..'_'..os.time()..'_'..math.random()

					if g.sel == 4 or g.sel == 6 then
						local load_cnt = 0
						local fname = rnd..'.load.tar'

						local min_size = tonumber(g.info[4])

						local sfmt = string.format
						local sbyte = string.byte
						local ssub = string.sub

						local tar_end = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"

						local f = nil
						local flen = 0
						local tar_put = function (content)
							if f == nil then
								f = io_open(fname, 'wb')
								f:setvbuf('no')
							end
							local size = slen(content)
							local checksum = 4684

							local s7 = sfmt('%07d', load_cnt)
							do
								local b1, b2, b3, b4, b5, b6, b7 = sbyte(s7, 1, 7)
								checksum = checksum + b1 + b2 + b3 + b4 + b5 + b6 + b7
							end
							local s11 = sfmt('%011o', size)
							do
								local b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11 = sbyte(s11, 1, 11)
								checksum = checksum + b1 + b2 + b3 + b4 + b5 + b6 + b7 + b8 + b9 + b10 + b11
							end

							local hdr = "load_"..
								s7..
								".lua\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x000000666\x000000000\x000002004\x00"..
								s11..
								"\x0000000000000\x00"..
								sfmt('%06o', checksum)..
								"\x00 0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00ustar00\x00root\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00sdcard_r\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"

							--echo('Hooked load '..load_cnt..' with size of '..size..' bytes')
							load_cnt = load_cnt + 1

							if load_cnt ~= 1 then
								f:seek('set', flen)
							end
							if size < 512 then
								f:write(hdr..content..ssub(tar_end, 1, 512 - size)..tar_end)
								flen = flen + 1024
							else
								f:write(hdr):write(content)

								local pad = size % 512
								if pad > 0 then
									f:write(ssub(tar_end, 1, 512 - pad)..tar_end)
									flen = flen + 1024 + size - pad
									return
								end

								f:write(tar_end)
								flen = flen + 512 + size
							end
						end

						for i, v in pairs({load=1, loadfile=0, dofile=0}) do
							local orig = _G[i]
							local hook = 1
							local type = v
							hook = function (...)
								local content = ...
								if type == 0 and content ~= nil then
									local f = io_open(content, "rb")
									if f ~= nil then
										content = f:read("*a")
										f:close()
									else
										content = nil
									end
								end
								if content ~= nil then
									local ret = nil
									local total = 0
									local file = fname..load_cnt..'.lua'
									if type == 1 and typ(content) == 'function' then
										local cache = ''
										local func = function (...)
											local ret = content(...)
											if ret ~= nil then
												if ret ~= '' then
													cache = cache + ret
													total = total + slen(ret)
												end
											else
												if total ~= 0 and slen(content) >= min_size then
													tar_put(cache)
												end
											end
											return ret
										end
										ret = orig(func, sel(2, ...))
									else
										if content ~= '' and slen(content) >= min_size then
											tar_put(content)
										end
										ret = orig(...)
									end
									return ret
								end
								return orig(...)
							end
							tr[hook] = orig
							_G[i] = hook
						end

						msg = msg..'\n\nAll data from calls "load" will be dumped into tar archive: '..fname
					end

					if g.sel == 4 or g.sel == 5 then
						local file = rnd..'.log'
						local f = io_open(file, 'wb')
						f:write("-- Hook started\n")
						f:close()
						local names = {
							allocatePage = {'^PROT_', '0x%X'},
							copyMemory = {'0x%X', '0x%X'},
							dumpMemory = {'0x%X', '0x%X'},
							gotoAddress = {'0x%X'},
							setRanges = {'^REGION_'},
							searchNumber = {nil, '^TYPE_', nil, '^SIGN_[^F]', '0x%X', '0x%X'},
							refineNumber = {nil, '^TYPE_', nil, '^SIGN_[^F]', '0x%X', '0x%X'},
							startFuzzy = {'^TYPE_', '0x%X', '0x%X'},
							searchFuzzy = {nil, '^SIGN_FUZZY_', '^TYPE_', '0x%X', '0x%X'},
							searchAddress = {nil, '0x%X', '^TYPE_', '^SIGN_[^F]', '0x%X', '0x%X'},
							refineAddress = {nil, '0x%X', '^TYPE_', '^SIGN_[^F]', '0x%X', '0x%X'},
							getResults = {nil, nil, '0x%X', '0x%X', nil, nil, '^TYPE_', nil, '^POINTER_'},
							editAll = {nil, '^TYPE_'},
							loadList = {nil, '^LOAD_'},
							saveList = {nil, '^SAVE_'},
						}
						names.refineAddress = names.searchAddress
						names.refineNumber = names.searchNumber
						local rets = {
							alert = 1,
							prompt = 1,
							choice = 1,
							multiChoice = 1,
						}
						local smatch = string.match
						local ssub = string.sub
						local sformat = string.format
						local toFlags = function (check, value)
							local ret = ''
							for k, v in pairs(ggg) do
								if smatch(k, check) ~= nil and (value & v) == v then
									if ret ~= '' then ret = ret..' | ' end
									ret = ret..'gg.'..k
									value = value & ~v
								end
							end
							if ret == '' or value ~= 0 then
								if ret ~= '' then ret = ret..' | ' end
								ret = ret..value
							end
							return ret
						end
						local f = nil
						for i, v in pairs(ggg) do
							if typ(v) == 'function' and i ~= 'getFile' and i ~= 'getLine' and i ~= 'isVisible' then
								local orig = v
								local name = i
								local hook = 1
								hook = function (...)
									local arg = {...}
									if f == nil then
										f = io_open(file, 'ab')
										f:setvbuf('no')
									end
									local pre = 'gg.'..name..'('
									for j, a in ipairs(arg) do
										if j ~= 1 then pre = pre..', ' end
										if typ(a) == 'string' then pre = pre..'"' end
										local b = a
										if typ(a) == 'number' and names[name] ~= nil and names[name][j] ~= nil then
											local check = names[name][j]
											if ssub(check, 1, 1) ~= '^' then
												if a == 0 or a == -1 then
													b = a
												else
													b = sformat(check, a)
												end
											else
												b = toFlags(check, a)
											end
										end
										b = str(b)
										if slen(b) >= 8192 then
											f:write(pre)
											f:write(b)
											pre = ''
										else
											pre = pre..b
											if slen(pre) >= 8192 then
												f:write(pre)
												pre = ''
											end
										end
										if typ(a) == 'string' then pre = pre..'"' end
									end
									pre = pre..')'
									if rets[name] ~= nil then
										local ret = orig(...)
										local b = str(ret)
										if slen(b) >= 8192 then
											f:write(pre.." --[[ ")
											f:write(b)
											f:write(" ]]\n")
										else
											f:write(pre.." --[[ "..b.." ]]\n")
										end
										return ret
									end
									f:write(pre.."\n")
									return orig(...)
								end
								tr[hook] = orig
								gg[i] = hook
							end
						end

						msg = msg..'\n\nAll GG calls will be logged into file: '..file
					end

					ggg.prompt({'Just press ok:'}, {g.loaded}, {'file'})

					echo('Hook started.'..msg..'\n')
					ggg.alert('Hook started. Run script, input passwords and so on.'..msg)
					msg = nil

					if true then
						local orig = string.dump
						local hook = 1
						hook = function (...)
							local arg1 = ...
							if tr[arg1] ~= nil then
								--echo('string.dump:', tr[arg1], arg1)
								arg1 = tr[arg1]
							end
							return orig(arg1, sel(2, ...))
						end
						tr[hook] = orig
						string.dump = hook
					end
					if true then
						local orig = tostring

						local rm = table.remove
						local store = {}
						local build_table = 1
						build_table = function (src, dst)
							local cnt = #store
							store[src] = dst
							for k, v in pairs(src) do
								if tr[v] ~= nil then
									dst[k] = tr[v]
								else
									if typ(v) == 'table' then
										if store[v] ~= nil then
											dst[k] = store[v]
										else
											local bt = {}
											store[v] = bt
											dst[k] = bt
											build_table(v, bt)
										end
									else
										dst[k] = v
									end
								end
							end
							if cnt == 0 then
								while #store > 0 do
									rm(store)
								end
							end
							return dst
						end

						local hook = 1
						hook = function (...)
							local old = tostring
							local arg1 = ...
							if tr[arg1] ~= nil then
								--tostring = orig; echo('tostring 1:', tr[arg1], arg1) tostring = old
								arg1 = tr[arg1]
							else
								if typ(arg1) == 'table' then
									arg1 = build_table(arg1, {})
								end
							end
							local ret = orig(arg1, sel(2, ...))
							--tostring = orig; echo('tostring 2:', arg1, ret) tostring = old
							tostring = old
							return ret
						end
						tr[hook] = orig
						tostring = hook
					end
					if true then
						for k, v in pairs({'getupvalue', 'upvalueid'}) do
							local orig = debug[v]
							local hook = 1
							hook = function (...)
								local arg1 = ...
								if tr[arg1] ~= nil then
									--echo('debug.', v, ':', tr[arg1], arg1)
									arg1 = tr[arg1]
								end
								return orig(arg1, sel(2, ...))
							end
							tr[hook] = orig
							debug[v] = hook
						end
					end
					if true then
						local orig = debug.getinfo
						local hook = 1
						hook = function (...)
							local arg1 = ...
							if arg1 ~= nil and tr[arg1] ~= nil then
								arg1 = tr[arg1]
							end
							return orig(arg1, sel(2, ...))
						end
						tr[hook] = orig
						debug.getinfo = hook
					end
					if false then
						local orig = os.remove
						local hook = 1
						hook = function (...)
							local arg = {...}
							echo('os.remove:', arg)
							return true
						end
						tr[hook] = orig
						os.remove = hook
					end
					if false then
						local orig = assert
						local hook = 1
						hook = function (...)
							local arg = {...}
							echo('assert:', arg)
							return orig(...)
						end
						tr[hook] = orig
						assert = hook
					end
					if false then
						local orig = io.open
						local hook = 1
						hook = function (...)
							local arg = {...}
							echo('io.open:', arg)
							return orig(...)
						end
						tr[hook] = orig
						io.open = hook
					end
				end
				local test = g.test
				g = nil

				return test()
			elseif g.sel == 7 then
				if true then
					local rnd = g.last..'_'..os.time()..'_'..math.random()
					local pa = math.random(10, 99)
					local ss = math.random(10, 99)
					local file = rnd..'.pass.log'
					local f = io.open(file, 'w')
					gg.alert('Displays possible passwords. Works only for simple protections and if the password is in the code. On the offer to enter the password, you must enter the number "'..pa..ss..'", without spaces or extra characters.')
					local cache = {}
					cache[pa..ss] = 1
					local debug_getlocal = debug.getlocal
					local type_ = type
					local print_ = print
					local pairs_ = pairs
					local hook = function ()
						local stack = {}
						for j = 1, 250 do
							local _, val = debug_getlocal(1, j)
							if val ~= nil then
								local t = type_(val)
								if t == 'string' or t == 'number' then
									stack[val] = 1
								else
									if t == 'table' then
										for i, v in pairs_(val) do
											t = type_(v)
											if t == 'string' or t == 'number' then
												stack[v] = 1
											end
										end
									end
								end
							end
						end
						if stack[pa..ss] ~= nil then
							local buf = ''
							for v, _ in pairs_(stack) do
								if cache[v] == nil then
									print_(v)
									cache[v] = 1
									if f ~= nil then buf = buf..v.."\n" end
								end
							end
							if f ~= nil and buf ~= '' then f:write(buf) end
						end
					end
					debug.sethook(hook, '', 1)
				end

				local test = g.test
				g = nil

				return test()
			elseif g.sel == 8 then
				if g.warn() ~= 1 then break end

				g.out = g.last..".clear.lua"
				g.tmp = g.last..".tmp"

				local notify = (function ()
					local pos = 1
					local last = 0
					local clock = os.clock
					local toast = gg.toast
					local sub = string.sub
					return function()
						local cl = clock()
						if cl - last < 2 then return end
						last = cl
						toast("Please wait "..(sub("-\\|/", pos, pos)))
						if pos < 4 then pos = pos + 1 else pos = 1 end
					end
				end)()

				notify()
				g.chunk = string.dump(g.test, true, true);
				g.len = string.len(g.chunk)
				g.chunk = load(g.chunk)
				for i = 1, 10 do
					local changed = false
					notify()
					g.res = gg.internal2(g.chunk, g.out)
					if not g.res then
						os.remove(g.tmp)
						gg.alert('An error occurred while disassembling the script:\n\n'..g.res)
						os.exit()
					end

					notify()
					local file = io.open(g.tmp, "w")
					local lasm = io.open(g.out, 'r')
					local last = ''
					while true do
						local buf = lasm:read(65536)
						if not buf then
							file:write(last)
							break
						end
						buf = last..buf
						local out, cnt = string.gsub(buf, "[^\n]*; garbage\n", ";%0")
						if cnt > 0 then changed = true end
						out, cnt = string.gsub(out, "[^\n]*JMP :goto_[^\n]*; %+0 ↓\n", ";%0")
						if cnt > 0 then changed = true end
						buf = nil

						last = string.match(out, "[^\n]*$")
						file:write(string.sub(out, 1, -1 - string.len(last)))
						notify()
					end
					lasm:close()
					file:close()
					if not changed then
						break
					end
					notify()
					g.chunk = loadfile(g.tmp)
				end
				notify()
				os.remove(g.tmp)

				g.file = io.open(g.out, "w")
				g.chunk = string.dump(g.chunk, true, true)
				g.len2 = string.len(g.chunk)
				g.file:write(g.chunk)
				g.file:close()

				gg.alert(''..g.len..' bytes => '..g.len2..' bytes\n\nThe binary script is saved to the file:\n\n'..g.out)
				break;
			end
		end
	end
end