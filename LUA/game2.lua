-----------------------------------------------
-- game2: Double roulette for FlashAir Roulette
-- under the BSD-2-Clause, Copyright 2018 AoiSaya
-- 2018/08/02 rev.0.06
-----------------------------------------------
require "/LUA/libRoulette"

-- 定数
local SPEED_MAX  = 100 --速度の上限。SPEED_STOP+SPEED_DEC*7より大きいこと
local SPEED_INC  =  20 --増速時の幅
local SPEED_DEC  =   1 --減速時の幅
local SPEED_STOP =   5 --この速度以下なら止める。SPEED_DECより大きいこと
--
local number1 = 1 -- 1個目の番号
local number2 = 1 -- 2個目の番号
local speed   = 0 -- ルーレットのスピード
local step1   = 1 -- ルーレットのステップ
local step2   = 3 -- ルーレットのステップ
local i       = 0
local Abutton, Bbutton

-- GPIOが使えないときは終了
if readyGpio()==false then
    return
end

-- A,Bボタンが離されるまで待つ --
repeat
  sleep(100)
  Abutton,Bbutton = light(number1)
until Abutton==0 and Bbutton==0

-- メインの処理 --
while noBreak() do -- FTLE(FlashTools Lua Editor)のBreakで止められる
  Abutton,Bbutton = light(number1)

-- ルーレットの回し方をボタンで変える
  if Abutton==1 then step1 =  -1; end
  if Bbutton==1 then step1 =   1; end

-- ボタンを押してると加速、離してると減速させる
  if Abutton==1 or Bbutton==1 then
    if speed<SPEED_MAX then
        speed = speed + SPEED_INC
    end
  else
    speed = speed - SPEED_DEC
  end

  if speed<SPEED_STOP then
-- 止まっているときの処理 --
-- 押し時間でズルができないように初期値をばらつかせる
    if speed<-7 then speed=0 end
-- ステップ幅もばらつかせる
    step2 = step2 % 5 + 2
    for i = 1,10 do
      lightBuz(number1,3)
      sleep(1)
      lightBuz(number2,3)
      sleep(1)
    end
    collectgarbage()
  else
-- 回っているときの処理 --
    number1 = (number1 + step1 + 8) % 8
    number2 = (number2 + step2 + 8) % 8
    lightBuz(number1,1) --軽く音を鳴らす
    sleep(1)
    lightBuz(number1,2)

    sleepTime = 1000/speed
-- デバッグ中に間違って不正な値でsleepしないようにする保険
    if sleepTime<0 then sleepTime=0 end
-- sleep時間で回る速さを表現する
    for i = 1,sleepTime/2 do
      lightBuz(number1,3)
      sleep(1)
      lightBuz(number2,3)
      sleep(1)
    end
  end
end
