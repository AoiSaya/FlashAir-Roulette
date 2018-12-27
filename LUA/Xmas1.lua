-----------------------------------------------
-- Xmas1: melody player for FlashAir Roulette
-- under the BSD-2-Clause, Copyright 2018 AoiSaya
-- 2018/12/27 rev.0.04
-----------------------------------------------
require "/LUA/libRoulette"

-- Original MML code by silfia (http://lightwing.ddo.jp/silfia/mmldat/), and arranged by Saya
local music={}
--We wish you a Merry Christmas
music[1]= "o5rt120deaf+g2dgl8gagf+l4eeeal8abagl4f+ddbl8bb+bal4gedeaf+g2r2"..
		  "v15t200dgl8gagf+l4eeeal8abagl4f+ddbl8bb+bal4gedeaf+g2dgggf+2f+gf+ed2abag>d<ddeaf+g2"..
		  "t220dgl8gagf+l4eeeal8abagl4f+ddbl8bb+bal4gedeaf+g2dgl8gagf+"..
		  "l4eeeal8abagl4f+ddbl8bb+bal4gedeaf+g2dgggf+2f+gf+ed2abag>d<d"..
		  "t180dt160et140at120f+t100g2t80eb+bag2."
--ジングルベル
music[2]= "o5r4l8g>edc<g4.gg>edc<a2a>fed<b4.b>ggfde4."..
		  "<gg>edc<g4.gg>edc<a4.aa>fedggggagfdc4g4eee4eee4egc.d16e2fff.f16feeeeddcd4g4"..
		  "eee4eee4egc.d16e2fff.f16feeeggfdc4r4fff.f16feeel4ggabl8b+gaeb+gaeb+gaeb+gae>e1"
--サンタが町にやってくる
music[3]= "o5l4rt140v15b>d<gba>c2ag1r2.l8.rd16c-c16d4d4rd16ef+16g4g2c-c16"..
		  "l4ddde8.d16cc2c-d<gbab+2f+g1.r.l16r>dc-8.cd4d4r8.de8.f+g4g2c-8.c"..
		  "l4ddde8.d16cc2c-d<gbab+2f+g1.r>gagf+gee2gagf+ge2.abag+af+f+f+f+8.g16agf+edr"..
		  "l8.d4&dd16c-c16d4d4rd16ef+16g4g2c-c16"..
		  "l4ddde8.d16cc2c-d<gbab+2f+g1.r2b>d<gbab+2.b>d<gbab+2.b>d<gba>c2ag1&g2."
--もろびとこぞりて
music[4]= "o5l4rt80b+b8.a16g.f8edc.g8a.a8b.l8b>c2.rcc<bagg.f16e>cc<bagg.f16eeeee"..
		  "l16efg4.fed8d8d8def4.edl8cb+4ag.f16efe4d4c2"..
		  "t130r2.rl32fgabl4b+b8.a16g.f8edc.g8a.a8b.l8bb+2.l32fgab>"..
		  "l8c.<b.agg.f16e>cc<bagg.f16eeeeel16efg4.fed8d8d8def4.ed"..
		  "l8cb+4ag.f16efl4edc2"

local number = 4 -- LEDの番号
local musicNo= 1 -- 楽曲番号
local Abutton, Bbutton
local speed, rario

-- GPIOが使えないときは終了
if readyGpio()==false then
	return
end

-- A,Bボタンが離されるまで待つ --
repeat
	sleep(100)
	Abutton,Bbutton = light(number)
until Abutton==0 and Bbutton==0

speed = 1
ratio = 0.6
if fa.websocket==nil then -- W-03 check
	speed = 3/4
end

while noBreak() do -- FTLE(FlashTools Lua Editor)のBreakで止められる
	Abutton,Bbutton = lightPlay(music[musicNo],speed,ratio)
	if Abutton==1 then
		ratio = (ratio % 1) + 0.2
	else
		musicNo = (musicNo % #music)+1
	end
	sleep(500)
-- A,Bボタンが離されるまで待つ --
	repeat
		sleep(100)
		Abutton,Bbutton = light(number)
	until Abutton==0 and Bbutton==0
end
