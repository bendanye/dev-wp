#!/usr/bin/env bash

SCRIPT_DIR=$(pwd)

mkdir -p $SCRIPT_DIR/env

echo "SOURCE_DIR=$SCRIPT_DIR" > $SCRIPT_DIR/env/time_tracker.env

cd ~/Library/Application\ Support/xbar/plugins
ln -s "$SCRIPT_DIR"/time_tracker.10s.sh

mkdir -p ~/Library/Application\ Support/xbar/plugins/env
cd ~/Library/Application\ Support/xbar/plugins/env
ln -s "$SCRIPT_DIR"/env/time_tracker.env