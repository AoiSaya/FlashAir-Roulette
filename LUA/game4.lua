-----------------------------------------------
-- game4: AP Finder for FlashAir Roulette
-- under the BSD-2-Clause, Copyright 2018 AoiSaya
-- 2018/08/02 rev.0.06
-----------------------------------------------
require "/LUA/libRoulette"

local number = 3 -- LEDの番号
local i      = 0
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

fa.Disconnect()

while noBreak() do -- FTLE(FlashTools Lua Editor)のBreakで止められる
  local count = fa.Scan()

  if count>0 then
    ssid,other = fa.GetScanInfo(0)
    level = 100-other.RSSI
  else
    level = 0
  end

  Abutton,Bbutton = light(number)
  if Abutton==1 or Bbutton==1 then --long range
    number = (level-(level%9))/9-2
  else                             --short range
    number = (level-(level%4))/4-12
  end
  if number>7 then
    number=7
  elseif number<0 then
    number=0
  end
  lightBuz(number,1)
  sleep(1)
  lightBuz(number,2)
  sleep(1)
  lightBuz(number,3)
  collectgarbage()
end
