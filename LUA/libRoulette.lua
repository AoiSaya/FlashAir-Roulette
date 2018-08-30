-----------------------------------------------
-- function libraly for FlashAir Roulette
-- under the BSD-2-Clause, Copyright 2018 AoiSaya
-- 2018/08/02 rev.0.06
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
--   ret = readyGpio()
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
--   Abutton,Bbutton = light(0)
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
--   lightBuz(number,buz)
-- 使い方：
-- LED １番を光らせ、スピーカーを動かす
--   方法１） lightBuz(1,1) と lightBuz(1,2)の交互 （音量大）
--   方法２） lightBuz(1,2) と lightBuz(1,3)の交互 （音量小）
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
--   ret = noBreak()
-- 使い方：
--   ret = noBreak()
-- 戻り値retは true:動作継続、false:Breakせよ
------------------------------------------------
function noBreak()
  return (fa.sharedmemory("read", 0x00, 0x01, "") ~= "!")
end

fa.sharedmemory("write", 0x00, 0x01, "-")
