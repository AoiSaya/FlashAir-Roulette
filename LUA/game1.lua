-----------------------------------------------
-- game1: Simple roulette for FlashAir Roulette
-- under the BSD-2-Clause, Copyright 2018 AoiSaya
-- 2018/08/02 rev.0.05
-----------------------------------------------
require "/LUA/libRoulette"

-- 定数
local SPEED_MAX  = 100 --速度の上限。SPEED_STOP+SPEED_DEC*7より大きいこと
local SPEED_INC  =  20 --増速時の幅
local SPEED_DEC  =   1 --減速時の幅
local SPEED_STOP =   3 --この速度以下なら止める。SPEED_DECより大きいこと
--
local number = 0 -- LEDの番号
local speed  = 0 -- ルーレットのスピード
local step   = 1 -- ルーレットのステップ
local i      = 0
local Abutton, Bbutton

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

--    for i = 0,7 do light(i) end --全LEDを弱く光らせる
--    i = (i+1)%80; light((i-i%10)/10) --全LEDを順番に光らせる
--    light((number-1)%8); light((number+1)%8) --前後を弱く光らせる
    light(number)
    sleep(20)
    collectgarbage()
  else
-- 回っているときの処理 --
    number = (number + step + 8) % 8
    lightBuz(number,1) --軽く音を鳴らす
    sleep(1)
    lightBuz(number,2)
    lightBuz(number,3)

    sleepTime = 1000/speed
-- デバッグ中に間違って不正な値でsleepしないようにする保険
    if sleepTime<0 then sleepTime=0 end
-- sleep時間で回る速さを表現する
    sleep(sleepTime)
  end
end
