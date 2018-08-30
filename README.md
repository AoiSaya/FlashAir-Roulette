# FlashAir-Roulette

## Overview

I developed and released softwere for FlashAir-Roulette.
This roulette was designed as FlashAir hands‐on experience for kids.  
And the parts kit provided as an extra bonus when FlashAir was purchased at Maker Fair Tokyo 2018.  
The parts and circuit diagrams are available from the following site.  
 [FlashAir Developers .. Maker Fair Tokyo 2018](https://flashair-developers.com/ja/about/events/makerfaire2018tokyo/)

![Roullete](https://github.com/AoiSaya/FlashAir-Roulette/blob/master/img/Roulette.png)

## Requirement

Check your FlashAir and firmwere version.
v4.00.03 for W-04 or v3.00.02 for W-03 requires.

## Install

Please save the LUA folder with files in the root folder of FlashAir.

Add the following parameters to FlashAir's /SD_WLAN/CONFIG file.
※ Because /SD_WLAN is a hidden folder, let's use a tool that can handle hidden folders.

    LUA_RUN_SCRIPT=/LUA/roulette.lua
    IFMODE=1

## How to play

**1. Roulette**    
Power on without pressing anything.

**2. Two LED roulette**  
Turn on the power while holding down the A button, and release the No.3 LED light.

**3. Demonstlation lit**  
Hold down the B button and turn on the power, and release the No.3 LED light.

**4. Wi-Fi detector**  
Hold down the A and B buttons and turn on the power, then release the No.4 LED light.
Scan the surrounding AP and display the strongest one. 8 is the maximum, 1 is the minimum.

## Licence

[BSD 2-Clause "Simplified" License](https://github.com/AoiSaya/FlashAir-Roulette/blob/master/LICENSE)

## Author

[GitHub/AoiSaya](https://github.com/AoiSaya)  
[Twitter ID @La_zlo](https://twitter.com/La_zlo)
