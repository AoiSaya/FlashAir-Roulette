-----------------------------------------------
-- game3: Demonstration for FlashAir Roulette
-- under the BSD-2-Clause, Copyright 2018 AoiSaya
-- 2018/08/02 rev.0.02
-----------------------------------------------
require "/LUA/libRoulette"

-- 定数
local SPEED_MAX  =  200 --速度の上限
local SPEED_MIN  =  4 --速度の下限
--
local number = 2 -- LEDの番号
local speed  = SPEED_MIN -- ルーレットのスピード
local step   = 3 -- ルーレットのステップ
local i      = 0
local Abutton, Bbutton
local numberNext -- 次のLED番号

-- GPIOが使えないときは終了
if readyGpio()==false then
    return
end

-- A,Bボタンが離されるまで待つ --
repeat
  sleep(100)
  Abutton,Bbutton = light(number)
until Abutton==0 and Bbutton==0

-- メインの処理 --
while noBreak() do -- FTLE(FlashTools Lua Editor)のBreakで止められる
  Abutton,Bbutton = light(number)

-- ルーレットの回し方をボタンで変える
  if Bbutton==1 then step = 1 end
  if Abutton==1 then step = 3 end -- ３ステップずつ回す

-- ボタンを押してると加速
  if Abutton==1 or Bbutton==1 then
    if speed>SPEED_MAX then
      speed = SPEED_MIN
    else
      speed = speed * 2
    end
    repeat
      sleep(1)
      Abutton,Bbutton = light(number)
    until Abutton==0 and Bbutton==0
  end

-- 回っているときの処理 --
  numberNext = (number + step + 8) % 8
  sleepTime = 1000/speed
-- デバッグ中に間違って不正な値でsleepしないようにする保険
  if sleepTime<0 then sleepTime=0 end
-- sleep時間で回る速さを表現する
  for i=1, sleepTime do
    lightBuz(number,3)
    for j=i*5, sleepTime*5 do end
    lightBuz(numberNext,3)
    for j=1, i*5 do end
  end
  number = numberNext
  sleep(sleepTime)
end
