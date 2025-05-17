#!/usr/bin/env bash

script_path=$(pwd)

cd ~/Desktop

ln -s "$script_path"/morning_mac.command

chmod 777 morning_mac.command

ln -s "$script_path"/morning_mac_dev.command

chmod 777 morning_mac_dev.command