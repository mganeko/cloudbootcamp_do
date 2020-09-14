#!/bin/bash
  
# Droplet起動からWebページのチェック、proxyの切り替えまで通しで行うスクリプト
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
if [ -e ~/ansible/inventory/new_web ]; then
  echo "-- SKIP creating droplet --"
  export TARGET=`tail -n 1 ~/ansible/inventory/new_web`
  echo " continue setup of $TARGET"
else
  echo "-- create droplet --"
  export TARGET=`sh create_droplet.sh $DROPLET_NAME`

  # --- prepare inventory ---
  cp ~/ansible/template/web.tmpl ~/ansible/inventory/new_web
  echo $TARGET >> ~/ansible/inventory/new_web
fi


# --- setup with Ansible ---
echo "-- sleep until ssh ready --"
sleep 15  # wait until ssh port ready

echo "-- setup with ansible --"
export TARGET_SERVERNAME="$SERVERNAME"
ansible-playbook -i ~/ansible/inventory/new_web ~/ansible/playbook/webserver.yml

# --- test web ---
echo "-- test web --"
sh test_web.sh "$SERVERNAME" $TARGET
TEST_CODE=$?

# --- ここから先が異なる ---
# --- report ---
if [ $TEST_CODE -ne 0 ]; then
  echo "=== WebServer Setup ERROR ==="
  exit $TEST_CODE
else
  echo "--- WebServer OK ---"
  cp ~/ansible/inventory/new_web ~/ansible/inventory/new_web.done
  rm ~/ansible/inventory/new_web
fi

# --- switch proxy ----
ansible-playbook -i ~/ansible/inventory/proxy ~/ansible/playbook/proxy.yml

# -- exit --
exit $?
