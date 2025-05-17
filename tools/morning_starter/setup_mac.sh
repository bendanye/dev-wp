#!/usr/bin/env bash

script_path=$(pwd)

cd ~/Desktop

ln -s "$script_path"/morning.command

chmod 777 morning.command

ln -s "$script_path"/morning_dev.command

chmod 777 morning_dev.command