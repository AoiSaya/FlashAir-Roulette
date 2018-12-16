-----------------------------------------------
-- function libraly for FlashAir Roulette
-- under the BSD-2-Clause, Copyright 2018 AoiSaya
-- 2018/12/16 rev.0.09
-----------------------------------------------
if _libRoulette_ then
  return
else
  _libRoulette_ = true
end

------------------------------------------------
-- GPIO機能が使える状態かを確認する
-- ret = readyGpio()
-- 使い方：
-- ０番を光らせ、AボタンとBボタンの状態を読む
--	 ret = readyGpio()
-- 戻り値retは true:使用可能、false:使用できない
------------------------------------------------
function readyGpio()
  local ctrl = 0x10
  local data = 0x10
  local s = fa.pio(ctrl, data)
  local ret = (s==1)

  return ret
end

------------------------------------------------
-- 指定したnumber（0～7）のLEDを光らせ、ボタンの状態を確認する関数
-- Abutton,Bbutton = light(number)
-- 使い方：
-- ０番を光らせ、AボタンとBボタンの状態を読む
--	 Abutton,Bbutton = light(0)
-- 戻り値はどちらも 1:ボタンを押している、0:ボタンを押してない
------------------------------------------------
function light(number)
  local ctrl = 0x1C
  local data = number*4
  fa.pio(ctrl, data)
  sleep(1)
  local s, indata = fa.pio(ctrl, data)
  local Abutton = 1 - bit32.band(indata,0x02)/2
  local Bbutton = 1 - bit32.band(indata,0x01)

  return Abutton,Bbutton
end

------------------------------------------------
-- 指定したnumber（0～7）のLEDを光らせ、スピーカを動かす関数
--	 lightBuz(number,buz)
-- 使い方：
-- LED １番を光らせ、スピーカーを動かす
--	 方法１） lightBuz(1,1) と lightBuz(1,2)の交互 （音量大）
--	 方法２） lightBuz(1,2) と lightBuz(1,3)の交互 （音量小）
-- 戻り値なし
-- 止めるときは lightBuz(number,3) を実行するとよい
------------------------------------------------
function lightBuz(number,buz)
  local ctrl = 0x1F
  local data = number*4 + buz
  fa.pio(ctrl, data)

  return
end

------------------------------------------------
-- Breakされていない（動作継続OK）ことを確認する関数
--	 ret = noBreak()
-- 使い方：
--	 ret = noBreak()
-- 戻り値retは true:動作継続、false:Breakせよ
------------------------------------------------
function noBreak()
  return (fa.sharedmemory("read", 0x00, 0x01, "") ~= "!")
end

fa.sharedmemory("write", 0x00, 0x01, "-")

------------------------------------------------
-- MMLのコマンドを分解する関数
--	 cmd,len,i = getMMLcmd(mml,i)
-- 引数
-- mml: MML文字列
-- i  : MML文字列をコマンド解釈する位置
-- 戻り値
-- cmd: MMLコマンド
-- val: cmdに伴う数字
-- i  : 次のコマンドの位置
-- 使い方：
--	 cmd,val,i = getMMLcmd("C4DEFG",i)
------------------------------------------------
function getMMLcmd(mml,i)
  local cmd, opt, val, dot, num

  cmd = mml:sub(i,i)
  opt = mml:sub(i+1,i+1)
  if opt=="+" or opt=="-" then
	cmd = cmd..opt
	i = i+1
  elseif opt=="#" then
	cmd = cmd.."+"
	i = i+1
  end
  val = 0
  dot = 0
  num = 0
  while noBreak() do
	i = i+1
	opt = mml:sub(i,i)
	num = tonumber(opt)
	if opt=="." then
	  dot = dot*2; val = 1/(1/val+1/dot)
	elseif num then
	  val = val*10+num; dot = val
	else
	  break
	end
  end

  return cmd,val,i
end

------------------------------------------------
-- BEEPを発生する関数
--	  beep(ctrl,data,period,num)
-- 引数
-- ctrl: fa.spiと同じ
-- data: fa.spiと同じ
-- period: fa.spiと同じ
-- num: 音の長さ
-- 戻り値なし
------------------------------------------------
function beep(ctrl,data,period,num,vol)
    local wav
    
    if vol>=12 then
    	wav = string.rep('\x55', num)
    else
		period=period*2
    	wav = string.rep('\xFF', num/2)
	end

    fa.spi("mode",0)
	fa.spi("bit",2)
	fa.spi("init",period)
	fa.pio(ctrl,data)
	fa.spi("write",wav)
	wav=""
	collectgarbage()
end
------------------------------------------------
-- MMLを演奏する関数
--	 Abutton,Bbutton = lightPlay(mml,speed,ratio)
-- 引数
-- mml: MML文字列
-- speed: スピード調整
-- ratio: 音符の長さ中の発音時間の比率
-- 戻り値はどちらも 1:ボタンを押している、0:ボタンを押してない
-- 使い方：
--	 Abutton,Bbutton = lightPlay("C4DEFG")
------------------------------------------------
function lightPlay(mml,speed,ratio)
	local n, i, cmd, val, frq, period, number
	local ctrl, data, num, wait, wav
	local Abutton,Bbutton
	local oct = 4
	local noc = oct
	local len = 4
	local tmp = 120
	local vol = 11.625

local ptbl={} -- spi periad table
ptbl["r"]  =  0
ptbl["c-"] =  72047.6
ptbl["c"]  =  68002.7
ptbl["c+"] =  64184.8
ptbl["d-"] =  ptbl["c+"]
ptbl["d"]  =  60581.2
ptbl["d+"] =  57179.9
ptbl["e-"] =  ptbl["d+"]
ptbl["e"]  =  53969.4
ptbl["e+"] =  ptbl["f"]
ptbl["f-"] =  ptbl["e"]
ptbl["f"]  =  50939.3
ptbl["f+"] =  48079.1
ptbl["g-"] =  ptbl["f+"]
ptbl["g"]  =  45379.5
ptbl["g+"] =  42831.2
ptbl["a-"] =  ptbl["g+"]
ptbl["a"]  =  40426.2
ptbl["a+"] =  38156.0
ptbl["b-"] =  ptbl["a+"]
ptbl["b"]  =  36013.3
ptbl["b+"] =  33990.9

local ftbl={} -- target frequency table
ftbl["r"]  = 0
ftbl["c-"] = 246.942
ftbl["c"]  = 261.626
ftbl["c+"] = 277.183
ftbl["d-"] = ftbl["c+"]
ftbl["d"]  = 293.665
ftbl["d+"] = 311.127
ftbl["e-"] = ftbl["d+"]
ftbl["e"]  = 329.628
ftbl["e+"] = ftbl["f"]
ftbl["f-"] = ftbl["e"]
ftbl["f"]  = 349.228
ftbl["f+"] = 369.994
ftbl["g-"] = ftbl["f+"]
ftbl["g"]  = 391.995
ftbl["g+"] = 415.305
ftbl["a-"] = ftbl["g+"]
ftbl["a"]  = 440.000
ftbl["a+"] = 466.164
ftbl["b-"] = ftbl["a+"]
ftbl["b"]  = 493.883
ftbl["b+"] = 523.251

local ntbl={} -- command N table
ntbl[0] = "c"
ntbl[1] = "c+"
ntbl[2] = "d"
ntbl[3] = "d+"
ntbl[4] = "e"
ntbl[5] = "f"
ntbl[6] = "f+"
ntbl[7] = "g"
ntbl[8] = "g+"
ntbl[9] = "a"
ntbl[10]= "a+"
ntbl[11]= "b"

local ltbl={} -- light number
ltbl["c-"] = 7
ltbl["c"]  = 7
ltbl["c+"] = 7
ltbl["d-"] = 6
ltbl["d"]  = 6
ltbl["d+"] = 6
ltbl["e-"] = 5
ltbl["e"]  = 5
ltbl["e+"] = 5
ltbl["f-"] = 4
ltbl["f"]  = 4
ltbl["f+"] = 4
ltbl["g-"] = 3
ltbl["g"]  = 3
ltbl["g+"] = 3
ltbl["a-"] = 2
ltbl["a"]  = 2
ltbl["a+"] = 2
ltbl["b-"] = 1
ltbl["b"]  = 1
ltbl["b+"] = 1
ltbl["r"]  = 0

local ctbl={} -- command table
ctbl[" "] = function(v) end
ctbl["o"] = function(v) oct = v; noc = oct; end
ctbl[">"] = function(v) oct = oct+1; noc = oct; end
ctbl["<"] = function(v) oct = oct-1; noc = oct; end
ctbl["~"] = function(v) noc = oct+1; end
ctbl["_"] = function(v) noc = oct-1; end
ctbl["l"] = function(v) len = v; end
ctbl["t"] = function(v) tmp = v; end
ctbl["n"] = function(v) cmd=ntbl[v%12]; noc=(v-v%12)/12+1; val=0; end
ctbl["v"] = function(v) vol = v; end
-- not support
ctbl["["] = function(v) end
ctbl["]"] = function(v) end
ctbl["*"] = function(v) end
ctbl["@"] = function(v) end
ctbl["&"] = function(v) end
ctbl["m"] = function(v) end
ctbl["p"] = function(v) end
ctbl["q"] = function(v) end
ctbl["s"] = function(v) end
ctbl["y"] = function(v) end
--

	mml = mml:lower()
	n = #mml
	i = 1
	number = 0
	Abutton,Bbutton = light(number)

-- while noBreak() and i<=n do
	while noBreak() and i<=n and Abutton==0 and Bbutton==0 do
		cmd, val, i = getMMLcmd(mml,i)
		if cmd=="n" then
			ctbl[cmd](val)
		end
		frq = ftbl[cmd]
		if frq~=nil then
			if val==0 then val=len end
			period = ptbl[cmd]*speed/2^(noc-4)
			num  = 4*60*frq*2^(noc-4)*speed*ratio/(val*tmp)-2
			wait = 4*60*1000*(1-ratio)/(val*tmp)-3
			if num <2 then num =2 end
			if wait<1 then wait=1 end
			noc = oct

			number = ltbl[cmd]
			ctrl = 0x1f
			data = number*4
			if cmd~="r" then
				beep(ctrl,data,period,num,vol)
			else
				Abutton,Bbutton = light(number)
				sleep(wait)
			end
			Abutton,Bbutton = light(number)
			sleep(wait)
		else
			ctbl[cmd](val)
		end
	end
	return Abutton,Bbutton
end

collectgarbage()
