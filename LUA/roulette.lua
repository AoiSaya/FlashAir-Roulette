-----------------------------------------------
-- Luncher for FlashAir Roulette
-- under the BSD-2-Clause, Copyright 2018 AoiSaya
-- 2018/12/16 rev.0.08 turn off wi-fi for save battery
-----------------------------------------------
require "/LUA/libRoulette"

-- GPIOが使えないときは終了
if readyGpio()==false then
	return
end

local number = 7
local Abutton,Bbutton = light(number)

if Abutton==1 and Bbutton==0 then
	fa.control("fioset", 0)
	require "/LUA/game2"
elseif Abutton==0 and Bbutton==1 then
	fa.control("fioset", 0)
	require "/LUA/game3"
elseif Abutton==1 and Bbutton==1 then
	number = 3
-- A,Bボタンのどちらかが離されるまで待つ --
	repeat
		sleep(100)
		Abutton,Bbutton = light(number)
	until Abutton==0 or Bbutton==0
	if Abutton==0 then
		require "/LUA/game4"
	else
--	fa.control("fioset", 0)
		require "/LUA/Xmas1"
	end
else
	fa.control("fioset", 0)
  require "/LUA/game1"
end

return
