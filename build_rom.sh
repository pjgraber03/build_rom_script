#!/bin/bash

#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


# No scrollback buffer
echo -e '\0033\0143'



# Get intial time of script startup
res1=$(date +%s.%N)



# Specify colors for shell
red='tput setaf 1'              # red
green='tput setaf 2'            # green
yellow='tput setaf 3'           # yellow
blue='tput setaf 4'             # blue
violet='tput setaf 5'           # violet
cyan='tput setaf 6'             # cyan
white='tput setaf 7'            # white
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # Bold red
bldgrn=${txtbld}$(tput setaf 2) # Bold green
bldblu=${txtbld}$(tput setaf 4) # Bold blue
bldcya=${txtbld}$(tput setaf 6) # Bold cyan
normal='tput sgr0'


tput bold
tput setaf 1
clear
echo -e "Build Any Rom"
echo -e ""
echo -e ""
echo -e ""
echo -e ""

sleep 1s

#Load Config File
source build_rom.conf

# Confirm 'repo sync'
echo -e "\n\n${bldgrn}  Do you want to repo sync before proceeding?\n"
echo ""
echo -e "${bldblu}  1. Yes"
echo -e "${bldblu}  2. No"
echo ""
echo ""
$normal
read askreposync

# Confirm 'make clean'
echo -e "\n\n${bldgrn}  Do you want to make clean?\n"
echo ""
echo -e "${bldblu}  1. Yes"
echo -e "${bldblu}  2. No"
echo ""
echo ""
$normal
read askClean

# Devices to build
echo -e "\n\n${bldgrn}  Do you want to build all devices?\n"
echo ""
echo -e "${bldblu}  1. Yes"
echo -e "${bldblu}  2. No"
echo ""
echo ""
$normal
read askdevices

echo ""
echo ""
if [ "$askreposync" == "1" ]
then
    echo -e "${bldred}  Will repo sync before starting the build... "
else
    echo -e "${bldred}  Will continue without repo syncing... "
fi
echo ""
echo ""

echo ""
echo ""

if [ "$askClean" == "1" ]
then
    echo -e "${bldred}  Compilation will continue after cleaning previous build files... "
else
    echo -e "${bldred}  ROM will be compiled without cleaning previous build files... "
fi
echo ""
echo ""

echo ""
echo ""
if [ "$askdevices" == "1" ]
then
    echo -e "${bldred}  Will build $device_1, $device_2, $device_3 " >&2
else
    echo -e "${bldred}  Will be just $my_device... " >&2
fi
echo ""
echo ""


sleep 2s


if [ "$askreposync" == "1" ]
then
        echo ""
        echo ""
        echo -e "${bldgrn}  syncing... "
        echo ""
        echo ""
        $normal
        repo sync --force-sync -j12
fi

if [ "$askClean" == "1" ]
then
        echo ""
        echo ""
        echo -e "${bldgrn}  Cleaning before starting build... "
        echo ""
        echo ""
        $normal
        make clobber
fi

if [ "$askdevices" == "1" ]
then
        echo ""
        echo ""
        echo -e "${bldgrn}  Building $device_1, $device_2, $device_3 now " >&2
        echo ""
        echo ""
        $normal
        . build/envsetup.sh && brunch $device_1 && . build/envsetup.sh && brunch $device_2 && . build/envsetup.sh && brunch $device_3
else
        echo ""
        echo ""
        echo -e "${bldgrn}  Building $my_device Now... " >&2
        echo ""
        echo""
        $normal
        . build/envsetup.sh && brunch $my_device && rm ~/Android/$rom_dir/out/target/product/$rom_dir/$ota_zip && cp ~/Android/$rom_dir/out/target/product/$my_device/nexus_*.zip ~/roms/$rom_dir/rro
fi



# Compilation complete
tput bold
tput setaf 1
echo -e ""
echo -e "Device have all been built and uploaded"
echo -e ""
echo -e ""
