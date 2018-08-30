-----------------------------------------------
-- Luncher for FlashAir Roulette
-- under the BSD-2-Clause, Copyright 2018 AoiSaya
-- 2018/08/02 rev.0.07
-----------------------------------------------
require "/LUA/libRoulette"

-- GPIOが使えないときは終了
if readyGpio()==false then
    return
end

local number = 4
local Abutton,Bbutton = light(number)

if     Abutton==1 and Bbutton==0 then
  require "/LUA/game2"
elseif Abutton==0 and Bbutton==1 then
  require "/LUA/game3"
elseif Abutton==1 and Bbutton==1 then
  require "/LUA/game4"
else
  require "/LUA/game1"
end

return
