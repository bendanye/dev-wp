#!/usr/bin/env bash

script_path=$(pwd)

cd ~/Library/Application\ Support/xbar/plugins
ln -s "$script_path"/gitlab_build.1m.sh

mkdir -p ~/Library/Application\ Support/xbar/plugins/env
cd ~/Library/Application\ Support/xbar/plugins/env
ln -s "$script_path/../../gitlab.env"