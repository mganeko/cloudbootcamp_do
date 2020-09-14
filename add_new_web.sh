#!/bin/bash

# Droplet起動からWebページのチェックまで通しで行うスクリプト
# arg1 … Dropletの名前
# arg2 … WebServerの名前(hello.htmlで使用）

# -- default target --
DROPLET_NAME="new-droplet"
SERVERNAME="WebServer by script"

# --- 1st arg is DROPLET_NAME ---
if [ $# -ge 1 ]; then
  DROPLET_NAME=$1
fi

# --- 2nd arg is SERVERNAME ---
if [ $# -ge 2 ]; then
  SERVERNAME=$2
fi

# --- create droplet ---
echo "-- create droplet --"
export TARGET=`sh create_droplet.sh $DROPLET_NAME`

# --- update droplet ---
echo "-- wait until ssh ready --"
sleep 15  # wait until ssh port ready

echo "-- update droplet --"
sh update_droplet.sh $TARGET

#echo "-- wait until reboot --"
#sleep 15  # wait until reboot

# --- install web ---
echo "-- install web --"
sh install_web.sh "$SERVERNAME" $TARGET

# --- test web ---
echo "-- test web --"
sh test_web.sh "$SERVERNAME" $TARGET
TEST_CODE=$?

# --- report ---
if [ $TEST_CODE -ne 0 ]; then
  echo "=== WebServer Setup ERROR ==="
else
  echo "--- OK ---"
fi


# -- exit --
exit $TEST_CODE
