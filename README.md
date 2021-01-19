# FlashAir-Roulette

## Overview
Update at 2018/12/16: Release tiny MML player function and Xmas music player.

<img src="https://raw.githubusercontent.com/AoiSaya/FlashAir-Roulette/master/img/Roulette.png" width="400">

I developed and released softwere for FlashAir-Roulette.  
This roulette was designed as FlashAir hands‐on experience for kids & students.  
And the parts kit provided as an extra bonus when FlashAir was purchased at Maker Fair Tokyo 2018.  

~~The parts list and circuit diagrams are available from the following site.  
 [FlashAir Developers .. Maker Fair Tokyo 2018](https://flashair-developers.com/ja/about/events/makerfaire2018tokyo/)~~

## Backup contents
### Event page archive
[Maker Faire Tokyo 2018](manual/MakerFaireTokyo2018.pdf)  


### Tutorial and parts list of roulette
[ルーレット基板のチュートリアル](manual/FlashAir_Tutorial_Roulette.pdf)  

### Schematic of roulette
[回路図](manual/flashair_roulette_sch.pdf)  

  
## Requirement

Check your FlashAir and firmwere version.  
v4.00.03 for W-04 or v3.00.02 for W-03 requires.

## Install

Please save the LUA folder with files in the root folder of FlashAir.

Add the following parameters to FlashAir's /SD_WLAN/CONFIG file.  
Incidentally, /SD_WLAN is a hidden folder,　so let's use a tool that can handle hidden folders.

    LUA_RUN_SCRIPT=/LUA/roulette.lua
    IFMODE=1

## tiny MML player syntax

Case-insensitive
### support Syntax
CDEFGAB  
PROLTNV  
0123456789.  
+-#<>  

Volume is supported 2 levels. V>=12 or not.   

cf. Modern MML https://en.wikipedia.org/wiki/Music_Macro_Language

## How to play

game1.lua: **Roulette**    
Power on without pressing anything. After about 5 seconds, the No.1 LED lights up.

game2.lua: **Two LED roulette**  
Turn on the power while holding down the A button, and release the No.2 LED lights up.

game3.lua: **Demonstlation lit**  
Hold down the B button and turn on the power, and release the No.3 LED lights up.

game4.lua: **Wi-Fi detector**  
Hold down the A and B buttons and turn on the power, then release A button the No.4 LED lights up.  
It periodically scans surrounding APs and displays the maximum received power.  
8 is the maximum, 1 is the minimum.

Xmas1.lua: **Xmas music player**  
Hold down the A and B buttons and turn on the power, then release B button the No.4 LED lights up.  
A button：replay and change ratio of sound.
B button: next music.

## Licence

[BSD 2-Clause "Simplified" License](https://github.com/AoiSaya/FlashAir-Roulette/blob/master/LICENSE)

## Author

[GitHub/AoiSaya](https://github.com/AoiSaya)  
[Twitter ID @La_zlo](https://twitter.com/La_zlo)
