-----------------------------------------------
-- Xmas1: melody player for FlashAir Roulette
-- under the BSD-2-Clause, Copyright 2018 AoiSaya
-- 2018/12/14 rev.0.01
-----------------------------------------------
require "/LUA/libRoulette"

local number = 3 -- LEDの番号
local i 	 = 0
local Abutton, Bbutton
local ssid,other
local level = 0 --電波強度

-- GPIOが使えないときは終了
if readyGpio()==false then
	return
end

-- A,Bボタンが離されるまで待つ --
repeat
  sleep(100)
  Abutton,Bbutton = light(number)
until Abutton==0 and Bbutton==0

while noBreak() do -- FTLE(FlashTools Lua Editor)のBreakで止められる



function light_play(music)
  local c, v, d, t, s
  local pushtime = 50
  local ret = ret_OK
  local oct = 4
  local noc = oct
  local len = 4
  local tmp = 140
local u={} -- spi parameter
u["c-"] =  72047.6
u["c"]	=  68002.7
u["c+"] =  64184.8
u["d-"] =  u["c+"]
u["d"]	=  60581.2
u["d+"] =  57179.9
u["e-"] =  u["d+"]
u["e"]	=  53969.4
u["e+"] =  u["f"]
u["f-"] =  u["e"]
u["f"]	=  50939.3
u["f+"] =  48079.1
u["g-"] =  u["f+"]
u["g"]	=  45379.5
u["g+"] =  42831.2
u["a-"] =  u["g+"]
u["a"]	=  40426.2
u["a+"] =  38156.0
u["b-"] =  u["a+"]
u["b"]	=  36013.3
u["b+"] =  33990.9

local f={} -- real frequency
f["c-"] = 246.942
f["c"]	= 261.626
f["c+"] = 277.183
f["d-"] = f["c+"]
f["d"]	= 293.665
f["d+"] = 311.127
f["e-"] = f["d+"]
f["e"]	= 329.628
f["e+"] = f["f"]
f["f-"] = f["e"]
f["f"]	= 349.228
f["f+"] = 369.994
f["g-"] = f["f+"]
f["g"]	= 391.995
f["g+"] = 415.305
f["a-"] = f["g+"]
f["a"]	= 440.000
f["a+"] = 466.164
f["b-"] = f["a+"]
f["b"]	= 493.883
f["b+"] = 523.251

local ftbl={}
ftbl[" "] = function(v) end
ftbl["o"] = function(v) oct = v; noc = oct; end
ftbl[">"] = function(v) oct = oct+1; noc = oct; end
ftbl["<"] = function(v) oct = oct-1; noc = oct; end
ftbl["~"] = function(v) noc = oct+1; end
ftbl["_"] = function(v) noc = oct-1; end
ftbl["l"] = function(v) len = v; end
ftbl["t"] = function(v) tmp = v; end

  music = music:lower()
  n = #music
  for i=1, n do
	c, v, i = get_cmd(music,i)
	frq = f[c]
	if freq!=nil then

	else
	  ftbl[c]()
	end


	if ch=="_" then
	elseif ac>0 then
	  note = nt[ac]
	  offtime = tempo * note - pushtime
	else
	  d = dt[ch]
	  fa.pio(d,d)
	  sleep(pushtime)
	  fa.pio(d,0x00)
	  fa.pio(0x00,0x00)
	  t = offtime

	  while t>50 do
		s,indata = fa.pio(0x00,0x00)
		if s==0 or indata>0 then
		  ret = ret_BREAK
		  break
		end
		t = t-50
		sleep(50)
	  end
	  if ret>0 then
		break
	  end
	  sleep(t)
	end
  end
  return ret
end

nt = {1, 1/2, 1/2+1/4, 1/4, 1/4+1/8, 1/16, 1/16+1/32, 1/8, 1/8+1/16}
ct = {6,6,7,8,8,9,4,4,4,5,5,5,5,2,2,2,2,2,2,2,3,3,3,3,3,3,3}
--	  1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7
dt = {}
dt["c"]=0x01
dt["d"]=0x02
dt["e"]=0x04
dt["f"]=0x08
dt["g"]=0x11
dt["a"]=0x12
dt["b"]=0x14
dt["C"]=0x18
dt["_"]=0x00
dt["-"]=0x00
dt["C+c"]=0x19
dt["C+d"]=0x1a
dt["C+e"]=0x1c
dt["C+cd"]=0x1b
dt["C+ce"]=0x1d
dt["C+de"]=0x1e
dt["C+cde"]=0x1f
rt={}
rt[0x01]="c"
rt[0x02]="d"
rt[0x04]="e"
rt[0x08]="f"
rt[0x11]="g"
rt[0x12]="a"
rt[0x14]="b"
rt[0x18]="C"
tempo = 128*22
note = 1/4

cmd = 0x00
push_key = 0x00
hold_key = 0x00
en_wlan  = 0

result = fa.control("fioset", en_wlan)
cmd = play_melody(start_music)

while 1 do
  if cmd==ret_ERR then
	break
  elseif push_key==dt["C+c"] then
	cmd, music = record_melody()
	cmd = play_melody(music)
  elseif push_key==dt["C+d"] then
	cmd = play_melody(music)
  elseif push_key==dt["C+e"] then
	cmd = play_melody(demo_music1)
	cmd = play_melody(demo_music2)
	cmd = play_melody(demo_music3)
	cmd = play_melody(demo_music4)
	cmd = play_melody(demo_music5)
	cmd = play_melody(demo_music6)
	cmd = play_melody(demo_music7)
  elseif push_key==dt["C+cd"] then
	en_wlan  = 1-en_wlan
	result = fa.control("fioset", en_wlan)
	cmd = play_melody(wlan_music)
  elseif push_key==dt["C+cde"] then
	cmd = play_melody(end_music)
	break
  elseif hold_key==dt["c"] then
	cmd = play_melody(demo_music1)
  elseif hold_key==dt["d"] then
	cmd = play_melody(demo_music2)
  elseif hold_key==dt["e"] then
	cmd = play_melody(demo_music3)
  elseif hold_key==dt["f"] then
	cmd = play_melody(demo_music4)
  elseif hold_key==dt["g"] then
	cmd = play_melody(demo_music5)
  elseif hold_key==dt["a"] then
	cmd = play_melody(demo_music6)
  elseif hold_key==dt["b"] then
	cmd = play_melody(demo_music7)
  end
  s, indata, push_key, hold_key = get_key(20)
  if s==0 then
	cmd = ret_ERR
	break
  end
  sleep(50)
end

print(music)
